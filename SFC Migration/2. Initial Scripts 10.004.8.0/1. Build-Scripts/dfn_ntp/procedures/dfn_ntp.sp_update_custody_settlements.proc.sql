CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_custody_settlements (
    p_key     OUT NUMBER,
    pt78_id       NUMBER DEFAULT NULL)
IS
    l_sysdate   DATE := func_get_eod_date;
    l_t78_id    NUMBER;
BEGIN
    BEGIN
        IF (pt78_id IS NOT NULL)
        THEN
            SELECT TRUNC (t78_settlement_date)
              INTO l_sysdate
              FROM t78_custodian_wise_settlements
             WHERE t78_id = pt78_id;
        END IF;

        FOR i
            IN (SELECT   a.t02_cash_settle_date,
                         a.t02_custodian_id_m26,
                         a.t02_exchange_code_m01,
                         a.t02_txn_currency,
                         a.t02_inst_id_m02,
                         SUM (a.t02_commission_adjst) total_commission,
                         SUM (a.t02_exg_commission) exchange_commission,
                         SUM (a.t02_exchange_tax) exchange_tax,
                         SUM (a.t02_broker_tax) broker_tax
                    FROM t02_transaction_log a
                   WHERE     t02_update_type IN (1)
                         AND t02_custodian_type_v01 = 1
                         AND a.t02_trade_process_stat_id_v01 = 25        -- TD
                         AND t02_txn_code NOT IN ('REVBUY', 'REVSEL')
                         AND t02_txn_entry_status = 0
                         AND a.t02_cash_settle_date BETWEEN TRUNC (l_sysdate)
                                                        AND   TRUNC (l_sysdate)
                                                            + 0.99999
                GROUP BY a.t02_cash_settle_date,
                         a.t02_custodian_id_m26,
                         a.t02_exchange_code_m01,
                         a.t02_txn_currency,
                         a.t02_inst_id_m02)
        LOOP
            IF (pt78_id IS NULL)
            THEN
                l_t78_id := fn_get_t78_id;

                INSERT INTO t82_custodian_settlements_log
                    SELECT l_t78_id, t02_last_db_seq_id
                      FROM t02_transaction_log a
                     WHERE     t02_custodian_type_v01 = 1
                           AND t02_update_type = 1
                           AND t02_trade_process_stat_id_v01 = 25
                           AND t02_txn_code NOT IN ('REVBUY', 'REVSEL')
                           AND t02_txn_entry_status = 0
                           AND t02_cash_settle_date = i.t02_cash_settle_date
                           AND t02_custodian_id_m26 = i.t02_custodian_id_m26
                           AND t02_exchange_code_m01 =
                                   i.t02_exchange_code_m01
                           AND t02_txn_currency = i.t02_txn_currency
                           AND t02_inst_id_m02 = i.t02_inst_id_m02;

                INSERT
                  INTO t78_custodian_wise_settlements (
                           t78_id,
                           t78_custodian_id_m26,
                           t78_created_datetime,
                           t78_settlement_date,
                           t78_currency_code_m03,
                           t78_exchange_commission,
                           t78_brokerage_commission,
                           t78_exchange_commission_vat,
                           t78_brokerage_commission_vat,
                           t78_tot_recived_from_custodian,
                           t78_recived_procesed_by_id_u17,
                           t78_recived_processed_date,
                           t78_institute_id_m02,
                           t78_exchange_code_m01)
                    VALUES (
                               l_t78_id,
                               i.t02_custodian_id_m26,
                               SYSDATE,
                               i.t02_cash_settle_date,
                               i.t02_txn_currency,
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
                DELETE t82_custodian_settlements_log
                 WHERE t82_id_t78 = pt78_id;

                INSERT INTO t82_custodian_settlements_log
                    SELECT pt78_id, t02_last_db_seq_id
                      FROM t02_transaction_log a
                     WHERE     t02_custodian_type_v01 = 1
                           AND t02_update_type = 1
                           AND t02_trade_process_stat_id_v01 = 25
                           AND t02_txn_code NOT IN ('REVBUY', 'REVSEL')
                           AND t02_txn_entry_status = 0
                           AND t02_cash_settle_date = i.t02_cash_settle_date
                           AND t02_custodian_id_m26 = i.t02_custodian_id_m26
                           AND t02_exchange_code_m01 =
                                   i.t02_exchange_code_m01
                           AND t02_txn_currency = i.t02_txn_currency
                           AND t02_inst_id_m02 = i.t02_inst_id_m02;


                UPDATE t78_custodian_wise_settlements
                   SET t78_exchange_commission = i.exchange_commission,
                       t78_brokerage_commission =
                           i.total_commission - i.exchange_commission,
                       t78_exchange_commission_vat = i.exchange_tax,
                       t78_brokerage_commission_vat = i.broker_tax
                 WHERE t78_id = pt78_id;
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