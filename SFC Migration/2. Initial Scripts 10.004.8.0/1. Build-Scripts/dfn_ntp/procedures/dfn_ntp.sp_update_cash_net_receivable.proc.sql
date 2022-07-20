CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_cash_net_receivable
IS
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    FOR i
        IN (SELECT u06_id,
                   t02_cash_acnt_id_u06,
                   t02_cash_settle_date,
                   net_recievable,
                   u06_receivable_amount,
                   u06_payable_blocked,
                   u06_net_receivable,
                   ROW_NUMBER ()
                   OVER (PARTITION BY t02_cash_acnt_id_u06
                         ORDER BY t02_cash_acnt_id_u06, t02_cash_settle_date)
                       AS rownumber_t02
              FROM     (SELECT u06_id,
                               u06_receivable_amount,
                               u06_payable_blocked,
                               u06_net_receivable
                          FROM u06_cash_account
                         WHERE     u06_currency_code_m03 = 'SAR'
                               AND u06_net_receivable IS NOT NULL
                               AND u06_net_receivable <> 0) u06
                   FULL OUTER JOIN
                       (  SELECT t02_cash_acnt_id_u06,
                                 t02_cash_settle_date,
                                 SUM (t02_amnt_in_stl_currency) net_recievable
                            FROM t02_transaction_log
                           WHERE     t02_txn_code IN
                                         ('STLBUY',
                                          'STLSEL',
                                          'STKSUB',
                                          'REVSUB')
                                 AND t02_update_type IN (1)
                                 AND t02_last_shares > 0
                                 AND t02_txn_entry_status = 0
                                 AND (   t02_cash_settle_date >
                                             func_get_eod_date
                                      OR t02_trade_process_stat_id_v01 IN
                                             (1, 21)) -- TP Changes | or pending , pending approve
                                 AND t02_create_date > SYSDATE - 20
                        GROUP BY t02_cash_acnt_id_u06, t02_cash_settle_date
                        ORDER BY t02_cash_acnt_id_u06, t02_cash_settle_date)
                   ON u06.u06_id = t02_cash_acnt_id_u06)
    LOOP
        UPDATE a13_cash_holding_adjust_log
           SET a13_u06_net_receivable =
                       -1
                     * CASE
                           WHEN i.t02_cash_acnt_id_u06 IS NOT NULL
                           THEN
                               DECODE (i.rownumber_t02,
                                       1, NVL (i.u06_net_receivable, 0),
                                       0)
                           ELSE
                               NVL (i.u06_net_receivable, 0)
                       END
                   + (CASE
                          WHEN     NVL (i.net_recievable, 0) < 0
                               AND   a13_u06_net_receivable
                                   + NVL (i.net_recievable, 0) > 0
                          THEN
                                a13_u06_net_receivable
                              + NVL (i.net_recievable, 0)
                          WHEN     NVL (i.net_recievable, 0) < 0
                               AND   a13_u06_net_receivable
                                   + NVL (i.net_recievable, 0) < 0
                          THEN
                              0
                          WHEN NVL (i.net_recievable, 0) > 0
                          THEN
                                a13_u06_net_receivable
                              + NVL (i.net_recievable, 0)
                          ELSE
                              0
                      END)
         WHERE     a13_cash_account_id_u06 =
                       NVL (i.t02_cash_acnt_id_u06, i.u06_id)
               AND a13_created_date = TRUNC (SYSDATE)
               AND a13_adjust_status = 0;


        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;
END;
/