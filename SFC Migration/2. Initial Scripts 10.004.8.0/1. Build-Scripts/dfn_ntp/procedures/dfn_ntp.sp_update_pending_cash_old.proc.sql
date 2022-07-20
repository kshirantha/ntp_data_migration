CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_pending_cash_old (
    psettle_customer IN NUMBER)
IS
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    IF psettle_customer = 0 -- SOD
    THEN
        l_rec_count := 0;

        UPDATE u06_cash_account u06
           SET u06.u06_receivable_amount = 0, u06.u06_payable_blocked = 0
         WHERE u06.u06_currency_code_m03 = 'SAR'; -- Consider SAR Cash Account as Local

        COMMIT;

        FOR i
            IN (  SELECT t02_cash_acnt_id_u06,
                         SUM (
                             CASE
                                 WHEN t02_amnt_in_stl_currency > 0
                                 THEN
                                     t02_amnt_in_stl_currency
                                 ELSE
                                     0
                             END)
                             AS pending_settle,
                         SUM (
                             CASE
                                 WHEN t02_amnt_in_stl_currency < 0
                                 THEN
                                     t02_amnt_in_stl_currency
                                 ELSE
                                     0
                             END)
                             AS payable_amount
                    FROM (SELECT t02_cash_acnt_id_u06, t02_amnt_in_stl_currency
                            FROM t02_transaction_log_order_all, m01_exchanges
                           WHERE     t02_exchange_code_m01 = m01_exchange_code
                                 AND t02_order_no IN
                                         (SELECT t02_order_no
                                            FROM t02_transaction_log_order_all)
                                 AND t02_create_date >= func_get_eod_date - 30
                                 AND (   t02_cash_settle_date >=
                                               func_get_eod_date
                                             + 1 -- Make It as Current Date (SOD Job)
                                             + CASE
                                                   WHEN m01_settle_customer = 1
                                                   THEN
                                                       0
                                                   ELSE
                                                       1
                                               END
                                      OR t02_trade_process_stat_id_v01 IN
                                             (1, 21))
                                 AND t02_txn_code IN
                                         ('STLBUY',
                                          'STKSUB',
                                          'STLSEL',
                                          'REVSUB')
                                 AND t02_settle_currency = 'SAR')
                GROUP BY t02_cash_acnt_id_u06)
        LOOP
            UPDATE u06_cash_account
               SET u06_receivable_amount = i.pending_settle,
                   u06_payable_blocked = ABS (i.payable_amount)
             WHERE u06_id = i.t02_cash_acnt_id_u06;

            l_rec_count := l_rec_count + 1;

            IF MOD (l_rec_count, l_commit_blk_size) = 0
            THEN
                COMMIT;
            END IF;
        END LOOP;

        COMMIT;
    ELSE -- EOD
        l_rec_count := 0;

        UPDATE t02_transaction_log
           SET t02_cash_settle_date = func_get_eod_date + 1
         WHERE     t02_order_no IN
                       (SELECT t02_order_no FROM t02_transaction_log_order)
               AND t02_create_date >= func_get_eod_date - 30
               AND t02_cash_settle_date = func_get_eod_date
               AND t02_fail_management_status IN (4) --1 - ICM Reject | 2 - ICM Settle | 3 - Buy In | 4 - ICM Fail Chain | 5 - ICM Recapture
               AND t02_txn_code IN ('STLBUY', 'STLSEL')
               AND t02_settle_currency = 'SAR'; -- Consider SAR Cash Account as Local


        FOR i
            IN (  SELECT t02_cash_acnt_id_u06,
                         SUM (
                             CASE
                                 WHEN t02_amnt_in_stl_currency > 0
                                 THEN
                                     t02_amnt_in_stl_currency
                                 ELSE
                                     0
                             END)
                             AS pending_settle,
                         SUM (
                             CASE
                                 WHEN t02_amnt_in_stl_currency < 0
                                 THEN
                                     t02_amnt_in_stl_currency
                                 ELSE
                                     0
                             END)
                             AS payable_amount
                    FROM (SELECT t02_cash_acnt_id_u06, t02_amnt_in_stl_currency
                            FROM t02_transaction_log_order_all, m01_exchanges
                           WHERE     t02_exchange_code_m01 = m01_exchange_code
                                 AND t02_order_no IN
                                         (SELECT t02_order_no
                                            FROM t02_transaction_log_order)
                                 AND t02_create_date >= func_get_eod_date - 30
                                 AND t02_cash_settle_date = func_get_eod_date
                                 AND t02_trade_process_stat_id_v01 IN (24, 25)
                                 AND t02_txn_code IN
                                         ('STLBUY',
                                          'STKSUB',
                                          'STLSEL',
                                          'REVSUB')
                                 AND t02_settle_currency = 'SAR')
                GROUP BY t02_cash_acnt_id_u06)
        LOOP
            UPDATE u06_cash_account
               SET u06_receivable_amount =
                       u06_receivable_amount - i.pending_settle,
                   u06_payable_blocked =
                       u06_payable_blocked - ABS (i.payable_amount)
             WHERE u06_id = i.t02_cash_acnt_id_u06;

            l_rec_count := l_rec_count + 1;

            IF MOD (l_rec_count, l_commit_blk_size) = 0
            THEN
                COMMIT;
            END IF;
        END LOOP;

        COMMIT;
    END IF;

    sp_update_cash_net_receiv_old;
END;
/