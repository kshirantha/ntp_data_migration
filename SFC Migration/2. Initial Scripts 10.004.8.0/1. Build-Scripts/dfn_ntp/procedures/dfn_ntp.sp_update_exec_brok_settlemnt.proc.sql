CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_exec_brok_settlemnt (
    p_key     OUT NUMBER,
    pt83_id       NUMBER DEFAULT NULL)
IS
    l_sysdate   DATE := func_get_eod_date - 14;
    l_t83_id    NUMBER;
BEGIN
    BEGIN
        IF (pt83_id IS NOT NULL)
        THEN
            SELECT TRUNC (t83_settlement_date)
              INTO l_sysdate
              FROM t83_exec_broker_wise_settlmnt
             WHERE t83_id = pt83_id;
        END IF;

        FOR i
            IN (  SELECT a.t02_cash_settle_date,
                         a.t02_exec_broker_id_m26,
                         a.t02_exchange_code_m01,
                         a.t02_txn_currency,
                         a.t02_inst_id_m02,
                         SUM (a.t02_ord_value_adjst) order_value,
                         SUM (a.t02_commission_adjst) total_commission,
                         SUM (a.t02_exg_commission) exchange_commission,
                         SUM (a.t02_exchange_tax) exchange_tax,
                         SUM (a.t02_broker_tax) broker_tax
                    FROM t02_transaction_log a
                   WHERE     t02_custodian_type_v01 <> 1
                         AND t02_update_type = 1
                         AND t02_trade_process_stat_id_v01 = 25
                         AND t02_txn_code NOT IN ('REVBUY', 'REVSEL')
                         AND t02_txn_entry_status = 0
                         AND a.t02_cash_settle_date BETWEEN TRUNC (l_sysdate)
                                                        AND   TRUNC (l_sysdate)
                                                            + 0.99999
                GROUP BY a.t02_cash_settle_date,
                         a.t02_exec_broker_id_m26,
                         a.t02_exchange_code_m01,
                         a.t02_txn_currency,
                         a.t02_inst_id_m02)
        LOOP
            IF (pt83_id IS NULL)
            THEN
                SELECT MAX (NVL (t83_id, 0)) + 1
                  INTO l_t83_id
                  FROM t83_exec_broker_wise_settlmnt;


                INSERT INTO t88_exec_broker_settlemnt_log
                    SELECT l_t83_id, t02_last_db_seq_id
                      FROM t02_transaction_log a
                     WHERE     t02_custodian_type_v01 <> 1
                           AND t02_update_type = 1
                           AND t02_trade_process_stat_id_v01 = 25
                           AND t02_txn_code NOT IN ('REVBUY', 'REVSEL')
                           AND t02_txn_entry_status = 0
                           AND t02_cash_settle_date = i.t02_cash_settle_date
                           AND t02_exec_broker_id_m26 =
                                   i.t02_exec_broker_id_m26
                           AND t02_exchange_code_m01 =
                                   i.t02_exchange_code_m01
                           AND t02_txn_currency = i.t02_txn_currency
                           AND t02_inst_id_m02 = i.t02_inst_id_m02;

                INSERT
                  INTO t83_exec_broker_wise_settlmnt (
                           t83_id,
                           t83_exec_broker_id_m26,
                           t83_created_datetime,
                           t83_settlement_date,
                           t83_currency_code_m03,
                           t83_order_value,
                           t83_exchange_commission,
                           t83_brokerage_commission,
                           t83_exchange_commission_vat,
                           t83_brokerage_commission_vat,
                           t83_tot_recived_from_exec_brok,
                           t83_recived_procesed_by_id_u17,
                           t83_recived_processed_date,
                           t83_institute_id_m02,
                           t83_exchange_code_m01)
                VALUES (l_t83_id,
                        i.t02_exec_broker_id_m26,
                        SYSDATE,
                        i.t02_cash_settle_date,
                        i.t02_txn_currency,
                        i.order_value,
                        i.exchange_commission,
                        i.total_commission - i.exchange_commission,
                        i.exchange_tax,
                        i.broker_tax,
                        0,
                        NULL,
                        NULL,
                        i.t02_inst_id_m02,
                        i.t02_exchange_code_m01);
            ELSE
                DELETE t88_exec_broker_settlemnt_log
                 WHERE t88_id_t83 = pt83_id;

                INSERT INTO t88_exec_broker_settlemnt_log
                    SELECT pt83_id, t02_last_db_seq_id
                      FROM t02_transaction_log a
                     WHERE     t02_custodian_type_v01 <> 1
                           AND t02_update_type = 1
                           AND t02_trade_process_stat_id_v01 = 25
                           AND t02_txn_code NOT IN ('REVBUY', 'REVSEL')
                           AND t02_txn_entry_status = 0
                           AND t02_cash_settle_date = i.t02_cash_settle_date
                           AND t02_exec_broker_id_m26 =
                                   i.t02_exec_broker_id_m26
                           AND t02_exchange_code_m01 =
                                   i.t02_exchange_code_m01
                           AND t02_txn_currency = i.t02_txn_currency
                           AND t02_inst_id_m02 = i.t02_inst_id_m02;

                UPDATE t83_exec_broker_wise_settlmnt
                   SET t83_order_value = i.order_value,
                       t83_exchange_commission = i.exchange_commission,
                       t83_brokerage_commission =
                           i.total_commission - i.exchange_commission,
                       t83_exchange_commission_vat = i.exchange_tax,
                       t83_brokerage_commission_vat = i.broker_tax
                 WHERE t83_id = pt83_id;
            END IF;
        END LOOP;

        p_key := 1;
    EXCEPTION
        WHEN OTHERS
        THEN
            p_key := -1;
            RETURN;
    END;
END;
/