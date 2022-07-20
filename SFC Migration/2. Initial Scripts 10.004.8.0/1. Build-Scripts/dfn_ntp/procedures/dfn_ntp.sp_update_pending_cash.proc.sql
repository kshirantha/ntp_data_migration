CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_pending_cash (
    psettle_customer IN NUMBER)
IS
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    IF psettle_customer = 0                                             -- SOD
    THEN
        l_rec_count := 0;

        FOR i IN (SELECT t02_cash_acnt_id_u06,
                         t02_trd_acnt_id_u07,
                         pending_settle,
                         payable_amount,
                         u06_id,
                         u06_receivable_amount,
                         u06_payable_blocked,
                         u06_net_receivable
                    FROM     (SELECT u06_id,
                                     u06_receivable_amount,
                                     u06_payable_blocked,
                                     u06_net_receivable
                                FROM u06_cash_account
                               WHERE (   u06_receivable_amount <> 0
                                      OR u06_payable_blocked <> 0
                                      OR u06_net_receivable <> 0)) u06
                         FULL OUTER JOIN
                             (  SELECT t02_cash_acnt_id_u06,
                                       t02_trd_acnt_id_u07,
                                       SUM (
                                           CASE
                                               WHEN t02_amnt_in_stl_currency >
                                                        0
                                               THEN
                                                   t02_amnt_in_stl_currency
                                               ELSE
                                                   0
                                           END)
                                           AS pending_settle,
                                       SUM (
                                           CASE
                                               WHEN t02_amnt_in_stl_currency <
                                                        0
                                               THEN
                                                   t02_amnt_in_stl_currency
                                               ELSE
                                                   0
                                           END)
                                           AS payable_amount
                                  FROM t02_transaction_log t02,
                                       m01_exchanges m01
                                 WHERE     t02.t02_exchange_id_m01 = m01.m01_id
                                       AND t02_update_type IN (1, 6)
                                       AND t02_txn_entry_status = 0
                                       AND t02_last_shares > 0
                                       AND t02_create_date >= SYSDATE - 30
                                       AND (   t02_cash_settle_date >=
                                                     func_get_eod_date
                                                   + 1 -- Make It as Current Date (SOD Job)
                                                   + CASE
                                                         WHEN m01_settle_customer =
                                                                  1
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
                              GROUP BY t02_cash_acnt_id_u06,
                                       t02_trd_acnt_id_u07) t02
                         ON u06.u06_id = t02.t02_cash_acnt_id_u06)
        LOOP
            INSERT
              INTO a13_cash_holding_adjust_log (a13_id,
                                                a13_job_id_v07,
                                                a13_created_date,
                                                a13_cash_account_id_u06,
                                                a13_u24_trading_acnt_id_u07,
                                                a13_u06_payable_blocked,
                                                a13_u06_receivable_amount,
                                                a13_u06_net_receivable,
                                                a13_impact_type,
                                                a13_code_m97,
                                                a13_t02_required)
            VALUES (
                       seq_a13_id.NEXTVAL,
                       5,
                       TRUNC (SYSDATE),
                       NVL (i.t02_cash_acnt_id_u06, i.u06_id),
                       i.t02_trd_acnt_id_u07,
                         -1 * NVL (i.u06_payable_blocked, 0)
                       + NVL (ABS (i.payable_amount), 0),
                         -1 * NVL (i.u06_receivable_amount, 0)
                       + NVL (ABS (i.pending_settle), 0),
                       0,
                       2,
                       'CPNDNG_ADJ',
                       0);

            l_rec_count := l_rec_count + 1;

            IF MOD (l_rec_count, l_commit_blk_size) = 0
            THEN
                COMMIT;
            END IF;
        END LOOP;

        COMMIT;
    ELSE                                                                -- EOD
        l_rec_count := 0;

        UPDATE t02_transaction_log
           SET t02_cash_settle_date = func_get_eod_date + 1
         WHERE     t02_order_no IN
                       (SELECT t02_order_no FROM t02_transaction_log_order)
               AND t02_create_date >= SYSDATE - 30
               AND t02_cash_settle_date = func_get_eod_date
               AND t02_fail_management_status IN (4)       -- 4 ICM Fail Chain
               AND t02_txn_code IN ('STLBUY', 'STLSEL')
               AND t02_settle_currency = 'SAR'; -- Consider SAR Cash Account as Local

        FOR i
            IN (  SELECT t02_cash_acnt_id_u06,
                         t02_trd_acnt_id_u07,
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
                    FROM (SELECT t02_cash_acnt_id_u06,
                                 t02_trd_acnt_id_u07,
                                 t02_amnt_in_stl_currency
                            FROM t02_transaction_log t02, m01_exchanges m01
                           WHERE     t02.t02_exchange_id_m01 = m01.m01_id
                                 AND t02_update_type IN (1, 6)
                                 AND t02_txn_entry_status = 0
                                 AND t02_trade_process_stat_id_v01 IN (24, 25)
                                 AND t02_create_date >= SYSDATE - 30
                                 AND t02_cash_settle_date = func_get_eod_date
                                 AND t02_last_shares > 0
                                 AND t02_txn_code IN
                                         ('STLBUY',
                                          'STKSUB',
                                          'STLSEL',
                                          'REVSUB')
                                 AND t02_settle_currency = 'SAR')
                GROUP BY t02_cash_acnt_id_u06, t02_trd_acnt_id_u07)
        LOOP
            INSERT
              INTO a13_cash_holding_adjust_log (a13_id,
                                                a13_job_id_v07,
                                                a13_created_date,
                                                a13_cash_account_id_u06,
                                                a13_u24_trading_acnt_id_u07,
                                                a13_u06_payable_blocked,
                                                a13_u06_receivable_amount,
                                                a13_u06_net_receivable,
                                                a13_impact_type,
                                                a13_code_m97,
                                                a13_t02_required)
            VALUES (seq_a13_id.NEXTVAL,
                    6,
                    TRUNC (SYSDATE),
                    i.t02_cash_acnt_id_u06,
                    i.t02_trd_acnt_id_u07,
                    -ABS (i.payable_amount),
                    -i.pending_settle,
                    0,
                    2,
                    'CPNDNG_ADJ',
                    0);

            l_rec_count := l_rec_count + 1;

            IF MOD (l_rec_count, l_commit_blk_size) = 0
            THEN
                COMMIT;
            END IF;
        END LOOP;

        COMMIT;
    END IF;

    sp_update_cash_net_receivable;
END;
/
