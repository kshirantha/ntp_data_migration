CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t36_post_trade_destination
(
    t36_id,
    t36_request_id_t34,
    u07_customer_no_u01,
    u07_display_name_u01,
    u07_display_name,
    u07_display_name_u06,
    m26_sid,
    custodian,
    t36_allocated_qty,
    t36_price,
    total_commission,
    total_tax,
    t36_order_value,
    t36_order_net_value,
    order_side,
    t36_exchange,
    t36_symbol,
    t36_cash_settle_date,
    t36_holding_settle_date,
    t36_accrued_interest,
    m20_instrument_type_code_v09
)
AS
    SELECT t36.t36_id,
           t36.t36_request_id_t34,
           u07.u07_customer_no_u01,
           u07.u07_display_name_u01,
           u07.u07_display_name,
           u07.u07_display_name_u06,
           m26.m26_sid,
           m26.m26_name AS custodian,
           t36.t36_allocated_qty,
           t36.t36_price,
           t36.t36_customer_commission + t36.t36_exchange_commission
               total_commission,
           t36.t36_customer_tax + t36.t36_exchange_tax total_tax,
           t36.t36_order_value,
           ABS (t36.t36_order_net_value) AS t36_order_net_value,
           CASE
               WHEN t36.t36_side = 1 THEN 'Buy'
               WHEN t36.t36_side = 2 THEN 'Sell'
               ELSE 'Sub'
           END
               order_side,
           t36.t36_exchange,
           t36.t36_symbol,
           t36.t36_cash_settle_date,
           t36.t36_holding_settle_date,
           t36.t36_accrued_interest,
           m20.m20_instrument_type_code_v09
      FROM t36_post_trade_destination t36
           INNER JOIN u07_trading_account u07
               ON t36.t36_trd_acnt_id_u07 = u07.u07_id
           INNER JOIN m26_executing_broker m26
               ON t36.t36_custodian_id_m26 = m26.m26_id
           LEFT JOIN m20_symbol m20
               ON     t36.t36_symbol = m20.m20_symbol_code
                  AND t36.t36_exchange = m20.m20_exchange_code_m01
                  AND t36.t36_inst_id_m02 = m20.m20_institute_id_m02
/