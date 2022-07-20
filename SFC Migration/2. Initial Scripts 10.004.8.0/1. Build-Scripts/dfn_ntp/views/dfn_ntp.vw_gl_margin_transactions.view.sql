CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_gl_margin_transactions
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
    margin_category_id_v01,
    margin_risk_owner
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
           m73.m73_margin_category_id_v01 AS margin_category_id_v01,
           m73.m73_risk_owner AS margin_risk_owner
      FROM t02_transaction_log_cash_all t02
           JOIN u06_cash_account u06
               ON t02.t02_cash_acnt_id_u06 = u06.u06_id
           JOIN u23_customer_margin_product u23
               ON u06.u06_margin_product_id_u23 = u23.u23_id
           JOIN m03_currency m03
               ON t02.t02_settle_currency = m03.m03_code
           JOIN m73_margin_products m73
               ON u23.u23_margin_product_m73 = m73.m73_id
/
