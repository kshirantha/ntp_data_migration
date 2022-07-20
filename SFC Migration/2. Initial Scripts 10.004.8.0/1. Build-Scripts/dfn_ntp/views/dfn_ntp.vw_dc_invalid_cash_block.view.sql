CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dc_invalid_cash_block
(
    u06_customer_no_u01,
    u06_id,
    u06_display_name,
    u06_display_name_u01,
    u06_currency_code_m03,
    u06_balance,
    u06_blocked,
    u06_open_buy_blocked,
    u06_pending_withdraw,
    u06_investment_account_no,
    tot_cash_blocks_buy,
    tot_cash_blocks_trans,
    valid_total_block,
    difference,
    u06_institute_id_m02 )
AS
    SELECT u06_customer_no_u01,
           u06_id,
           u06_display_name,
           u06_display_name_u01,
           u06_currency_code_m03,
           u06_balance,
           u06_blocked,
           u06_open_buy_blocked,
           u06_pending_withdraw,
           u06_investment_account_no,
           NVL (tot_cash_blocks_buy, 0) tot_cash_blocks_buy,
           NVL (tot_cash_blocks_trans, 0) tot_cash_blocks_trans,
           NVL (tot_cash_blocks_buy, 0) + NVL (tot_cash_blocks_trans, 0)
               valid_total_block,
             NVL (tot_cash_blocks_buy, 0)
           + NVL (tot_cash_blocks_trans, 0)
           - NVL (u06_blocked, 0)
                 AS difference,
           u06_institute_id_m02
      FROM (SELECT u06_customer_no_u01,
                   u06_id,
                   u06_display_name,
                   u06_display_name_u01,
                   u06_currency_code_m03,
                   u06_balance,
                   u06_blocked,
                   u06_open_buy_blocked,
                   u06_pending_withdraw,
               u06_investment_account_no,
               u06_institute_id_m02
              FROM u06_cash_account) u06
           FULL JOIN (  SELECT t02_cash_acnt_id_u06 t02_cash_acnt_id_u06_buy,
                               SUM (tot_cash_blocks_buy) tot_cash_blocks_buy
                          FROM (  SELECT t02_cash_acnt_id_u06,
                                         t02_order_no,
                                         SUM (t02_cash_block_adjst)
                                             AS tot_cash_blocks_buy
                                    FROM t02_transaction_log_order_all t02
                                   WHERE t02_txn_code IN ('STLBUY')
                                GROUP BY t02_cash_acnt_id_u06, t02_order_no)
                         WHERE tot_cash_blocks_buy <> 0
                      GROUP BY t02_cash_acnt_id_u06) buy_blk
               ON (u06.u06_id = buy_blk.t02_cash_acnt_id_u06_buy)
           FULL JOIN (  SELECT t02_cash_acnt_id_u06 t02_cash_acnt_id_u06_trans,
                               SUM (tot_cash_blocks_trans)
                                   tot_cash_blocks_trans
                          FROM (  SELECT t02_cash_acnt_id_u06,
                                         t02_txn_code,
                                         t02_cashtxn_id,
                                         SUM (t02_cash_block_adjst)
                                             AS tot_cash_blocks_trans
                                    FROM     t02_transaction_log t02
                                         JOIN
                                             m97_transaction_codes m97
                                         ON     t02.t02_txn_code = m97.m97_code
                                            AND m97.m97_category = 1
                                            AND t02_update_type IN (2, 6)
                                            AND t02_txn_code NOT IN
                                                    ('STLBUY', 'STLSEL')
                                GROUP BY t02_cash_acnt_id_u06,
                                         t02_txn_code,
                                         t02_cashtxn_id)
                         WHERE tot_cash_blocks_trans <> 0
                      GROUP BY t02_cash_acnt_id_u06) trans_blk
               ON (u06.u06_id = trans_blk.t02_cash_acnt_id_u06_trans)
     WHERE    t02_cash_acnt_id_u06_trans IS NOT NULL
           OR t02_cash_acnt_id_u06_buy IS NOT NULL
           OR u06_blocked <> 0
/
