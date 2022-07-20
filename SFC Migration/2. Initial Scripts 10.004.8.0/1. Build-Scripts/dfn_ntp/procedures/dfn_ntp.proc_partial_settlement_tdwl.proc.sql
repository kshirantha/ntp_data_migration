CREATE OR REPLACE PROCEDURE dfn_ntp.proc_partial_settlement_tdwl (
    pkey                         OUT VARCHAR,
    pt02_trade_match_id       IN     t02_transaction_log.t02_trade_match_id%TYPE,
    pt02_create_date          IN     t02_transaction_log.t02_create_date%TYPE,
    pt02_trade_match_id_new   IN     t02_transaction_log.t02_trade_match_id%TYPE,
    pt02_last_shares                 t02_transaction_log.t02_last_shares%TYPE)
IS
    --pm03_code                        m03_currency.m03_code%TYPE;
    pm03_code                        CHAR (3) := 'SAR';
    --
    rec_count                        NUMBER (10) := 0;
    l_m03_decimal_places             m03_currency.m03_decimal_places%TYPE;
    l_t02_amnt_in_txn_currency       t02_transaction_log.t02_amnt_in_txn_currency%TYPE;
    l_t02_amnt_in_stl_currency       t02_transaction_log.t02_amnt_in_stl_currency%TYPE;
    l_t02_cash_acnt_id_u06           t02_transaction_log.t02_cash_acnt_id_u06%TYPE;
    l_t02_cash_block                 t02_transaction_log.t02_cash_block%TYPE;
    l_t02_cash_block_orig            t02_transaction_log.t02_cash_block_orig%TYPE;
    l_t02_cash_block_adjst           t02_transaction_log.t02_cash_block_adjst%TYPE;
    l_t02_cash_balance               t02_transaction_log.t02_cash_balance%TYPE;
    l_t02_cash_acnt_seq_id           t02_transaction_log.t02_cash_acnt_seq_id%TYPE;
    l_t02_trd_acnt_id_u07            t02_transaction_log.t02_trd_acnt_id_u07%TYPE;
    l_t02_holding_net                t02_transaction_log.t02_holding_net%TYPE;
    l_t02_holding_block              t02_transaction_log.t02_holding_block%TYPE;
    l_t02_holding_block_adjst        t02_transaction_log.t02_holding_block_adjst%TYPE;
    l_t02_holding_net_adjst          t02_transaction_log.t02_holding_net_adjst%TYPE;
    l_t02_symbol_code_m20            t02_transaction_log.t02_symbol_code_m20%TYPE;
    l_t02_exchange_code_m01          t02_transaction_log.t02_exchange_code_m01%TYPE;
    l_t02_custodian_id_m26           t02_transaction_log.t02_custodian_id_m26%TYPE;
    l_t02_holding_avg_cost           t02_transaction_log.t02_holding_avg_cost%TYPE;
    l_t02_inst_id_m02                t02_transaction_log.t02_inst_id_m02%TYPE;
    l_t02_txn_entry_status           t02_transaction_log.t02_txn_entry_status%TYPE;
    l_t02_cliordid_t01               t02_transaction_log.t02_cliordid_t01%TYPE;
    l_t02_last_price                 t02_transaction_log.t02_last_price%TYPE;
    l_t02_avgprice                   t02_transaction_log.t02_avgprice%TYPE;
    l_t02_cum_commission             t02_transaction_log.t02_cum_commission%TYPE;
    l_t02_commission_adjst           t02_transaction_log.t02_commission_adjst%TYPE;
    l_t02_order_no                   t02_transaction_log.t02_order_no%TYPE;
    l_t02_order_exec_id              t02_transaction_log.t02_order_exec_id%TYPE;
    l_t02_txn_currency               t02_transaction_log.t02_txn_currency%TYPE;
    l_t02_settle_currency            t02_transaction_log.t02_settle_currency%TYPE;
    l_t02_broker_commission          t02_transaction_log.t02_exg_commission%TYPE;
    l_t02_exg_commission             t02_transaction_log.t02_exg_commission%TYPE;
    l_t02_txn_code                   t02_transaction_log.t02_txn_code%TYPE;
    l_t02_fx_rate                    t02_transaction_log.t02_fx_rate%TYPE;
    l_t02_gl_posted_date             t02_transaction_log.t02_gl_posted_date%TYPE;
    l_t02_gl_posted_status           t02_transaction_log.t02_gl_posted_status%TYPE;
    l_t02_discount                   t02_transaction_log.t02_discount%TYPE;
    l_t02_cashtxn_id                 t02_transaction_log.t02_cashtxn_id%TYPE;
    l_t02_holdingtxn_id              t02_transaction_log.t02_holdingtxn_id%TYPE;
    l_t02_customer_id_u01            t02_transaction_log.t02_customer_id_u01%TYPE;
    l_t02_customer_no                t02_transaction_log.t02_customer_no%TYPE;
    l_t02_ordqty                     t02_transaction_log.t02_ordqty%TYPE;
    l_t02_pay_method                 t02_transaction_log.t02_pay_method%TYPE;
    l_t02_cash_settle_date           t02_transaction_log.t02_cash_settle_date%TYPE;
    l_t02_holding_settle_date        t02_transaction_log.t02_holding_settle_date%TYPE;
    l_t02_buy_pending                t02_transaction_log.t02_buy_pending%TYPE;
    l_t02_sell_pending               t02_transaction_log.t02_sell_pending%TYPE;
    l_t02_instrument_type            t02_transaction_log.t02_instrument_type%TYPE;
    l_t02_cum_qty                    t02_transaction_log.t02_cum_qty%TYPE;
    l_t02_holding_manual_block       t02_transaction_log.t02_holding_manual_block%TYPE;
    l_t02_possision_type             t02_transaction_log.t02_possision_type%TYPE;
    l_t02_accrude_interest           t02_transaction_log.t02_accrude_interest%TYPE;
    l_t02_accrude_interest_adjst     t02_transaction_log.t02_accrude_interest_adjst%TYPE;
    l_t02_counter_broker             t02_transaction_log.t02_counter_broker%TYPE;
    l_t02_leaves_qty                 t02_transaction_log.t02_leaves_qty%TYPE;
    l_t02_cumord_value               t02_transaction_log.t02_cumord_value%TYPE;
    l_t02_cumord_netvalue            t02_transaction_log.t02_cumord_netvalue%TYPE;
    l_t02_cumord_netsettle           t02_transaction_log.t02_cumord_netsettle%TYPE;
    l_t02_audit_key                  t02_transaction_log.t02_audit_key%TYPE;
    l_t02_pledge_qty                 t02_transaction_log.t02_pledge_qty%TYPE;
    l_t02_side                       t02_transaction_log.t02_side%TYPE;
    l_t02_symbol_id_m20              t02_transaction_log.t02_symbol_id_m20%TYPE;
    l_t02_gainloss                   t02_transaction_log.t02_gainloss%TYPE;
    l_t02_broker_tax                 t02_transaction_log.t02_broker_tax%TYPE;
    l_t02_exchange_tax               t02_transaction_log.t02_exchange_tax%TYPE;
    l_t02_update_type                t02_transaction_log.t02_update_type%TYPE;
    l_t02_ord_value_adjst            t02_transaction_log.t02_ord_value_adjst%TYPE;
    l_t02_ord_status_v30             t02_transaction_log.t02_ord_status_v30%TYPE;
    l_t02_exg_ord_id                 t02_transaction_log.t02_exg_ord_id%TYPE;
    l_t02_act_broker_tax             t02_transaction_log.t02_act_broker_tax%TYPE;
    l_t02_act_exchange_tax           t02_transaction_log.t02_act_exchange_tax%TYPE;
    l_t02_cash_settle_date_orig      t02_transaction_log.t02_cash_settle_date_orig%TYPE;
    l_t02_holding_settle_date_orig   t02_transaction_log.t02_holding_settle_date_orig%TYPE;
    l_t02_unsettle_qty               t02_transaction_log.t02_unsettle_qty%TYPE;
    l_t02_last_shares                t02_transaction_log.t02_last_shares%TYPE;
