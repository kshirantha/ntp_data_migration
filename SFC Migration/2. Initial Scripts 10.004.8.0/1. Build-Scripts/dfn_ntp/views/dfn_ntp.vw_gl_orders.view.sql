CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_gl_orders
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
    t02_instrument_type,
    t02_side,
    t02_symbol_code_m20,
    t02_last_shares,
    m26_name,
    order_value,
    t02_exchange_code_m01
)
AS
      SELECT t02_txn_code AS txn_code,
             t02.t02_cash_acnt_id_u06 AS cash_account_id_u06,
             t02.t02_inst_id_m02 AS institute_id_m02,
             t02.t02_order_no AS txn_ref,
             t02.t02_create_date AS txn_date,
             t02.t02_cash_settle_date AS settle_date,
             SUM (t02.t02_amnt_in_txn_currency) AS amount_in_txn_currency,
             SUM (t02.t02_amnt_in_stl_currency) AS amount_in_stl_currency,
             m03.m03_code AS currency_code_m03,
             MAX (m03.m03_id) AS currency_id_m03,
             SUM (t02.t02_cumord_value) AS order_exec_value,
             SUM (t02.t02_cum_commission) AS order_tot_commission,
             SUM (t02.t02_cum_commission - t02_exg_commission)
                 AS order_brk_commission,
             SUM (t02.t02_exg_commission) AS order_exg_commission,
             MAX (t02.t02_cash_acnt_seq_id) AS cash_acnt_seq_id,
             SUM (t02.t02_broker_tax) AS broker_tax,
             SUM (t02.t02_exchange_tax) AS exchange_tax,
             t02.t02_instrument_type,
             t02.t02_side,
             t02.t02_symbol_code_m20,
             SUM (t02.t02_last_shares) AS t02_last_shares,
             MAX (m26.m26_name) AS m26_name,
             SUM (t02.t02_last_shares * t02.t02_last_price) AS order_value,
             t02.t02_exchange_code_m01
        FROM t02_transaction_log_order_arc t02
             JOIN m03_currency m03
                 ON t02.t02_settle_currency = m03.m03_code
             LEFT JOIN m26_executing_broker m26
                 ON t02.t02_custodian_id_m26 = m26.m26_id
    GROUP BY t02.t02_inst_id_m02,
             t02.t02_create_date,
             t02.t02_cash_settle_date,
             t02_trade_process_stat_id_v01,
             t02_txn_code,
             t02.t02_cash_acnt_id_u06,
             m03.m03_code,
             t02.t02_order_no,
             t02.t02_instrument_type,
             t02.t02_side,
             t02.t02_symbol_code_m20,
             t02.t02_exchange_code_m01
/
