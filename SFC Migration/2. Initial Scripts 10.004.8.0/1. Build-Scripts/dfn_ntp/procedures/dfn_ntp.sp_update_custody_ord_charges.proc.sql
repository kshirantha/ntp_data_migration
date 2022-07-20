CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_custody_ord_charges
IS
    p_from_date            DATE;
    p_to_date              DATE;
    l_fx_rate_for_nastro   NUMBER;
    l_charge_amount        NUMBER;
BEGIN
    FOR i
        IN (SELECT t01_custodian_id_m26,
                   t01_symbol_id_m20,
                   t01_cash_acc_id_u06,
                   t01_institution_id_m02,
                   trans_currency,
                   settle_currency,
                   fn_get_custody_charge_amount (t01_custodian_id_m26,
                                                 1,
                                                 net_volume,
                                                 trans_currency,
                                                 instrument_type_code)
                       AS custody_charge,
                   get_exchange_rate (t01_institution_id_m02,
                                      trans_currency,
                                      settle_currency)
                       AS exchange_rate,
                   m72.m72_id,
                   m72.m72_currency_id_m03,
                   m72.m72_currency_code_m03
              FROM     (  SELECT t01.t01_customer_id_u01,
                                 t01.t01_custodian_id_m26,
                                 t01.t01_symbol_id_m20,
                                 t01_cash_acc_id_u06,
                                 SUM (volume) AS net_volume,
                                 MAX (t01_symbol_currency_code_m03)
                                     AS trans_currency,
                                 MAX (t01_settle_currency) AS settle_currency,
                                 MAX (t01_instrument_type_code)
                                     AS instrument_type_code,
                                 t01_institution_id_m02
                            FROM (SELECT t01_customer_id_u01,
                                         t01_custodian_id_m26,
                                         t01_symbol_id_m20,
                                         t01_cash_acc_id_u06,
                                         t01_settle_currency,
                                         t01_symbol_currency_code_m03,
                                         t01_institution_id_m02,
                                         t01_instrument_type_code,
                                         CASE
                                             WHEN t01_side = 1
                                             THEN
                                                 t01_cum_quantity
                                             ELSE
                                                 t01_cum_quantity * -1
                                         END
                                             AS volume
                                    FROM t01_order a
                                   WHERE     t01_status_id_v30 IN
                                                 ('2',
                                                  '1',
                                                  '4',
                                                  'C',
                                                  'q',
                                                  'r',
                                                  '5')
                                         AND t01_cum_quantity > 0
                                         AND t01_holding_settle_date BETWEEN TRUNC (
                                                                                 SYSDATE)
                                                                         AND   TRUNC (
                                                                                   SYSDATE)
                                                                             + 0.99999) t01
                        GROUP BY t01.t01_institution_id_m02,
                                 t01.t01_customer_id_u01,
                                 t01.t01_custodian_id_m26,
                                 t01_cash_acc_id_u06,
                                 t01.t01_symbol_id_m20) custody_tran
                   INNER JOIN
                       m72_exec_broker_cash_account m72
                   ON custody_tran.t01_custodian_id_m26 =
                          m72.m72_exec_broker_id_m26
             WHERE m72.m72_is_default = 1)
    LOOP
        l_charge_amount :=
            NVL (i.custody_charge, 0) * NVL (i.exchange_rate, 0);

        IF (l_charge_amount > 0)
        THEN
            l_fx_rate_for_nastro :=
                get_exchange_rate (i.t01_institution_id_m02,
                                   i.trans_currency,
                                   i.m72_currency_code_m03);

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
                         i.t01_cash_acc_id_u06,
                         l_charge_amount,
                         'CUDYORDFEE',
                         2,
                         1);



            UPDATE m72_exec_broker_cash_account
               SET m72_balance =
                       m72_balance + i.custody_charge * l_fx_rate_for_nastro
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
                         i.t01_institution_id_m02,
                         i.t01_custodian_id_m26,
                         i.m72_id,
                         47,
                         'CUDYORDFEE',
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