BEGIN
    SELECT COUNT (t02_cash_acnt_seq_id)
      INTO rec_count
      FROM t02_transaction_log
     WHERE     t02_create_date = pt02_create_date
           AND t02_trade_match_id = pt02_trade_match_id;

    IF rec_count <> 1
    THEN
        pkey := '-2';
        RETURN;
    END IF;

    SELECT NVL (m03_decimal_places, 2)
      INTO l_m03_decimal_places
      FROM m03_currency
     WHERE m03_code = pm03_code;

    SELECT t02_last_shares,
           t02_amnt_in_txn_currency * (pt02_last_shares / t02_last_shares), --Rounding based on TXN CUrrency TBD
           ROUND (
                 t02_amnt_in_stl_currency
               * (pt02_last_shares / t02_last_shares),
               l_m03_decimal_places),
           t02_cash_acnt_id_u06,
           ROUND (
                 t02_cash_block
               - (t02_cash_block_adjst * (pt02_last_shares / t02_last_shares)),
               l_m03_decimal_places),
           t02_cash_block_orig, /*ROUND (
                 t02_cash_block_orig
               - (t02_cash_block_adjst * (pt02_last_shares / t02_last_shares)),
               l_m03_decimal_places), */
           ROUND (
               t02_cash_block_adjst * (pt02_last_shares / t02_last_shares),
               l_m03_decimal_places),
           ROUND (
                 t02_cash_balance
               - (  t02_amnt_in_stl_currency
                  * (pt02_last_shares / t02_last_shares)),
               l_m03_decimal_places),
           t02_cash_acnt_seq_id,
           t02_trd_acnt_id_u07,
           t02_holding_net - pt02_last_shares,
           t02_holding_block,
           t02_holding_block_adjst,
           t02_holding_net_adjst - pt02_last_shares,
           t02_symbol_code_m20,
           t02_exchange_code_m01,
           t02_custodian_id_m26,
           t02_holding_avg_cost,
           t02_inst_id_m02,
           t02_txn_entry_status,
           t02_cliordid_t01,
           t02_last_price,
           t02_avgprice,
           ROUND (
                 t02_cum_commission
               - (t02_commission_adjst * (pt02_last_shares / t02_last_shares)),
               l_m03_decimal_places),
           ROUND (
               t02_commission_adjst * (pt02_last_shares / t02_last_shares),
               l_m03_decimal_places),
           t02_order_no,
           t02_order_exec_id,
           t02_txn_currency,
           t02_settle_currency,
           ROUND (
                 (t02_cum_commission - t02_exg_commission)
               * (pt02_last_shares / t02_last_shares),
               l_m03_decimal_places),
           ROUND (t02_exg_commission * (pt02_last_shares / t02_last_shares),
                  l_m03_decimal_places),
           t02_txn_code,
           t02_fx_rate,
           t02_gl_posted_date,
           t02_gl_posted_status,
           ROUND (t02_discount * (pt02_last_shares / t02_last_shares),
                  l_m03_decimal_places),
           t02_cashtxn_id,
           t02_holdingtxn_id,
           t02_customer_id_u01,
           t02_customer_no,
           t02_ordqty,
           t02_pay_method,
             t02_buy_pending
           - CASE WHEN t02_buy_pending > 0 THEN pt02_last_shares ELSE 0 END,
             t02_sell_pending
           - CASE WHEN t02_sell_pending > 0 THEN pt02_last_shares ELSE 0 END,
           t02_instrument_type,
           t02_cum_qty - (t02_last_shares - pt02_last_shares),
           t02_holding_manual_block,
           t02_possision_type,
           t02_accrude_interest,
           t02_accrude_interest_adjst,
           t02_counter_broker,
           t02_leaves_qty - pt02_last_shares,
             t02_cumord_value
           - t02_last_price * (t02_last_shares - pt02_last_shares),
           ROUND (
                 t02_cumord_netvalue
               - (  t02_cumord_value
                  - t02_last_price * (t02_last_shares - pt02_last_shares))
               + (t02_commission_adjst * (pt02_last_shares / t02_last_shares)),
               l_m03_decimal_places),
           ROUND (
                 t02_cumord_netsettle
               - (  t02_cumord_value
                  - t02_last_price * (t02_last_shares - pt02_last_shares))
               + (t02_commission_adjst * (pt02_last_shares / t02_last_shares)),
               l_m03_decimal_places),
           t02_audit_key,
           t02_pledge_qty,
           t02_side,
           t02_symbol_id_m20,
           ROUND (t02_gainloss * (pt02_last_shares / t02_last_shares),
                  l_m03_decimal_places),
           ROUND (t02_broker_tax * (pt02_last_shares / t02_last_shares),
                  l_m03_decimal_places),
           ROUND (t02_exchange_tax * (pt02_last_shares / t02_last_shares),
                  l_m03_decimal_places),
           t02_update_type,
           t02_ord_status_v30,
             t02_ord_value_adjst
           - (t02_last_price * (t02_last_shares - pt02_last_shares)),
           t02_exg_ord_id,
           ROUND (t02_act_broker_tax * (pt02_last_shares / t02_last_shares),
                  l_m03_decimal_places),
           ROUND (
               t02_act_exchange_tax * (pt02_last_shares / t02_last_shares),
               l_m03_decimal_places),
           CASE
               WHEN t02_cash_settle_date_orig IS NULL
               THEN
                   t02_cash_settle_date
               ELSE
                   t02_cash_settle_date_orig
           END,
           CASE
               WHEN t02_holding_settle_date_orig IS NULL
               THEN
                   t02_holding_settle_date
               ELSE
                   t02_holding_settle_date_orig
           END,
           t02_cash_settle_date,
           t02_holding_settle_date,
           t02_unsettle_qty
      INTO l_t02_last_shares,
           l_t02_amnt_in_txn_currency,
           l_t02_amnt_in_stl_currency,
           l_t02_cash_acnt_id_u06,
           l_t02_cash_block,
           l_t02_cash_block_orig,
           l_t02_cash_block_adjst,
           l_t02_cash_balance,
           l_t02_cash_acnt_seq_id,
           l_t02_trd_acnt_id_u07,
           l_t02_holding_net,
           l_t02_holding_block,
           l_t02_holding_block_adjst,
           l_t02_holding_net_adjst,
           l_t02_symbol_code_m20,
           l_t02_exchange_code_m01,
           l_t02_custodian_id_m26,
           l_t02_holding_avg_cost,
           l_t02_inst_id_m02,
           l_t02_txn_entry_status,
           l_t02_cliordid_t01,
           l_t02_last_price,
           l_t02_avgprice,
           l_t02_cum_commission,
           l_t02_commission_adjst,
           l_t02_order_no,
           l_t02_order_exec_id,
           l_t02_txn_currency,
           l_t02_settle_currency,
           l_t02_broker_commission,
           l_t02_exg_commission,
           l_t02_txn_code,
           l_t02_fx_rate,
           l_t02_gl_posted_date,
           l_t02_gl_posted_status,
           l_t02_discount,
           l_t02_cashtxn_id,
           l_t02_holdingtxn_id,
           l_t02_customer_id_u01,
           l_t02_customer_no,
           l_t02_ordqty,
           l_t02_pay_method,
           l_t02_buy_pending,
           l_t02_sell_pending,
           l_t02_instrument_type,
           l_t02_cum_qty,
           l_t02_holding_manual_block,
           l_t02_possision_type,
           l_t02_accrude_interest,
           l_t02_accrude_interest_adjst,
           l_t02_counter_broker,
           l_t02_leaves_qty,
           l_t02_cumord_value,
           l_t02_cumord_netvalue,
           l_t02_cumord_netsettle,
           l_t02_audit_key,
           l_t02_pledge_qty,
           l_t02_side,
           l_t02_symbol_id_m20,
           l_t02_gainloss,
           l_t02_broker_tax,
           l_t02_exchange_tax,
           l_t02_update_type,
           l_t02_ord_status_v30,
           l_t02_ord_value_adjst,
           l_t02_exg_ord_id,
           l_t02_act_broker_tax,
           l_t02_act_exchange_tax,
           l_t02_cash_settle_date_orig,
           l_t02_holding_settle_date_orig,
           l_t02_cash_settle_date,
           l_t02_holding_settle_date,
           l_t02_unsettle_qty
      FROM t02_transaction_log
     WHERE     t02_create_date = pt02_create_date
           AND t02_trade_match_id = pt02_trade_match_id;

    UPDATE u06_cash_account
       SET u06_receivable_amount =
                 u06_receivable_amount
               - CASE
                     WHEN     l_t02_cash_settle_date < TRUNC (SYSDATE)
                          AND l_t02_amnt_in_stl_currency > 0
                          AND l_t02_side = 2                           -- Sell
                     THEN
                         l_t02_amnt_in_stl_currency
                     ELSE
                         0
                 END,
           u06_payable_blocked =
                 u06_payable_blocked
               - CASE
                     WHEN     l_t02_cash_settle_date < TRUNC (SYSDATE)
                          AND l_t02_amnt_in_stl_currency < 0
                          AND l_t02_side = 1                            -- Buy
                     THEN
                         ABS (l_t02_amnt_in_stl_currency)
                     ELSE
                         0
                 END
     WHERE u06_id = l_t02_cash_acnt_id_u06;

    UPDATE u24_holdings
       SET u24_receivable_holding =
                 u24_receivable_holding
               - CASE
                     WHEN     l_t02_holding_settle_date < TRUNC (SYSDATE)
                          AND l_t02_side = 1                             --Buy
                     THEN
                         pt02_last_shares
                     ELSE
                         0
                 END,
           u24_payable_holding =
                 u24_payable_holding
               - CASE
                     WHEN     l_t02_holding_settle_date < TRUNC (SYSDATE)
                          AND l_t02_side = 2                            --Sell
                     THEN
                         pt02_last_shares
                     ELSE
                         0
                 END
     WHERE     u24_trading_acnt_id_u07 = l_t02_trd_acnt_id_u07
           AND u24_custodian_id_m26 = l_t02_custodian_id_m26
           AND u24_symbol_code_m20 = l_t02_symbol_code_m20
           AND u24_exchange_code_m01 = l_t02_exchange_code_m01;


    IF l_t02_last_shares = pt02_last_shares
    THEN
        UPDATE t02_transaction_log
           SET t02_fail_management_status = 2,
               t02_unsettle_qty = 0,
               t02_cash_settle_date =
                   CASE
                       WHEN l_t02_cash_settle_date <
                                l_t02_cash_settle_date_orig
                       THEN
                           l_t02_cash_settle_date_orig
                       ELSE
                           l_t02_cash_settle_date
                   END,
               t02_holding_settle_date =
                   CASE
                       WHEN l_t02_holding_settle_date <
                                l_t02_holding_settle_date_orig
                       THEN
                           l_t02_holding_settle_date_orig
                       ELSE
                           l_t02_holding_settle_date
                   END,
               t02_trade_process_stat_id_v01 =
                   CASE
                       WHEN (CASE
                                 WHEN l_t02_holding_settle_date <
                                          l_t02_holding_settle_date_orig
                                 THEN
                                     l_t02_holding_settle_date_orig
                                 ELSE
                                     l_t02_holding_settle_date
                             END) <= TRUNC (SYSDATE)
                       THEN
                           25
                       ELSE
                           24
                   END
         WHERE     t02_trade_match_id = pt02_trade_match_id
               AND t02_create_date = pt02_create_date;
    --AND t02_txn_time BETWEEN TRUNC (pt02_datetime)
    --                     AND TRUNC (pt02_datetime) + 0.99999; --WHERE t02_audit_key = l_t02_audit_key;

    ELSE
        INSERT INTO t02_transaction_log (t02_amnt_in_txn_currency,
                                         t02_amnt_in_stl_currency,
                                         t02_cash_acnt_id_u06,
                                         t02_cash_block,
                                         t02_cash_block_orig,
                                         t02_cash_block_adjst,
                                         t02_cash_balance,
                                         t02_cash_acnt_seq_id,
                                         t02_trd_acnt_id_u07,
                                         t02_holding_net,
                                         t02_holding_block,
                                         t02_holding_block_adjst,
                                         t02_holding_net_adjst,
                                         t02_symbol_code_m20,
                                         t02_exchange_code_m01,
                                         t02_custodian_id_m26,
                                         t02_holding_avg_cost,
                                         t02_inst_id_m02,
                                         t02_txn_entry_status,
                                         t02_last_shares,
                                         t02_create_datetime,
                                         t02_create_date,
                                         t02_cliordid_t01,
                                         t02_last_price,
                                         t02_avgprice,
                                         t02_cum_commission,
                                         t02_commission_adjst,
                                         t02_order_no,
                                         t02_order_exec_id,
                                         t02_txn_currency,
                                         t02_settle_currency,
                                         --t02_broker_commission,
                                         t02_exg_commission,
                                         t02_txn_code,
                                         t02_fx_rate,
                                         t02_gl_posted_date,
                                         t02_gl_posted_status,
                                         t02_discount,
                                         t02_cashtxn_id,
                                         t02_holdingtxn_id,
                                         t02_customer_id_u01,
                                         t02_customer_no,
                                         t02_ordqty,
                                         t02_pay_method,
                                         t02_narration,
                                         t02_cash_settle_date,
                                         t02_holding_settle_date,
                                         t02_buy_pending,
                                         t02_sell_pending,
                                         t02_instrument_type,
                                         t02_cum_qty,
                                         t02_holding_manual_block,
                                         t02_possision_type,
                                         t02_accrude_interest,
                                         t02_accrude_interest_adjst,
                                         t02_counter_broker,
                                         t02_txn_time,
                                         t02_leaves_qty,
                                         t02_text,
                                         t02_cumord_value,
                                         t02_cumord_netvalue,
                                         t02_cumord_netsettle,
                                         t02_audit_key,
                                         t02_pledge_qty,
                                         t02_side,
                                         t02_symbol_id_m20,
                                         t02_gainloss,
                                         t02_broker_tax,
                                         t02_exchange_tax,
                                         t02_update_type,
                                         t02_db_create_date,
                                         t02_ord_status_v30,
                                         t02_fail_management_status,
                                         t02_ord_value_adjst,
                                         t02_trade_match_id,
                                         t02_exg_ord_id,
                                         t02_act_broker_tax,
                                         t02_act_exchange_tax,
                                         t02_cash_settle_date_orig,
                                         t02_holding_settle_date_orig,
                                         t02_trade_process_stat_id_v01)
             VALUES (
                        l_t02_amnt_in_txn_currency, --t02_amnt_in_txn_currency
                        l_t02_amnt_in_stl_currency, --t02_amnt_in_stl_currency
                        l_t02_cash_acnt_id_u06,         --t02_cash_acnt_id_u06
                        l_t02_cash_block,                     --t02_cash_block
                        l_t02_cash_block_orig,           --t02_cash_block_orig
                        l_t02_cash_block_adjst,         --t02_cash_block_adjst
                        l_t02_cash_balance,                 --t02_cash_balance
                        l_t02_cash_acnt_seq_id,         --t02_cash_acnt_seq_id
                        l_t02_trd_acnt_id_u07,           --t02_trd_acnt_id_u07
                        l_t02_holding_net,                   --t02_holding_net
                        l_t02_holding_block,               --t02_holding_block
                        l_t02_holding_block_adjst,   --t02_holding_block_adjst
                        l_t02_holding_net_adjst,       --t02_holding_net_adjst
                        l_t02_symbol_code_m20,           --t02_symbol_code_m20
                        l_t02_exchange_code_m01,       --t02_exchange_code_m01
                        l_t02_custodian_id_m26,         --t02_custodian_id_m26
                        l_t02_holding_avg_cost,         --t02_holding_avg_cost
                        l_t02_inst_id_m02,                   --t02_inst_id_m02
                        l_t02_txn_entry_status,         --t02_txn_entry_status
                        pt02_last_shares,                    --t02_last_shares
                        SYSDATE,                         --t02_create_datetime
                        TRUNC (SYSDATE),                     --t02_create_date
                        l_t02_cliordid_t01,                 --t02_cliordid_t01
                        l_t02_last_price,                     --t02_last_price
                        l_t02_avgprice,                         --t02_avgprice
                        l_t02_cum_commission,             --t02_cum_commission
                        l_t02_commission_adjst,         --t02_commission_adjst
                        l_t02_order_no,                         --t02_order_no
                        l_t02_order_exec_id,               --t02_order_exec_id
                        l_t02_txn_currency,                 --t02_txn_currency
                        l_t02_settle_currency,           --t02_settle_currency
                        --l_t02_broker_commission,           --t02_broker_commission
                        l_t02_exg_commission,             --t02_exg_commission
                        l_t02_txn_code,                         --t02_txn_code
                        l_t02_fx_rate,                           --t02_fx_rate
                        l_t02_gl_posted_date,             --t02_gl_posted_date
                        l_t02_gl_posted_status,         --t02_gl_posted_status
                        l_t02_discount,                         --t02_discount
                        l_t02_cashtxn_id,                     --t02_cashtxn_id
                        l_t02_holdingtxn_id,               --t02_holdingtxn_id
                        l_t02_customer_id_u01,           --t02_customer_id_u01
                        l_t02_customer_no,                   --t02_customer_no
                        l_t02_ordqty,                             --t02_ordqty
                        l_t02_pay_method,                     --t02_pay_method
                           l_t02_order_exec_id
                        || ' 1637252035 :  PARTIAL/FULL '
                        || CASE
                               WHEN l_t02_txn_code = 'STLBUY' THEN 'BUY'
                               ELSE 'SELL'
                           END
                        || ' EXECUTION '
                        || l_t02_symbol_code_m20
                        || ' QTY '
                        || pt02_last_shares
                        || ' @ '
                        || l_t02_last_price,                   --t02_narration
                        CASE
                            WHEN l_t02_cash_settle_date_orig <=
                                     TRUNC (SYSDATE)
                            THEN
                                TRUNC (SYSDATE)
                            ELSE
                                l_t02_cash_settle_date_orig
                        END,                            --t02_cash_settle_date
                        CASE
                            WHEN l_t02_holding_settle_date_orig <=
                                     TRUNC (SYSDATE)
                            THEN
                                TRUNC (SYSDATE)
                            ELSE
                                l_t02_holding_settle_date_orig
                        END,                         --t02_holding_settle_date
                        l_t02_buy_pending,                   --t02_buy_pending
                        l_t02_sell_pending,                 --t02_sell_pending
                        l_t02_instrument_type,           --t02_instrument_type
                        l_t02_cum_qty,                           --t02_cum_qty
                        l_t02_holding_manual_block, --t02_holding_manual_block
                        l_t02_possision_type,             --t02_possision_type
                        l_t02_accrude_interest,         --t02_accrude_interest
                        l_t02_accrude_interest_adjst, --t02_accrude_interest_adjst
                        l_t02_counter_broker,             --t02_counter_broker
                        SYSDATE,                                --t02_txn_time
                        l_t02_leaves_qty,                     --t02_leaves_qty
                           l_t02_order_exec_id
                        || ' 1637252035 :  PARTIAL/FULL '
                        || CASE
                               WHEN l_t02_txn_code = 'STLBUY' THEN 'BUY'
                               ELSE 'SELL'
                           END
                        || ' EXECUTION '
                        || l_t02_symbol_code_m20
                        || ' QTY '
                        || pt02_last_shares
                        || ' @ '
                        || l_t02_last_price,                        --t02_text
                        l_t02_cumord_value,                 --t02_cumord_value
                        l_t02_cumord_netvalue,           --t02_cumord_netvalue
                        l_t02_cumord_netsettle,         --t02_cumord_netsettle
                        l_t02_audit_key,                       --t02_audit_key
                        l_t02_pledge_qty,                     --t02_pledge_qty
                        l_t02_side,                                 --t02_side
                        l_t02_symbol_id_m20,               --t02_symbol_id_m20
                        l_t02_gainloss,                         --t02_gainloss
                        l_t02_broker_tax,                     --t02_broker_tax
                        l_t02_exchange_tax,                 --t02_exchange_tax
                        l_t02_update_type,                   --t02_update_type
                        SYSDATE,                          --t02_db_create_date
                        DECODE (l_t02_ord_status_v30,
                                2, 1,
                                l_t02_ord_status_v30),    --t02_ord_status_v30
                        0,                        --t02_fail_management_status
                        l_t02_ord_value_adjst,           --t02_ord_value_adjst
                        pt02_trade_match_id_new,          --t02_trade_match_id
                        l_t02_exg_ord_id,                     --t02_exg_ord_id
                        l_t02_act_broker_tax,             --t02_act_broker_tax
                        l_t02_act_exchange_tax,         --t02_act_exchange_tax
                        l_t02_cash_settle_date_orig, --t02_cash_settle_date_orig
                        l_t02_holding_settle_date_orig, --t02_holding_settle_date_orig,
                        25 -- t02_trade_process_stat_id_v01
                                                      );

        UPDATE t02_transaction_log
           SET t02_amnt_in_txn_currency =
                   t02_amnt_in_txn_currency - l_t02_amnt_in_txn_currency,
               t02_amnt_in_stl_currency =
                   t02_amnt_in_stl_currency - l_t02_amnt_in_stl_currency,
               t02_cash_acnt_id_u06 = l_t02_cash_acnt_id_u06,
               t02_cash_block = t02_cash_block - l_t02_cash_block_adjst,
               t02_cash_block_orig =
                   t02_cash_block_orig - l_t02_cash_block_adjst,
               t02_cash_balance =
                   t02_cash_balance - l_t02_amnt_in_stl_currency,
               t02_cash_acnt_seq_id = t02_cash_acnt_seq_id + 1,          --TBD
               t02_holding_net = t02_holding_net - l_t02_holding_net,
               t02_holding_net_adjst =
                   t02_holding_net_adjst - l_t02_holding_net_adjst,
               t02_last_shares = t02_last_shares - pt02_last_shares,
               t02_cum_commission = t02_cum_commission - l_t02_cum_commission,
               t02_commission_adjst =
                   t02_commission_adjst - l_t02_commission_adjst,
               --t02_broker_commission =
               --    t02_broker_commission - l_t02_broker_commission,
               t02_exg_commission = t02_exg_commission - l_t02_exg_commission,
               t02_discount = t02_discount - l_t02_discount,
               t02_narration =
                           l_t02_order_exec_id
                        || ' :  PARTIAL/FULL '
                        || CASE
                               WHEN l_t02_txn_code = 'STLBUY' THEN 'BUY'
                               ELSE 'SELL'
                           END
                        || ' EXECUTION '
                        || l_t02_symbol_code_m20
                        || ' QTY '
                        || t02_last_shares
                      - pt02_last_shares
                   || ' @ '
                   || l_t02_last_price,
               t02_cash_settle_date = t02_cash_settle_date + 1,
               t02_holding_settle_date = t02_holding_settle_date + 1,
               t02_trade_process_stat_id_v01 = 24,
               t02_buy_pending = t02_buy_pending - pt02_last_shares,
               t02_sell_pending = t02_sell_pending - pt02_last_shares,
               t02_cum_qty = t02_cum_qty - pt02_last_shares,
               t02_leaves_qty = t02_leaves_qty - l_t02_leaves_qty,
               t02_text =
                           l_t02_order_exec_id
                        || ' :  PARTIAL/FULL '
                        || CASE
                               WHEN l_t02_txn_code = 'STLBUY' THEN 'BUY'
                               ELSE 'SELL'
                           END
                        || ' EXECUTION '
                        || l_t02_symbol_code_m20
                        || ' QTY '
                        || t02_last_shares
                      - pt02_last_shares
                   || ' @ '
                   || l_t02_last_price,
               t02_cumord_value = t02_cumord_value - l_t02_cumord_value,
               t02_cumord_netvalue =
                   t02_cumord_netvalue - l_t02_cumord_netvalue,
               t02_cumord_netsettle =
                   t02_cumord_netsettle - l_t02_cumord_netsettle,
               t02_gainloss = t02_gainloss - l_t02_gainloss,
               t02_broker_tax = t02_broker_tax - l_t02_broker_tax,
               t02_exchange_tax = t02_exchange_tax - l_t02_exchange_tax,
               t02_ord_value_adjst =
                   t02_ord_value_adjst - l_t02_ord_value_adjst,
               t02_act_broker_tax = t02_act_broker_tax - l_t02_act_broker_tax,
               t02_act_exchange_tax =
                   t02_act_exchange_tax - l_t02_act_exchange_tax,
               t02_unsettle_qty =
                   CASE
                       WHEN t02_unsettle_qty = 0
                       THEN
                           l_t02_last_shares - pt02_last_shares
                       ELSE
                           t02_unsettle_qty - pt02_last_shares
                   END
         WHERE     t02_create_date = pt02_create_date
               AND t02_trade_match_id = pt02_trade_match_id;

        pkey := '1';
    END IF;

    SELECT SUM (t02_unsettle_qty)
      INTO l_t02_unsettle_qty
      FROM t02_transaction_log
     WHERE     t02_create_date BETWEEN TRUNC (pt02_create_date - 40)
                                   AND TRUNC (SYSDATE) + 0.99999
           AND t02_order_no = l_t02_order_no;

    UPDATE t01_order
       SET t01_unsettle_qty = l_t02_unsettle_qty
     WHERE     t01_ord_no = l_t02_order_no
           AND t01_status_id_v30 IN ('1', '2', 'q', 'r', '5')
           AND t01_last_updated_date_time BETWEEN TRUNC (
                                                      pt02_create_date - 5)
                                              AND TRUNC (SYSDATE) + 0.99999;
END;
/
/
