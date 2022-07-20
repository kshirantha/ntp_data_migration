CREATE OR REPLACE VIEW dfn_ntp.vw_transaction_list
(
       t02_order_no,
       t02_order_exec_id,
       t02_create_datetime,
       t02_customer_no,
       u01_display_name,
       u07_display_name_u06,
       u07_display_name,
       u07_exchange_account_no,
       t02_symbol_code_m20,
       t02_exchange_code_m01,
       t02_txn_currency,
       order_side,
       t02_ordqty,
       t02_avgprice,
       t02_cumord_value,
       t02_cumord_netsettle,
       t02_cash_settle_date,
       t02_holding_settle_date,
       custodian_name,
       t02_text,
       t02_broker_tax,
       t02_exchange_tax,
       total_tax,
       total_commission,
       t02_broker_commission,
       t02_exg_commission,
       t02_trade_confirm_no,
       t02_inst_id_m02
)
 AS
SELECT t02.t02_order_no,
       t02.t02_order_exec_id,
       t02.t02_create_datetime,
       t02.t02_customer_no,
       u01.u01_display_name,
       u07.u07_display_name_u06,
       u07.u07_display_name,
       u07.u07_exchange_account_no,
       t02.t02_symbol_code_m20,
       t02.t02_exchange_code_m01,
       t02.t02_txn_currency,
       CASE t02.t02_side
         WHEN 1 THEN
          'Buy'
         WHEN 2 THEN
          'Sell'
         WHEN 3 THEN
          'Subscription'
       END AS order_side,
       t02.t02_ordqty,
       t02.t02_avgprice,
       t02_cumord_value,
       t02_cumord_netsettle,
       t02.t02_cash_settle_date,
       t02.t02_holding_settle_date,
       m26.m26_name AS custodian_name,
       t02.t02_text,
       t02.t02_broker_tax,
       t02.t02_exchange_tax,
       t02.t02_broker_tax + t02.t02_exchange_tax AS total_tax,
       t02.t02_cum_commission AS total_commission,
       t02.t02_broker_commission,
       t02.t02_exg_commission,
       t02.t02_trade_confirm_no,
       t02.t02_inst_id_m02
  FROM t02_transaction_log_order_all t02
  LEFT JOIN u01_customer u01
    ON u01.u01_id = t02.t02_customer_id_u01
  LEFT JOIN u07_trading_account u07
    ON u07.u07_id = t02.t02_trd_acnt_id_u07
  LEFT JOIN m26_executing_broker m26
    ON m26.m26_id = t02.t02_custodian_id_m26
/