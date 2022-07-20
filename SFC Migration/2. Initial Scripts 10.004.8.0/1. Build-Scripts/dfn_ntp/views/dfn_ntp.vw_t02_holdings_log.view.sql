CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t02_holdings_log
(
    t02_create_date,
    t02_cliordid_t01,
    t02_symbol_code_m20,
    t02_holding_net,
    last_shares,
    t02_holding_avg_cost,
    t02_sell_pending,
    t02_pledge_qty,
    t02_buy_pending,
    t02_instrument_type,
    t02_exchange_code_m01,
    t02_cash_acnt_seq_id,
    t02_narration,
    t02_customer_id_u01,
    t02_customer_no,
    t02_trd_acnt_id_u07,
    t02_create_datetime,
    u01_display_name,
    m02_name,
    t02_inst_id_m02,
    u06_investment_account_no,
    t02_side,
    side,
    SIGN,
    stmt,
    t02_last_price,
    available_qty,
    m20_long_description_lang,
    m20_long_description,
    m20_short_description_lang,
    m20_short_description,
    m20_instrument_type_code_v09,
    t02_holding_net_adjst,
    m20_isincode,
    u24_custodian_id_m26,
    t02_trade_process_stat_id_v01,
    t02_txn_entry_status
)
AS
    SELECT t02_create_date,
           t02_cliordid_t01,
           t02_symbol_code_m20,
           t02_holding_net,
           CASE
               WHEN (t02_side = 1) AND (t02_holding_net_adjst < 0)
               THEN
                   -t02_last_shares
               WHEN (t02_side = 2) AND (t02_holding_net_adjst > 0)
               THEN
                   -t02_last_shares
               WHEN t02_side = 4
               THEN
                   -t02_last_shares
               ELSE
                   t02_last_shares
           END
               AS last_shares,
           t02_holding_avg_cost,
           t02_sell_pending,
           t02_pledge_qty,
           t02_buy_pending,
           t02_instrument_type,
           t02_exchange_code_m01,
           t02_cash_acnt_seq_id,
           t02_narration,
           t02_customer_id_u01,
           t02_customer_no,
           t02_trd_acnt_id_u07,
           t02_create_datetime,
           u01.u01_display_name,
           m02.m02_name,
           a.t02_inst_id_m02,
           u06.u06_investment_account_no,
           t02_side,
           m97.m97_description AS side,
           CASE
               WHEN t02_side = 1 THEN 1
               WHEN t02_side = 2 THEN -1
               WHEN t02_side = 0 THEN 1
               WHEN t02_side = 3 THEN 1
               WHEN t02_side = 4 THEN -1
               ELSE 1
           END
               AS SIGN,
           CASE
               WHEN (t02_side = 1) AND (t02_holding_net < 0) THEN NULL
               WHEN (t02_side = 2) AND (t02_holding_net > 0) THEN NULL
               ELSE 'Yes'
           END
               AS stmt,
           t02_last_price,
           (t02_holding_net - t02_sell_pending - t02_pledge_qty)
               AS available_qty,
           j.m20_long_description_lang,
           j.m20_long_description,
           j.m20_short_description_lang,
           j.m20_short_description,
           j.m20_instrument_type_code_v09,
           t02_holding_net_adjst,
           j.m20_isincode,
           a.t02_custodian_id_m26 AS u24_custodian_id_m26,
           t02_trade_process_stat_id_v01,
           t02_txn_entry_status
      FROM t02_transaction_log a
           JOIN m20_symbol j
               ON a.t02_symbol_id_m20 = j.m20_id
           JOIN u01_customer u01
               ON a.t02_customer_id_u01 = u01.u01_id
           JOIN u06_cash_account u06
               ON a.t02_cash_acnt_id_u06 = u06.u06_id
           JOIN m02_institute m02
               ON a.t02_inst_id_m02 = m02.m02_id
           LEFT JOIN vw_m97_holding_txn_codes_base m97
               ON a.t02_txn_code = m97.m97_code
     WHERE a.t02_update_type IN (1, 3, 6) AND a.t02_holding_net_adjst <> 0
/