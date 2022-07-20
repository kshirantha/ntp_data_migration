CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_custody_txn_charges
IS
    l_fx_rate_for_nastro   NUMBER;
    l_charge_amount        NUMBER;
BEGIN
    FOR i
        IN (SELECT trading_acc_id,
                   customer_id,
                   cash_account_id,
                   net_volume,
                   custodian_id,
                   activity_type,
                   trans_currency,
                   fn_get_custody_charge_amount (custodian_id,
                                                 activity_type,
                                                 net_volume,
                                                 trans_currency,
                                                 instrument_type_code)
                       AS custody_charge,
                   get_exchange_rate (t02_inst_id_m02,
                                      trans_currency,
                                      settle_currency)
                       AS exchange_rate,
                   m72.m72_id,
                   m72.m72_currency_id_m03,
                   m72.m72_currency_code_m03,
                   t02_inst_id_m02
              FROM     (  SELECT trading_acc_id,
                                 customer_id,
                                 cash_account_id,
                                 custodian_id,
                                 activity_type,
                                 t02_symbol_id_m20,
                                 SUM (qty) AS net_volume,
                                 MAX (trans_currency) AS trans_currency,
                                 MAX (settle_currency) AS settle_currency,
                                 MAX (instrument_type_code)
                                     AS instrument_type_code,
                                 MAX (t02_create_datetime)
                                     AS t02_create_datetime,
                                 t02_inst_id_m02
                            FROM     (SELECT *
                                        FROM (SELECT t02.t02_trd_acnt_id_u07
                                                         AS trading_acc_id,
                                                     t02.t02_customer_id_u01
                                                         AS customer_id,
                                                     t02.t02_cash_acnt_id_u06
                                                         AS cash_account_id,
                                                     t02.t02_custodian_id_m26
                                                         AS custodian_id,
                                                     CASE
                                                         WHEN t02_txn_code =
                                                                  'PLGIN'
                                                         THEN
                                                             3
                                                         WHEN t02_txn_code =
                                                                  'PLGOUT'
                                                         THEN
                                                             4
                                                     END
                                                         AS activity_type,
                                                     t02.t02_pledge_qty AS qty,
                                                     t02.t02_txn_currency
                                                         AS trans_currency,
                                                     t02.t02_settle_currency
                                                         AS settle_currency,
                                                     t02.t02_symbol_id_m20,
                                                     t02.t02_symbol_code_m20,
                                                     t02.t02_instrument_type
                                                         AS instrument_type_code,
                                                     t02_txn_code,
                                                     t02_create_datetime,
                                                     t02.t02_inst_id_m02
                                                FROM t02_transaction_log t02
                                               WHERE t02_txn_code IN
                                                         ('PLGIN', 'PLGOUT')
                                              UNION ALL
                                              SELECT t02.t02_trd_acnt_id_u07
                                                         AS trading_acc_id,
                                                     t02.t02_customer_id_u01
                                                         AS customer_id,
                                                     t02.t02_cash_acnt_id_u06
                                                         AS u07_cash_account_id_u06,
                                                     t02.t02_custodian_id_m26
                                                         AS custodian_id,
                                                     5 AS activity_type,
                                                     ABS (
                                                         t02.t02_holding_net_adjst)
                                                         AS qty,
                                                     t02.t02_txn_currency
                                                         AS trans_currency,
                                                     t02.t02_settle_currency
                                                         AS settle_currency,
                                                     t02.t02_symbol_id_m20,
                                                     t02.t02_symbol_code_m20,
                                                     t02.t02_instrument_type
                                                         AS instrument_type_code,
                                                     t02_txn_code,
                                                     t02_create_datetime,
                                                     t02_inst_id_m02
                                                FROM t02_transaction_log t02
                                               WHERE     t02_txn_code =
                                                             'HLDTRN'
                                                     AND t02_holding_net_adjst <
                                                             0) t02
                                       WHERE t02.t02_create_datetime BETWEEN TRUNC (
                                                                                 SYSDATE)
                                                                         AND   TRUNC (
                                                                                   SYSDATE)
                                                                             + 0.99999) trans
                                 INNER JOIN
                                     u07_trading_account u07
                                 ON trans.trading_acc_id = u07.u07_id
                        GROUP BY t02_inst_id_m02,
                                 trading_acc_id,
                                 customer_id,
                                 cash_account_id,
                                 custodian_id,
                                 activity_type,
                                 t02_symbol_id_m20) custody_tran
                   INNER JOIN
                       m72_exec_broker_cash_account m72
                   ON custody_tran.custodian_id = m72.m72_exec_broker_id_m26
             WHERE m72.m72_is_default = 1)
    LOOP
        l_fx_rate_for_nastro :=
            get_exchange_rate (i.t02_inst_id_m02,
                               i.trans_currency,
                               i.m72_currency_code_m03);


        l_charge_amount :=
            NVL (i.custody_charge, 0) * NVL (i.exchange_rate, 0);

        IF (l_charge_amount > 0)
        THEN
            INSERT INTO a13_cash_holding_adjust_log (a13_id,
                                                     a13_job_id_v07,
                                                     a13_created_date,
                                                     a13_cash_account_id_u06,
                                                     a13_u06_balance,
                                                     a13_code_m97,
                                                     a13_impact_type,
                                                     a13_t02_required)
                 VALUES (seq_a13_id.NEXTVAL,
                         21,
                         TRUNC (SYSDATE),
                         i.cash_account_id,
                         i.custody_charge * i.exchange_rate,
                         'CUDYTRNFEE',
                         2,
                         1);



            UPDATE m72_exec_broker_cash_account
               SET m72_balance = m72_balance + l_charge_amount
             WHERE m72_id = i.m72_id;


            INSERT INTO t07_nastro_account_log (t07_id,
                                                t07_institute_id_m02,
                                                t07_custodian_id_m26,
                                                t07_nastro_acc_id_m72,
                                                t07_txn_id_m97,
                                                t07_txn_code_m97,
                                                t07_amnt_in_stl_currency,
                                                t07_amnt_in_txn_currency,
                                                t07_fx_rate,
                                                t07_txn_date,
                                                t07_txn_currency_code_m03,
                                                t07_stl_currency_code_m03,
                                                t07_trans_activity_id_v01,
                                                t07_custom_type)
                 VALUES (seq_t07_id.NEXTVAL,
                         i.t02_inst_id_m02,
                         i.custodian_id,
                         i.m72_id,
                         47,
                         'CUDYTRNFEE',
                         l_charge_amount,
                         i.custody_charge,
                         l_fx_rate_for_nastro,
                         SYSDATE,
                         i.trans_currency,
                         i.m72_currency_code_m03,
                         1,
                         '1');
        END IF;
    END LOOP;
END;
/
