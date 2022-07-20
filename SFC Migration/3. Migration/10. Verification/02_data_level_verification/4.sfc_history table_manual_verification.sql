------------- H02 - OLD --------------

SELECT s02_date,
       s02_account_id,
       s02_profile_id,
       s02_balance,
       s02_blocked_amount,
       s02_trimdate,
       s02_opening_balance,
       s02_deposit,
       s02_withdrawals,
       s02_buy,
       s02_sell,
       s02_commission,
       s02_charges,
       s02_currency,
       s02_trd_lmt_secondary,
       s02_lmt_secondary_expiry,
       s02_lmt_primary_expiry,
       s02_margin_due,
       s02_margin_block,
       s02_pending_settle,
       s02_payable_amount,
       s02_accrual_interest,
       s02_margin_utilized,
       s02_net_receivable,
       s02_trading_block_amount
  FROM mubasher_oms.s02_cash_account_summary@mubasher_db_link s02;

------------- H02 - NEW --------------

SELECT h02_date,
       h02_cash_account_id_u06,
       h02_customer_id_u01,
       h02_balance,
       h02_blocked,
       h02_date,
       h02_opening_balance,
       h02_deposits,
       h02_withdrawals,
       h02_net_buy,
       h02_net_sell,
       h02_net_commission,
       h02_net_charges_refunds,
       h02_currency_code_m03 u06_secondary_od_limit,
       h02_secondary_expiry,
       h02_primary_expiry,
       h02_margin_due,
       h02_margin_block,
       h02_receivable_amount,
       h02_payable_blocked u06_accrued_interest,
       h02_margin_utilized,
       h02_net_receivable,
       h02_manual_trade_blocked
  FROM dfn_ntp.h02_cash_account_summary h02;

------------- H01 TDWL - OLD --------------

SELECT s01_date,
       s01_security_ac_id,
       NVL (map16.map16_ntp_code, s01_exchange) AS s01_exchange,
       s01_symbol,
       s01_net_holdings,
       s01_avg_cost,
       s01_sell_pending,
       s01_pledgedqty,
       s01_buy_pending,
       s01_avg_price,
       s01_inst_id,
       s01_trimdate,
       s01_lasttradeprice,
       s01_vwap,
       s01_previousclosed,
       s01_weighted_avg_cost,
       s01_short_holding,
       s01_other_blocked_qty,
       s01_payable_holding,
       s01_pending_settle,
       s01_pending_subscription,
       s01_subscribed_quantity,
       s01_net_receivable
  FROM mubasher_oms.s01_holdings_summary@mubasher_db_link s01,
       map16_optional_exchanges_m01 map16
 WHERE s01.s01_exchange = map16.map16_oms_code(+);

------------- H01 TDWL - NEW --------------

SELECT h01_date,
       h01_trading_acnt_id_u07,
       h01_exchange_code_m01,
       h01_symbol_code_m20,
       h01_net_holding,
       h01_avg_cost,
       h01_sell_pending,
       h01_pledge_qty,
       h01_buy_pending,
       h01_avg_price,
       h01_primary_institute_id_m02,
       h01_date,
       h01_last_trade_price,
       h01_vwap,
       h01_previous_closed,
       h01_weighted_avg_cost,
       h01_short_holdings,
       h01_manual_block,
       h01_payable_holding,
       h01_receivable_holding,
       h01_pending_subscribe_qty,
       h01_subscribed_qty,
       h01_net_receivable
  FROM dfn_ntp.h01_holding_summary h01;

----------- H01 NON-TDWL - OLD ------------

SELECT s05_date,
       s05_security_ac_id,
       NVL (map16.map16_ntp_code, s05_exchange) AS s05_exchange,
       s05_symbol,
       s05_custodian,
       s05_net_holdings,
       s05_buy_pending,
       s05_sell_pending,
       s05_trimdate,
       s05_avg_cost,
       s05_short_holding,
       s05_payable_holding,
       s05_pending_settle
  FROM mubasher_oms.s05_custodian_holdings_summary@mubasher_db_link s05,
       map16_optional_exchanges_m01 map16
 WHERE s05.s05_exchange = map16.map16_oms_code(+);

----------- H01 NON-TDWL - NEW ------------

SELECT h01_date,
       h01_trading_acnt_id_u07,
       h01_exchange_code_m01,
       h01_symbol_code_m20,
       h01_custodian_id_m26,
       h01_net_holding,
       h01_buy_pending,
       h01_sell_pending,
       h01_date,
       h01_avg_cost,
       h01_short_holdings,
       h01_payable_holding,
       h01_receivable_holding
  FROM dfn_ntp.h01_holding_summary h01;