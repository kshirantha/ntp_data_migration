CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redist_holding_generate (t09c t09_txn_single_entry_v3%ROWTYPE)
/* Formatted on 3/17/2020 1:26:24 PM (QP5 v5.206) */
IS
BEGIN
    BEGIN
    --- Update Order Path Fields
    IF(t09c.t09_update_impact_code = '1')
    THEN
        MERGE INTO dfn_ntp.u24_holdings t
             USING (SELECT *
                      FROM (SELECT t09c.t09_trading_acc_id_u07,
                                   t09c.t09_symbol_id_m20,
                                   t09c.t09_exchange_m01,
                                   NVL (t09c.t09_gain_loss, 0)
                                       AS t09_gain_loss,
                                   t09c.t09_custodian_id_m26
                                       AS t09_custodian_id_m26,
                                   t09c.t09_symbol_code_m20
                                       AS t09_symbol_code_m20 --  ,CASE WHEN T.lastUpdatedTime = 0 THEN SYSDATE ELSE TO_DATE(T.lastUpdatedTime,'YYYYMMDD') END AS lastUpdatedTime
                                                             --  ,T.lastUpdatedTime
                                   ,
                                   --      TO_DATE ('19700101', 'yyyymmdd')
                                   --    + (  (t09c.t09_last_updated_time / 1000)
                                   --       / 24
                                   --       / 60
                                   --       / 60)
                                   NVL (
                                       TO_TIMESTAMP (
                                           t09c.t09_last_updated_time,
                                           'YYYYMMDDHH24MISS'),
                                       SYSDATE)
                                       AS t09_last_updated_time,
                                   NVL (t09c.t09_holding_blk, 0)
                                       AS t09_holding_blk,
                                   NVL (t09c.t09_sell_pending, 0)
                                       AS t09_sell_pending,
                                   NVL (t09c.t09_buy_pending, 0)
                                       AS t09_buy_pending,
                                   NVL (t09c.t09_weighted_avgprice, 0)
                                       AS t09_weighted_avgprice,
                                   NVL (t09c.t09_holding_avg_price, 0)
                                       AS t09_holding_avg_price,
                                   NVL (t09c.t09_weighted_avgcost, 0)
                                       AS t09_weighted_avgcost,
                                   NVL (t09c.t09_holding_avg_cost, 0) AS t09_holding_avg_cost,
                                   NVL (t09c.t09_holding_receivable, 0)
                                       AS t09_holding_receivable,
                                   NVL (t09c.t09_holding_paybale, 0)
                                       AS t09_holding_paybale,
                                   NVL (t09c.t09_holding_net, 0)
                                       AS t09_holding_net,
                                   NVL (t09c.t09_holding_net_receivable, 0)
                                       AS t09_holding_net_receivable,
                                   t09c.t09_db_seq_id AS t09_db_seq_id,
                                   t09c.t09_lockseq AS t09_lockseq,
                                   t09c.t09_pledge_qty,
                                   t09c.t09_subscribed_qty,
                                   t09c.t09_profit_loss_holding,
                                   t09c.t09_short_holdings,
                                   t09c.t09_price_inst_type,
                                   t09c.t09_option_base_holding_block,
                                   t09c.t09_option_base_cash_block,
                                   t09c.t09_txn_currency_m03,
                                   t09c.t09_short_holding_block,
                                   t09c.t09_hld_maintain_margin_block,
                                   t09c.t09_hld_maintain_margin_charg,
                                   t09c.t09_long_holdings,
								   t09c.t09_cashacnt_id_u06
                              FROM DUAL) ca) s
                ON (    t.u24_symbol_code_m20 = s.t09_symbol_code_m20
                    AND t.u24_exchange_code_m01 = s.t09_exchange_m01
                    AND t.u24_trading_acnt_id_u07 = s.t09_trading_acc_id_u07
                    AND t.u24_custodian_id_m26 = s.t09_custodian_id_m26)
        WHEN MATCHED
        THEN
            UPDATE SET
                t.u24_realized_gain_lost = s.t09_profit_loss_holding --  ,T.U24_SYMBOL_CODE = S.SYMBOL
                                                                    ,
                t.u24_last_update_datetime = s.t09_last_updated_time -- ,T.U24_M27_ID = S.CUSTODIANID
                                                                    ,
                t.u24_holding_block = s.t09_holding_blk,
                t.u24_sell_pending = s.t09_sell_pending,
                t.u24_buy_pending = s.t09_buy_pending,
                t.u24_weighted_avg_price = s.t09_weighted_avgprice,
                t.u24_avg_price = s.t09_holding_avg_price,
                t.u24_weighted_avg_cost = s.t09_weighted_avgcost,
                t.u24_avg_cost = s.t09_holding_avg_cost,
                t.u24_receivable_holding = s.t09_holding_receivable,
                t.u24_payable_holding = s.t09_holding_paybale,
                t.u24_net_holding = s.t09_holding_net,
                t.u24_ordexecseq = s.t09_lockseq,
                t.u24_dbseqid = s.t09_db_seq_id,
                t.u24_subscribed_qty = s.t09_subscribed_qty,
                t.u24_short_holdings = s.t09_short_holdings,
                t.u24_price_inst_type = s.t09_price_inst_type,
                t.u24_net_receivable = s.t09_holding_net_receivable,
                t.u24_base_holding_block = s.t09_option_base_holding_block,
                t.u24_base_cash_block = s.t09_option_base_cash_block,
                t.u24_currency_code_m03 = s.t09_txn_currency_m03,
                t.u24_short_holding_block = s.t09_short_holding_block,
                t.u24_maintain_margin_charged =
                    s.t09_hld_maintain_margin_charg,
                t.u24_maintain_margin_block = s.t09_hld_maintain_margin_block,
                t.u24_long_holdings = s.t09_long_holdings
                     WHERE NVL (t.u24_ordexecseq, 0) < s.t09_lockseq
        WHEN NOT MATCHED
        THEN
            INSERT     (t.u24_exchange_code_m01,
                        t.u24_symbol_id_m20,
                        t.u24_trading_acnt_id_u07,
                        t.u24_realized_gain_lost,
                        t.u24_symbol_code_m20,
                        t.u24_last_update_datetime,
                        t.u24_custodian_id_m26,
                        t.u24_holding_block,
                        t.u24_sell_pending,
                        t.u24_buy_pending,
                        t.u24_weighted_avg_price,
                        t.u24_avg_price,
                        t.u24_weighted_avg_cost,
                        t.u24_avg_cost,
                        t.u24_receivable_holding,
                        t.u24_payable_holding,
                        t.u24_net_holding,
                        t.u24_dbseqid,
                        t.u24_ordexecseq,
                       --??? t.u24_pledge_qty,
                        t.u24_subscribed_qty,
                        t.u24_short_holdings,
                        t.u24_price_inst_type,
                        t.u24_net_receivable,
                        t.u24_base_holding_block,
                        t.u24_base_cash_block,
                        t.u24_currency_code_m03,
                        t.u24_short_holding_block,
                        u24_maintain_margin_charged,
                        u24_maintain_margin_block,
                        t.u24_long_holdings,
						t.u24_cash_account_id_u06)
                VALUES (s.t09_exchange_m01,
                        s.t09_symbol_id_m20,
                        s.t09_trading_acc_id_u07,
                        s.t09_profit_loss_holding,
                        s.t09_symbol_code_m20,
                        s.t09_last_updated_time,
                        s.t09_custodian_id_m26,
                        s.t09_holding_blk,
                        s.t09_sell_pending,
                        s.t09_buy_pending,
                        s.t09_weighted_avgprice,
                        s.t09_holding_avg_price,
                        s.t09_weighted_avgcost,
                        s.t09_holding_avg_cost,
                        s.t09_holding_receivable,
                        s.t09_holding_paybale,
                        s.t09_holding_net,
                        s.t09_db_seq_id,
                        s.t09_lockseq,
                       -- ???s.t09_pledge_qty,
                        s.t09_subscribed_qty,
                        s.t09_short_holdings,
                        s.t09_price_inst_type,
                        s.t09_holding_net_receivable,
                        s.t09_option_base_holding_block,
                        s.t09_option_base_cash_block,
                        s.t09_txn_currency_m03,
                        s.t09_short_holding_block,
                        s.t09_hld_maintain_margin_block,
                        s.t09_hld_maintain_margin_charg,
                        s.t09_long_holdings,
						s.t09_cashacnt_id_u06);
        --END IF;

        --- Update Holding Adjustment and (Holding + Cash) Adjustment Fields
        ELSIF(t09c.t09_update_impact_code = '3' OR t09c.t09_update_impact_code = '6')
        THEN
               MERGE INTO dfn_ntp.u24_holdings t
             USING (SELECT *
                      FROM (SELECT t09c.t09_trading_acc_id_u07,
                                   t09c.t09_symbol_id_m20,
                                   t09c.t09_exchange_m01,
                                   NVL (t09c.t09_gain_loss, 0)
                                       AS t09_gain_loss,
                                   t09c.t09_custodian_id_m26
                                       AS t09_custodian_id_m26,
                                   t09c.t09_symbol_code_m20
                                       AS t09_symbol_code_m20 --  ,CASE WHEN T.lastUpdatedTime = 0 THEN SYSDATE ELSE TO_DATE(T.lastUpdatedTime,'YYYYMMDD') END AS lastUpdatedTime
                                                             --  ,T.lastUpdatedTime
                                   ,
                                   --      TO_DATE ('19700101', 'yyyymmdd')
                                   --    + (  (t09c.t09_last_updated_time / 1000)
                                   --       / 24
                                   --       / 60
                                   --       / 60)
                                   NVL (
                                       TO_TIMESTAMP (
                                           t09c.t09_last_updated_time,
                                           'YYYYMMDDHH24MISS'),
                                       SYSDATE)
                                       AS t09_last_updated_time,
                                   NVL (t09c.t09_holding_blk, 0)
                                       AS t09_holding_blk,
                                   NVL (t09c.t09_sell_pending, 0)
                                       AS t09_sell_pending,
                                   NVL (t09c.t09_buy_pending, 0)
                                       AS t09_buy_pending,
                                   NVL (t09c.t09_weighted_avgprice, 0)
                                       AS t09_weighted_avgprice,
                                   NVL (t09c.t09_holding_avg_price, 0)
                                       AS t09_holding_avg_price,
                                   NVL (t09c.t09_weighted_avgcost, 0)
                                       AS t09_weighted_avgcost,
                                   NVL (t09c.t09_holding_avg_cost, 0) AS t09_holding_avg_cost,
                                   NVL (t09c.t09_holding_receivable, 0)
                                       AS t09_holding_receivable,
                                   NVL (t09c.t09_holding_paybale, 0)
                                       AS t09_holding_paybale,
                                   NVL (t09c.t09_holding_net, 0)
                                       AS t09_holding_net,
                                   NVL (t09c.t09_holding_net_receivable, 0)
                                       AS t09_holding_net_receivable,
                                   t09c.t09_db_seq_id AS t09_db_seq_id,
                                   t09c.t09_lockseq AS t09_lockseq,
                                   t09c.t09_pledge_qty,
                                   t09c.t09_subscribed_qty,
                                   t09c.t09_profit_loss_holding,
                                   t09c.t09_short_holdings,
                                   t09c.t09_price_inst_type,
                                   t09c.t09_option_base_holding_block,
                                   t09c.t09_option_base_cash_block,
                                   t09c.t09_txn_currency_m03,
                                   t09c.t09_short_holding_block,
                                   t09c.t09_hld_maintain_margin_block,
                                   t09c.t09_hld_maintain_margin_charg,
                                   t09c.t09_long_holdings,
								   t09c.t09_cashacnt_id_u06
                              FROM DUAL) ca) s
                ON (    t.u24_symbol_code_m20 = s.t09_symbol_code_m20
                    AND t.u24_exchange_code_m01 = s.t09_exchange_m01
                    AND t.u24_trading_acnt_id_u07 = s.t09_trading_acc_id_u07
                    AND t.u24_custodian_id_m26 = s.t09_custodian_id_m26)
        WHEN MATCHED
        THEN
            UPDATE SET
                t.u24_realized_gain_lost = s.t09_profit_loss_holding --  ,T.U24_SYMBOL_CODE = S.SYMBOL
                                                                    ,
                t.u24_last_update_datetime = s.t09_last_updated_time -- ,T.U24_M27_ID = S.CUSTODIANID
                                                                    ,
                t.u24_holding_block = s.t09_holding_blk,
                t.u24_sell_pending = s.t09_sell_pending,
                t.u24_buy_pending = s.t09_buy_pending,
                t.u24_weighted_avg_price = s.t09_weighted_avgprice,
                t.u24_avg_price = s.t09_holding_avg_price,
                t.u24_weighted_avg_cost = s.t09_weighted_avgcost,
                t.u24_avg_cost = s.t09_holding_avg_cost,
                t.u24_receivable_holding = s.t09_holding_receivable,
                t.u24_payable_holding = s.t09_holding_paybale,
                t.u24_net_holding = s.t09_holding_net,
                t.u24_ordexecseq = s.t09_lockseq,
                t.u24_dbseqid = s.t09_db_seq_id,
                t.u24_pledge_qty = s.t09_pledge_qty,
                t.u24_subscribed_qty = s.t09_subscribed_qty,
                t.u24_short_holdings = s.t09_short_holdings,
                t.u24_price_inst_type = s.t09_price_inst_type,
                t.u24_net_receivable = s.t09_holding_net_receivable,
                t.u24_base_holding_block = s.t09_option_base_holding_block,
                t.u24_base_cash_block = s.t09_option_base_cash_block,
                t.u24_currency_code_m03 = s.t09_txn_currency_m03,
                t.u24_short_holding_block = s.t09_short_holding_block
                     WHERE NVL (t.u24_ordexecseq, 0) < s.t09_lockseq
        WHEN NOT MATCHED
        THEN
            INSERT     (t.u24_exchange_code_m01,
                        t.u24_symbol_id_m20,
                        t.u24_trading_acnt_id_u07,
                        t.u24_realized_gain_lost,
                        t.u24_symbol_code_m20,
                        t.u24_last_update_datetime,
                        t.u24_custodian_id_m26,
                        t.u24_holding_block,
                        t.u24_sell_pending,
                        t.u24_buy_pending,
                        t.u24_weighted_avg_price,
                        t.u24_avg_price,
                        t.u24_weighted_avg_cost,
                        t.u24_avg_cost,
                        t.u24_receivable_holding,
                        t.u24_payable_holding,
                        t.u24_net_holding,
                        t.u24_dbseqid,
                        t.u24_ordexecseq,
                        t.u24_pledge_qty,
                        t.u24_subscribed_qty,
                        t.u24_short_holdings,
                        t.u24_price_inst_type,
                        t.u24_net_receivable,
                        t.u24_base_holding_block,
                        t.u24_base_cash_block,
                        t.u24_currency_code_m03,
                        t.u24_short_holding_block,
                        u24_maintain_margin_charged,
                        u24_maintain_margin_block,
                        t.u24_long_holdings,
						t.u24_cash_account_id_u06)
                VALUES (s.t09_exchange_m01,
                        s.t09_symbol_id_m20,
                        s.t09_trading_acc_id_u07,
                        s.t09_profit_loss_holding,
                        s.t09_symbol_code_m20,
                        s.t09_last_updated_time,
                        s.t09_custodian_id_m26,
                        s.t09_holding_blk,
                        s.t09_sell_pending,
                        s.t09_buy_pending,
                        s.t09_weighted_avgprice,
                        s.t09_holding_avg_price,
                        s.t09_weighted_avgcost,
                        s.t09_holding_avg_cost,
                        s.t09_holding_receivable,
                        s.t09_holding_paybale,
                        s.t09_holding_net,
                        s.t09_db_seq_id,
                        s.t09_lockseq,
                        s.t09_pledge_qty,
                        s.t09_subscribed_qty,
                        s.t09_short_holdings,
                        s.t09_price_inst_type,
                        s.t09_holding_net_receivable,
                        s.t09_option_base_holding_block,
                        s.t09_option_base_cash_block,
                        s.t09_txn_currency_m03,
                        s.t09_short_holding_block,
                        s.t09_hld_maintain_margin_block,
                        s.t09_hld_maintain_margin_charg,
                        s.t09_long_holdings,
						s.t09_cashacnt_id_u06);
        END IF;

    END;
END;
/