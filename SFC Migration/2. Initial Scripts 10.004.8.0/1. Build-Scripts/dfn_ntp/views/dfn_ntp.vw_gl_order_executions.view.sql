CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_gl_order_executions
(
    txn_code,
    cash_account_id_u06,
    institute_id_m02,
    txn_ref,
    txn_date,
    settle_date,
    amount_in_txn_currency,
    amount_in_stl_currency,
    currency_code_m03,
    currency_id_m03,
    order_exec_value,
    order_tot_commission,
    order_brk_commission,
    order_exg_commission,
    cash_acnt_seq_id,
    broker_tax,
    exchange_tax,
    symbol_code_m20,
    exchange_code_m01,
    last_shares,
    order_value,
    commission_discount,
    order_side_v01,
    market_segment_v01,
    instrument_type_code_v09,
    custodian_type_v01,
    t02_discount,
    fx_rate
)
AS
    SELECT t02_txn_code AS txn_code,
           t02.t02_cash_acnt_id_u06 AS cash_account_id_u06,
           t02.t02_inst_id_m02 AS institute_id_m02,
           t02.t02_order_exec_id AS txn_ref,
           t02.t02_create_date AS txn_date,
           t02.t02_cash_settle_date AS settle_date,
           t02.t02_amnt_in_txn_currency AS amount_in_txn_currency,
           t02.t02_amnt_in_stl_currency AS amount_in_stl_currency,
           m03.m03_code AS currency_code_m03,
           m03.m03_id AS currency_id_m03,
           t02.t02_cumord_value AS order_exec_value,
           t02.t02_cum_commission AS order_tot_commission,
           t02.t02_cum_commission - t02_exg_commission
               AS order_brk_commission,
           t02.t02_exg_commission AS order_exg_commission,
           t02.t02_cash_acnt_seq_id AS cash_acnt_seq_id,
           t02_broker_tax AS broker_tax,
           t02_exchange_tax AS exchange_tax,
           t02.t02_symbol_code_m20 AS symbol_code_m20,
           t02.t02_exchange_code_m01 AS exchange_code_m01,
           t02.t02_last_shares AS last_shares,
           t02.t02_last_shares * t02.t02_last_price AS order_value,
           t02.t02_discount AS commission_discount,
           t02.t02_side AS order_side_v01,
           m20.m20_market_segment AS market_segment_v01,
           t02.t02_instrument_type AS instrument_type_code_v09,
           t02.t02_custodian_type_v01 AS custodian_type_v01,
           t02.t02_discount,
           t02.t02_fx_rate AS fx_rate
      FROM t02_transaction_log_order_arc t02
           JOIN m03_currency m03
               ON t02.t02_settle_currency = m03.m03_code
           JOIN m20_symbol m20
               ON t02.t02_symbol_id_m20 = m20.m20_id
/