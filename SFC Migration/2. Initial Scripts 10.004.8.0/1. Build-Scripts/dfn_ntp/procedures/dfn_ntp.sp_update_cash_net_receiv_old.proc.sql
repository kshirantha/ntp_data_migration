CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_cash_net_receiv_old
IS
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    FOR i
        IN (SELECT u06_id
              FROM u06_cash_account a
             WHERE     u06_currency_code_m03 = 'SAR'
                   AND u06_net_receivable <> 0
                   AND u06_last_activity_date > TRUNC (SYSDATE) - 20)
    LOOP
        UPDATE u06_cash_account
           SET u06_net_receivable = 0
         WHERE u06_id = i.u06_id;

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;

    l_rec_count := 0;

    FOR i
        IN (  SELECT t02_cash_acnt_id_u06,
                     t02_cash_settle_date,
                     SUM (t02_amnt_in_stl_currency) net_recievable
                FROM t02_transaction_log_cash_all a
               WHERE     t02_txn_code IN
                             ('STLBUY', 'STLSEL', 'STKSUB', 'REVSUB')
                     AND (   t02_cash_settle_date > func_get_eod_date
                          OR t02_trade_process_stat_id_v01 IN (1, 21)) -- TP Changes | or pending , pending approve
                     AND t02_create_date > TRUNC (SYSDATE) - 20
            GROUP BY t02_cash_acnt_id_u06, t02_cash_settle_date
            ORDER BY t02_cash_acnt_id_u06, t02_cash_settle_date)
    LOOP
        UPDATE u06_cash_account u06
           SET u06.u06_net_receivable =
                   (CASE
                        WHEN     i.net_recievable < 0
                             AND u06_net_receivable + i.net_recievable > 0
                        THEN
                            u06_net_receivable + i.net_recievable
                        WHEN     i.net_recievable < 0
                             AND u06_net_receivable + i.net_recievable < 0
                        THEN
                            0
                        WHEN i.net_recievable > 0
                        THEN
                            u06_net_receivable + i.net_recievable
                        ELSE
                            0
                    END)
         WHERE u06.u06_id = i.t02_cash_acnt_id_u06;

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;


    COMMIT;

    l_rec_count := 0;

    FOR i
        IN (SELECT u06_id
              FROM u06_cash_account u06
             WHERE     u06_currency_code_m03 = 'SAR'
                   AND u06_net_receivable > u06.u06_receivable_amount)
    LOOP
        UPDATE u06_cash_account
           SET u06_net_receivable = u06_receivable_amount
         WHERE u06_id = i.u06_id;

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;
END;
/