CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_gl_cash_transactions
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
    narration_expression,
    fx_rate,
    exchange_code_m01
)
AS
    SELECT t02_txn_code AS txn_code,
           t02.t02_cash_acnt_id_u06 AS cash_account_id_u06,
           t02.t02_inst_id_m02 AS institute_id_m02,
           t02.t02_cashtxn_id AS txn_ref,
           t02.t02_create_date AS txn_date,
           t02.t02_cash_settle_date AS settle_date,
           t02.t02_amnt_in_txn_currency AS amount_in_txn_currency,
           t02.t02_amnt_in_stl_currency AS amount_in_stl_currency,
           m03.m03_code AS currency_code_m03,
           m03.m03_id AS currency_id_m03,
           t02.t02_cumord_value AS order_exec_value,
           t02.t02_commission_adjst AS order_tot_commission,
           t02.t02_commission_adjst - t02_exg_commission
               AS order_brk_commission,
           t02.t02_exg_commission AS order_exg_commission,
           t02.t02_cash_acnt_seq_id AS cash_acnt_seq_id,
           t02.t02_broker_tax AS broker_tax,
           t02.t02_exchange_tax AS exchange_tax,
           t02.t02_symbol_code_m20 AS symbol_code_m20,
           t02.t02_narration AS narration_expression,
           t02.t02_fx_rate AS fx_rate,
           t02.t02_exchange_code_m01 AS exchange_code_m01
      FROM     t02_transaction_log_cash_all t02
           JOIN
               m03_currency m03
           ON t02.t02_settle_currency = m03.m03_code
/