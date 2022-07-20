CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_pending_holding_old (
    psettle_customer IN NUMBER)
IS
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    IF psettle_customer = 0 --SOD
    THEN
        l_rec_count := 0;

        UPDATE u24_holdings
           SET u24_receivable_holding = 0, u24_payable_holding = 0
         WHERE u24_exchange_code_m01 = 'TDWL';

        COMMIT;

        FOR i
            IN (  SELECT t02_trd_acnt_id_u07,
                         t02_exchange_code_m01,
                         t02_symbol_code_m20,
                         t02_custodian_id_m26,
                         SUM (
                             CASE
                                 WHEN t02_side IN (1, 3) --Buy
                                 THEN
                                     t02_holding_net_adjst
                                 ELSE
                                     0
                             END)
                             AS pending_settle,
                         SUM (
                             CASE
                                 WHEN t02_side IN (2, 4) --Sell
                                 THEN
                                     t02_holding_net_adjst
                                 ELSE
                                     0
                             END)
                             AS payable_holding
                    FROM (SELECT t02.t02_trd_acnt_id_u07,
                                 t02.t02_exchange_code_m01,
                                 t02.t02_symbol_code_m20,
                                 t02.t02_symbol_id_m20,
                                 t02.t02_custodian_id_m26,
                                 t02.t02_side,
                                 t02.t02_holding_net_adjst,
                                 t02.t02_holding_settle_date
                            FROM     t02_transaction_log_order_all t02
                                 INNER JOIN
                                     m01_exchanges m01
                                 ON t02.t02_exchange_code_m01 =
                                        m01.m01_exchange_code
                           WHERE     t02.t02_exchange_code_m01 = 'TDWL'
                                 AND (   t02_holding_settle_date >=
                                               func_get_eod_date
                                             + 1 --  Make It as Current Date (SOD Job)
                                             + CASE
                                                   WHEN m01_settle_customer = 1
                                                   THEN
                                                       0
                                                   ELSE
                                                       1
                                               END
                                      -- consider TP
                                      -- OR status = pending, pengin approve
                                      OR t02.t02_trade_process_stat_id_v01 IN
                                             (1, 21))
                                 AND t02.t02_last_shares > 0
                                 AND t02.t02_create_datetime >
                                         func_get_eod_date - 30)
                GROUP BY t02_trd_acnt_id_u07,
                         t02_exchange_code_m01,
                         t02_symbol_code_m20,
                         t02_custodian_id_m26)
        LOOP
            UPDATE u24_holdings
               SET u24_receivable_holding = ABS (i.pending_settle),
                   u24_payable_holding = ABS (i.payable_holding)
             WHERE     u24_trading_acnt_id_u07 = i.t02_trd_acnt_id_u07
                   AND u24_exchange_code_m01 = i.t02_exchange_code_m01
                   AND u24_symbol_code_m20 = i.t02_symbol_code_m20
                   AND u24_custodian_id_m26 = i.t02_custodian_id_m26;

            l_rec_count := l_rec_count + 1;

            IF MOD (l_rec_count, l_commit_blk_size) = 0
            THEN
                COMMIT;
            END IF;
        END LOOP;
    ELSE -- EOD
        l_rec_count := 0;

        UPDATE t02_transaction_log
           SET t02_holding_settle_date = TRUNC (SYSDATE) + 1
         WHERE     t02_holding_settle_date = TRUNC (SYSDATE)
               AND t02_db_create_date > TRUNC (SYSDATE - 30)
               AND t02_fail_management_status = 4 --4 - ICM Fail Chain
               AND t02_exchange_code_m01 = 'TDWL';

        FOR i
            IN (  SELECT t02_trd_acnt_id_u07,
                         t02_exchange_code_m01,
                         t02_symbol_code_m20,
                         t02_custodian_id_m26,
                         SUM (
                             CASE
                                 WHEN t02_side = 1 --Buy
                                                  THEN t02_holding_net_adjst
                                 ELSE 0
                             END)
                             AS pending_settle,
                         SUM (
                             CASE
                                 WHEN t02_side = 2 --Sell
                                                  THEN t02_holding_net_adjst
                                 ELSE 0
                             END)
                             AS payable_holding
                    FROM t02_transaction_log_order_all
                   WHERE     t02_holding_settle_date = func_get_eod_date -- OR status = pending, pengin approve
                         AND t02_trade_process_stat_id_v01 IN (24, 25) -- consider TP setled
                         AND t02_db_create_date > func_get_eod_date - 30
                         AND t02_exchange_code_m01 = 'TDWL'
                GROUP BY t02_trd_acnt_id_u07,
                         t02_exchange_code_m01,
                         t02_symbol_code_m20,
                         t02_custodian_id_m26)
        LOOP
            UPDATE u24_holdings
               SET u24_receivable_holding =
                       u24_receivable_holding - ABS (i.pending_settle),
                   u24_payable_holding =
                       u24_payable_holding - ABS (i.payable_holding)
             WHERE     u24_trading_acnt_id_u07 = i.t02_trd_acnt_id_u07
                   AND u24_exchange_code_m01 = i.t02_exchange_code_m01
                   AND u24_symbol_code_m20 = i.t02_symbol_code_m20
                   AND u24_custodian_id_m26 = i.t02_custodian_id_m26;

            l_rec_count := l_rec_count + 1;

            IF MOD (l_rec_count, l_commit_blk_size) = 0
            THEN
                COMMIT;
            END IF;
        END LOOP;

        -- update t02 for tdwl, status = settled where status = pending settle and date<= today
        UPDATE t02_transaction_log
           SET t02_trade_process_stat_id_v01 = 25
         WHERE     t02_trade_process_stat_id_v01 = 24
               AND t02_holding_settle_date <= TRUNC (SYSDATE);

        COMMIT;
    END IF;

    sp_update_hold_net_receiv_old;
END;
/