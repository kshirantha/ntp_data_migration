SPOOL log.run.dfn_ntp.functions REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'string_splitter' AS function_name FROM DUAL;

@@dfn_ntp.string_splitter.func.sql

SELECT 'key_value_splitter' AS function_name FROM DUAL;

@@dfn_ntp.key_value_splitter.func.sql

SELECT 'get_year_by_date' AS function_name FROM DUAL;

@@dfn_ntp.get_year_by_date.func.sql

SELECT 'get_tplus_count' AS function_name FROM DUAL;

@@dfn_ntp.get_tplus_count.func.sql

SELECT 'get_pfolio_val_by_cash_ac' AS function_name FROM DUAL;

@@dfn_ntp.get_pfolio_val_by_cash_ac.func.sql

SELECT 'get_last_day_of_month' AS function_name FROM DUAL;

@@dfn_ntp.get_last_day_of_month.func.sql

SELECT 'get_exchange_rate' AS function_name FROM DUAL;

@@dfn_ntp.get_exchange_rate.func.sql

SELECT 'func_get_eod_date' AS function_name FROM DUAL;

@@dfn_ntp.func_get_eod_date.func.sql

SELECT 'fn_get_txn_code_id' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_txn_code_id.func.sql

SELECT 'fn_get_remaining_pledge_qty' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_remaining_pledge_qty.func.sql

SELECT 'fn_get_posted_date' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_posted_date.func.sql

SELECT 'fn_get_next_sequnce' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_next_sequnce.func.sql

SELECT 'fn_get_market_turnover' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_market_turnover.func.sql

SELECT 'fn_get_market_price' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_market_price.func.sql

SELECT 'fn_get_latest_h02_date' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_latest_h02_date.func.sql

SELECT 'fn_get_latest_h01_date' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_latest_h01_date.func.sql

SELECT 'fn_get_interest_for_cash_acc' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_interest_for_cash_acc.func.sql

SELECT 'fn_get_hijri_gregorian_date' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_hijri_gregorian_date.func.sql

SELECT 'fn_get_default_omnibus_by_curr' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_default_omnibus_by_curr.func.sql

SELECT 'fn_get_customer_address' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_customer_address.func.sql

SELECT 'fn_aggregate_list' AS function_name FROM DUAL;

@@dfn_ntp.fn_aggregate_list.func.sql

SELECT 'fn_get_coupon_value' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_coupon_value.func.sql

SELECT 'fn_margin_utilized_percentage' AS function_name FROM DUAL;

@@dfn_ntp.fn_margin_utilized_percentage.func.sql

SELECT 'fn_margin_liquidation_amount' AS function_name FROM DUAL;

@@dfn_ntp.fn_margin_liquidation_amount.func.sql

SELECT 'fn_margin_current_percentage' AS function_name FROM DUAL;

@@dfn_ntp.fn_margin_current_percentage.func.sql

SELECT 'fn_get_sp_data_query' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_sp_data_query.func.sql

SELECT 'fn_get_sp_row_count_query' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_sp_row_count_query.func.sql

SELECT 'fn_get_custody_charge_amount' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_custody_charge_amount.func.sql

SELECT 'fn_get_group_buying_power' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_group_buying_power.func.sql

SELECT 'fn_get_cash_user_filter_apply' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_cash_user_filter_apply.func.sql

SELECT 'fn_get_max_txn_stl_date_diff' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_max_txn_stl_date_diff.func.sql

SELECT 'prep_trade_where_clause' AS function_name FROM DUAL;

@@dfn_ntp.prep_trade_where_clause.func.sql

SELECT 'fn_falcon_login' AS function_name FROM DUAL;

@@dfn_ntp.fn_falcon_login.func.sql

SELECT 'fn_prep_trade_where_clause' AS function_name FROM DUAL;

@@dfn_ntp.fn_prep_trade_where_clause.func.sql

SELECT 'fn_get_t78_id' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_t78_id.func.sql

SELECT 'fn_get_city_id_by_name' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_city_id_by_name.func.sql

SELECT 'fn_available_cash_for_withdraw' AS function_name FROM DUAL;

@@dfn_ntp.fn_available_cash_for_withdraw.func.sql

SELECT 'fn_get_mubasher_number' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_mubasher_number.func.sql

SELECT 'fn_filter_unasgnd_cash_acc' AS function_name FROM DUAL;

@@dfn_ntp.fn_filter_unasgnd_cash_acc.func.sql

SELECT 'fn_get_customer_filter' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_customer_filter.func.sql

SELECT 'fn_get_cash_acc_filter' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_cash_acc_filter.func.sql

SELECT 'fn_get_trading_acc_filter' AS function_name FROM DUAL;

@@dfn_ntp.fn_get_trading_acc_filter.func.sql

SPOOL OFF
