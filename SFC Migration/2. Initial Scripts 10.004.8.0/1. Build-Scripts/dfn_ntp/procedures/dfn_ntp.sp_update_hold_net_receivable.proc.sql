CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_hold_net_receivable
IS
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    FOR i
        IN (SELECT t02_trd_acnt_id_u07,
                   t02_custodian_id_m26,
                   t02_symbol_id_m20,
                   t02_holding_settle_date,
                   net_recievable_hld,
                   u24_trading_acnt_id_u07,
                   u24_custodian_id_m26,
                   u24_symbol_id_m20,
                   u24_receivable_holding,
                   u24_payable_holding,
                   u24_net_receivable,
                   ROW_NUMBER ()
                   OVER (
                       PARTITION BY t02_trd_acnt_id_u07,
                                    t02_custodian_id_m26,
                                    t02_symbol_id_m20
                       ORDER BY
                           t02_trd_acnt_id_u07,
                           t02_custodian_id_m26,
                           t02_symbol_id_m20,
                           t02_holding_settle_date)
                       AS row_num_t02
              FROM     (SELECT u24_trading_acnt_id_u07,
                               u24_custodian_id_m26,
                               u24_symbol_id_m20,
                               u24_receivable_holding,
                               u24_payable_holding,
                               u24_net_receivable
                          FROM u24_holdings
                         WHERE     u24_exchange_code_m01 = 'TDWL'
                               AND u24_net_receivable <> 0) u24
                   FULL OUTER JOIN
                       (  SELECT t02_trd_acnt_id_u07,
                                 t02_custodian_id_m26,
                                 t02_symbol_id_m20,
                                 t02_holding_settle_date,
                                 SUM (
                                     CASE
                                         WHEN t02_side = 1
                                         THEN
                                             t02_last_shares
                                         WHEN t02_side = 2
                                         THEN
                                             -1 * t02_last_shares
                                         ELSE
                                             t02_last_shares
                                     END)
                                     AS net_recievable_hld
                            FROM (SELECT t02.t02_trd_acnt_id_u07,
                                         t02.t02_custodian_id_m26,
                                         t02_symbol_id_m20,
                                         t02.t02_side,
                                         t02.t02_last_shares,
                                         t02_holding_settle_date
                                    FROM t02_transaction_log t02
                                   WHERE     (   t02.t02_holding_settle_date >
                                                     func_get_eod_date
                                              OR t02_trade_process_stat_id_v01 IN
                                                     (1, 21)) -- TP Changes | or pending , pending approve
                                         AND t02.t02_create_date > SYSDATE - 20
                                         AND t02.t02_exchange_code_m01 = 'TDWL'
                                         AND t02_holding_net_adjst <> 0
                                         AND t02_txn_entry_status = 0
                                         AND t02.t02_update_type IN (1)
                                  UNION ALL
                                  SELECT t02.t02_trd_acnt_id_u07,
                                         t02.t02_custodian_id_m26,
                                         t02_symbol_id_m20,
                                         NULL AS t02_side,
                                         t02.t02_holding_net_adjst
                                             AS t02_last_shares,
                                         t02_holding_settle_date
                                    FROM t02_transaction_log t02
                                   WHERE     t02.t02_holding_settle_date >
                                                 func_get_eod_date
                                         AND t02.t02_create_date > SYSDATE - 20
                                         AND t02.t02_exchange_code_m01 = 'TDWL'
                                         AND t02.t02_update_type IN (3))
                        GROUP BY t02_holding_settle_date,
                                 t02_trd_acnt_id_u07,
                                 t02_custodian_id_m26,
                                 t02_symbol_id_m20
                        ORDER BY t02_trd_acnt_id_u07,
                                 t02_custodian_id_m26,
                                 t02_symbol_id_m20,
                                 t02_holding_settle_date)
                   ON     u24_trading_acnt_id_u07 = t02_trd_acnt_id_u07
                      AND u24_symbol_id_m20 = t02_symbol_id_m20
                      AND u24_custodian_id_m26 = t02_custodian_id_m26)
    LOOP
        UPDATE a13_cash_holding_adjust_log
           SET a13_u24_net_receivable =
                       -1
                     * CASE
                           WHEN i.t02_trd_acnt_id_u07 IS NOT NULL
                           THEN
                               DECODE (i.row_num_t02,
                                       1, NVL (i.u24_net_receivable, 0),
                                       0)
                           ELSE
                               NVL (i.u24_net_receivable, 0)
                       END
                   + (CASE
                          WHEN     NVL (i.net_recievable_hld, 0) < 0
                               AND   a13_u24_net_receivable
                                   + NVL (i.net_recievable_hld, 0) > 0
                          THEN
                                a13_u24_net_receivable
                              + NVL (i.net_recievable_hld, 0)
                          WHEN     NVL (i.net_recievable_hld, 0) < 0
                               AND   a13_u24_net_receivable
                                   + NVL (i.net_recievable_hld, 0) < 0
                          THEN
                              0
                          WHEN NVL (i.net_recievable_hld, 0) > 0
                          THEN
                                a13_u24_net_receivable
                              + NVL (i.net_recievable_hld, 0)
                          ELSE
                              0
                      END)
         WHERE     a13_u24_trading_acnt_id_u07 =
                       NVL (i.t02_trd_acnt_id_u07, i.u24_trading_acnt_id_u07)
               AND a13_u24_custodian_id_m26 =
                       NVL (i.t02_custodian_id_m26, i.u24_custodian_id_m26)
               AND a13_u24_symbol_id_m20 =
                       NVL (i.t02_symbol_id_m20, i.u24_symbol_id_m20)
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