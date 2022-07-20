CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t35_post_trade_sources
(
    t35_id,
    t35_request_id_t34,
    u07_customer_no_u01,
    u07_display_name_u01,
    u07_display_name,
    u06_display_name,
    t35_order_no,
    t35_execution_id_t02,
    t02_exchange_code_m01,
    t35_source_symbol,
    order_side,
    t35_original_qty,
    t35_allocated_qty,
    t35_price,
    t35_original_value,
    t35_allocated_value,
    t35_cash_diff,
    t35_cash_settle_date,
    t35_holding_settle_date
)
AS
    SELECT t35.t35_id,
           t35.t35_request_id_t34,
           u07.u07_customer_no_u01,
           u07.u07_display_name_u01,
           u07.u07_display_name,
           u06.u06_display_name,
           t35.t35_order_no,
           t35.t35_execution_id_t02,
           t02.t02_exchange_code_m01,
           t35.t35_source_symbol,
           CASE
               WHEN t02.t02_side = 1 THEN 'BUY'
               WHEN t02.t02_side = 2 THEN 'SELL'
               ELSE 'SUB'
           END
               order_side,
           t35.t35_original_qty,
           ABS (t35.t35_allocated_qty) AS t35_allocated_qty,
           t35.t35_price,
           t35.t35_original_value,
           t35.t35_allocated_value,
           ABS (t35.t35_cash_diff) AS t35_cash_diff,
           t35.t35_cash_settle_date,
           t35.t35_holding_settle_date
      FROM t35_post_trade_sources t35
           INNER JOIN u07_trading_account u07
               ON t35.t35_trd_acnt_id_u07 = u07.u07_id
           INNER JOIN u06_cash_account u06
               ON t35.t35_cash_acnt_id_u06 = u06.u06_id
           INNER JOIN t02_transaction_log_order_all t02
               ON t02.t02_last_db_seq_id = t35.t35_execution_id_t02

/
