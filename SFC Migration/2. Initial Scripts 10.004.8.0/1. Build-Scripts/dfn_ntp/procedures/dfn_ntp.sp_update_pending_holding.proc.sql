CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_pending_holding (
    psettle_customer IN NUMBER)
IS
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    IF psettle_customer = 0                                              --SOD
    THEN
        l_rec_count := 0;

        FOR i IN (SELECT t02_trd_acnt_id_u07,
                         t02_custodian_id_m26,
                         t02_symbol_id_m20,
                         pending_settle,
                         payable_holding,
                         u24_trading_acnt_id_u07,
                         u24_custodian_id_m26,
                         u24_symbol_id_m20,
                         u24_receivable_holding,
                         u24_payable_holding,
                         t02_exchange_code_m01,
                         t02_symbol_code_m20,
                         u24_exchange_code_m01,
                         u24_symbol_code_m20
                    FROM     (SELECT u24_trading_acnt_id_u07,
                                     u24_custodian_id_m26,
                                     u24_symbol_id_m20,
                                     u24_receivable_holding,
                                     u24_payable_holding,
                                     u24_net_receivable,
                                     u24_exchange_code_m01,
                                     u24_symbol_code_m20
                                FROM u24_holdings
                               WHERE (   u24_receivable_holding <> 0
                                      OR u24_payable_holding <> 0
                                      OR u24_net_receivable <> 0)) u24
                         FULL OUTER JOIN
                             (  SELECT t02.t02_trd_acnt_id_u07,
                                       t02.t02_custodian_id_m26,
                                       t02.t02_symbol_id_m20,
                                       t02.t02_exchange_code_m01,
                                       t02.t02_symbol_code_m20,
                                       SUM (
                                           CASE
                                               WHEN    t02_side IN (1, 3)
                                                    OR t02_txn_code =
                                                           'HLDDEPOST'   --Buy
                                               THEN
                                                   t02_holding_net_adjst
                                               ELSE
                                                   0
                                           END)
                                           AS pending_settle,
                                       SUM (
                                           CASE
                                               WHEN    t02_side IN (2, 4)
                                                    OR t02_txn_code =
                                                           'HLDWITHDR'  --Sell
                                               THEN
                                                   t02_holding_net_adjst
                                               ELSE
                                                   0
                                           END)
                                           AS payable_holding
                                  FROM t02_transaction_log t02,
                                       m01_exchanges m01
                                 WHERE     t02.t02_exchange_id_m01 = m01.m01_id
                                       AND (   t02_holding_settle_date >=
                                                     func_get_eod_date
                                                   + 1 --  Make It as Current Date (SOD Job)
                                                   + CASE
                                                         WHEN m01_settle_customer =
                                                                  1
                                                         THEN
                                                             0
                                                         ELSE
                                                             1
                                                     END
                                            OR t02.t02_trade_process_stat_id_v01 IN
                                                   (1, 21))
                                       AND t02.t02_create_datetime >
                                               SYSDATE - 30
                                       AND t02_update_type IN (1, 3, 6)
                                       AND t02_txn_entry_status = 0
                                       AND t02_holding_net_adjst <> 0
                              GROUP BY t02_trd_acnt_id_u07,
                                       t02_custodian_id_m26,
                                       t02_symbol_id_m20,
                                       t02.t02_exchange_code_m01,
                                       t02.t02_symbol_code_m20)
                         ON     u24_trading_acnt_id_u07 = t02_trd_acnt_id_u07
                            AND u24_symbol_id_m20 = t02_symbol_id_m20
                            AND u24_custodian_id_m26 = t02_custodian_id_m26)
        LOOP
            INSERT
              INTO a13_cash_holding_adjust_log (a13_id,
                                                a13_job_id_v07,
                                                a13_created_date,
                                                a13_u24_trading_acnt_id_u07,
                                                a13_u24_custodian_id_m26,
                                                a13_u24_symbol_id_m20,
                                                a13_u24_receivable_holding,
                                                a13_u24_payable_holding,
                                                a13_u24_net_receivable,
                                                a13_u24_exchange_code_m01,
                                                a13_u24_symbol_code_m20,
                                                a13_impact_type,
                                                a13_code_m97,
                                                a13_t02_required)
            VALUES (
                       seq_a13_id.NEXTVAL,
                       7,
                       TRUNC (SYSDATE),
                       NVL (i.t02_trd_acnt_id_u07, i.u24_trading_acnt_id_u07),
                       NVL (i.t02_custodian_id_m26, i.u24_custodian_id_m26),
                       NVL (i.t02_symbol_id_m20, i.u24_symbol_id_m20),
                         -1 * NVL (i.u24_receivable_holding, 0)
                       + NVL (ABS (i.pending_settle), 0),
                         -1 * NVL (i.u24_payable_holding, 0)
                       + NVL (ABS (i.payable_holding), 0),
                       0,
                       NVL (i.t02_exchange_code_m01, i.u24_exchange_code_m01),
                       NVL (i.t02_symbol_code_m20, i.u24_symbol_code_m20),
                       3,
                       'HPNDNG_ADJ',
                       0);

            l_rec_count := l_rec_count + 1;

            IF MOD (l_rec_count, l_commit_blk_size) = 0
            THEN
                COMMIT;
            END IF;
        END LOOP;
    ELSE                                                                -- EOD
        l_rec_count := 0;

        UPDATE t02_transaction_log
           SET t02_holding_settle_date = TRUNC (SYSDATE) + 1
         WHERE     t02_holding_settle_date = TRUNC (SYSDATE)
               AND t02_db_create_date > TRUNC (SYSDATE - 30)
               AND t02_fail_management_status = 4           --4 ICM Fail Chain
               AND t02_exchange_code_m01 = 'TDWL';

        FOR i
            IN (  SELECT t02_trd_acnt_id_u07,
                         t02_symbol_id_m20,
                         t02_custodian_id_m26,
                         t02_exchange_code_m01,
                         t02_symbol_code_m20,
                         SUM (
                             CASE
                                 WHEN t02_side = 1                       --Buy
                                                  THEN t02_holding_net_adjst
                                 ELSE 0
                             END)
                             AS pending_settle,
                         SUM (
                             CASE
                                 WHEN t02_side = 2                      --Sell
                                                  THEN t02_holding_net_adjst
                                 ELSE 0
                             END)
                             AS payable_holding
                    FROM t02_transaction_log
                   WHERE     t02_holding_settle_date = func_get_eod_date
                         AND t02_db_create_date > SYSDATE - 30
                         AND t02_trade_process_stat_id_v01 IN (24, 25)
                         AND t02_update_type IN (1, 6)
                         AND t02_txn_entry_status = 0
                         AND t02_holding_net_adjst <> 0
                         AND t02_exchange_code_m01 = 'TDWL'
                GROUP BY t02_trd_acnt_id_u07,
                         t02_symbol_id_m20,
                         t02_custodian_id_m26,
                         t02_exchange_code_m01,
                         t02_symbol_code_m20)
        LOOP
            INSERT
              INTO a13_cash_holding_adjust_log (a13_id,
                                                a13_job_id_v07,
                                                a13_created_date,
                                                a13_u24_trading_acnt_id_u07,
                                                a13_u24_custodian_id_m26,
                                                a13_u24_symbol_id_m20,
                                                a13_u24_receivable_holding,
                                                a13_u24_payable_holding,
                                                a13_u24_net_receivable,
                                                a13_u24_exchange_code_m01,
                                                a13_u24_symbol_code_m20,
                                                a13_impact_type,
                                                a13_code_m97,
                                                a13_t02_required)
            VALUES (seq_a13_id.NEXTVAL,
                    8,
                    TRUNC (SYSDATE),
                    i.t02_trd_acnt_id_u07,
                    i.t02_custodian_id_m26,
                    i.t02_symbol_id_m20,
                    -i.pending_settle,
                    -ABS (i.payable_holding),
                    0,
                    i.t02_exchange_code_m01,
                    i.t02_symbol_code_m20,
                    3,
                    'HPNDNG_ADJ',
                    0);

            l_rec_count := l_rec_count + 1;

            IF MOD (l_rec_count, l_commit_blk_size) = 0
            THEN
                COMMIT;
            END IF;
        END LOOP;

        COMMIT;
    END IF;

    sp_update_hold_net_receivable;
END;
/
