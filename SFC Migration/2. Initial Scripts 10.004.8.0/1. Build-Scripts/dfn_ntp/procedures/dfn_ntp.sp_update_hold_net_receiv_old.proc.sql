CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_hold_net_receiv_old
IS
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    FOR i
        IN (SELECT u24.u24_custodian_id_m26,
                   u24.u24_trading_acnt_id_u07,
                   u24.u24_exchange_code_m01,
                   u24.u24_symbol_code_m20
              FROM u24_holdings u24
             WHERE u24_exchange_code_m01 = 'TDWL' AND u24_net_receivable <> 0)
    LOOP
        UPDATE u24_holdings
           SET u24_net_receivable = 0
         WHERE     u24_custodian_id_m26 = i.u24_custodian_id_m26
               AND u24_trading_acnt_id_u07 = i.u24_trading_acnt_id_u07
               AND u24_exchange_code_m01 = i.u24_exchange_code_m01
               AND u24_symbol_code_m20 = i.u24_symbol_code_m20;

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;

    l_rec_count := 0;

    FOR i
        IN (  SELECT t02_trd_acnt_id_u07,
                     t02_exchange_code_m01,
                     t02_symbol_code_m20,
                     t02_custodian_id_m26,
                     t02_holding_settle_date,
                     SUM (
                         CASE
                             WHEN t02_side = 1 THEN t02_last_shares
                             WHEN t02_side = 2 THEN -1 * t02_last_shares
                             ELSE t02_last_shares
                         END)
                         AS net_recievable_hld
                FROM (SELECT t02.t02_trd_acnt_id_u07,
                             t02.t02_exchange_code_m01,
                             t02.t02_symbol_code_m20,
                             t02.t02_custodian_id_m26,
                             t02.t02_side,
                             t02.t02_last_shares,
                             t02_holding_settle_date
                        FROM t02_transaction_log t02
                       WHERE     t02.t02_holding_settle_date >=
                                     TRUNC (func_get_eod_date + 1)
                             AND t02.t02_create_date >
                                     TRUNC (func_get_eod_date - 20)
                             AND t02.t02_exchange_code_m01 = 'TDWL'
                             AND t02_holding_net_adjst <> 0
                             AND t02.t02_update_type IN (1)
                      UNION ALL
                      SELECT t02.t02_trd_acnt_id_u07,
                             t02.t02_exchange_code_m01,
                             t02.t02_symbol_code_m20,
                             t02.t02_custodian_id_m26,
                             NULL AS t02_side,
                             t02.t02_holding_net_adjst AS t02_last_shares,
                             t02_holding_settle_date
                        FROM t02_transaction_log t02
                       WHERE     t02.t02_holding_settle_date >=
                                     TRUNC (func_get_eod_date + 1)
                             AND t02.t02_create_date >
                                     TRUNC (func_get_eod_date - 20)
                             AND t02.t02_exchange_code_m01 = 'TDWL'
                             AND t02.t02_update_type IN (3))
            GROUP BY t02_holding_settle_date,
                     t02_trd_acnt_id_u07,
                     t02_exchange_code_m01,
                     t02_symbol_code_m20,
                     t02_custodian_id_m26
            ORDER BY t02_holding_settle_date)
    LOOP
        UPDATE u24_holdings u24
           SET u24.u24_net_receivable =
                   (CASE
                        WHEN     i.net_recievable_hld < 0
                             AND u24_net_receivable + i.net_recievable_hld >
                                     0
                        THEN
                            u24_net_receivable + i.net_recievable_hld
                        WHEN     i.net_recievable_hld < 0
                             AND u24_net_receivable + i.net_recievable_hld <
                                     0
                        THEN
                            0
                        WHEN i.net_recievable_hld > 0
                        THEN
                            u24_net_receivable + i.net_recievable_hld
                        ELSE
                            0
                    END)
         WHERE     u24_custodian_id_m26 = i.t02_custodian_id_m26
               AND u24_trading_acnt_id_u07 = i.t02_trd_acnt_id_u07
               AND u24_exchange_code_m01 = i.t02_exchange_code_m01
               AND u24_symbol_code_m20 = i.t02_symbol_code_m20;

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;

    ---------------Control the negative if any for share transfer

    l_rec_count := 0;

    FOR i
        IN (SELECT u24.u24_custodian_id_m26,
                   u24.u24_trading_acnt_id_u07,
                   u24.u24_exchange_code_m01,
                   u24.u24_symbol_code_m20
              FROM u24_holdings u24
             WHERE     u24_exchange_code_m01 = 'TDWL'
                   AND u24_net_receivable > u24.u24_net_holding)
    LOOP
        UPDATE u24_holdings
           SET u24_net_receivable = u24_net_holding
         WHERE     u24_custodian_id_m26 = i.u24_custodian_id_m26
               AND u24_trading_acnt_id_u07 = i.u24_trading_acnt_id_u07
               AND u24_exchange_code_m01 = i.u24_exchange_code_m01
               AND u24_symbol_code_m20 = i.u24_symbol_code_m20;

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;
END;
/
