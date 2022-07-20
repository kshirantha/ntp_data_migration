SPOOL log.run.dfn_ntp.jobs REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'update_pending_cash_eod' AS job_name FROM DUAL;

@@dfn_ntp.update_pending_cash_eod.job.sql

SELECT 'update_pending_holding' AS job_name FROM DUAL;

@@dfn_ntp.update_pending_holding.job.sql

SELECT 'update_pending_holding_eod' AS job_name FROM DUAL;

@@dfn_ntp.update_pending_holding_eod.job.sql

SELECT 'apply_position_blocks' AS job_name FROM DUAL;

@@dfn_ntp.apply_position_blocks.job.sql

SELECT 'disable_trading_for_rht' AS job_name FROM DUAL;

@@dfn_ntp.disable_trading_for_rht.job.sql

SELECT 'populate_eod_prices' AS job_name FROM DUAL;

@@dfn_ntp.populate_eod_prices.job.sql

SELECT 'populate_history_tables' AS job_name FROM DUAL;

@@dfn_ntp.populate_history_tables.job.sql

SELECT 'update_customers' AS job_name FROM DUAL;

@@dfn_ntp.update_customers.job.sql

SELECT 'update_omini_bank_balances' AS job_name FROM DUAL;

@@dfn_ntp.update_omini_bank_balances.job.sql

SELECT 'update_pending_cash' AS job_name FROM DUAL;

@@dfn_ntp.update_pending_cash.job.sql

SELECT 'calculate_int_charges' AS job_name FROM DUAL;

@@dfn_ntp.calculate_int_charges.job.sql

SELECT 'capitalize_int_charges' AS job_name FROM DUAL;

@@dfn_ntp.capitalize_int_charges.job.sql

SELECT 'notify_tradable_rights_sms' AS job_name FROM DUAL;

@@dfn_ntp.notify_tradable_rights_sms.job.sql

SELECT 'populate_report_summary_tables' AS job_name FROM DUAL;

@@dfn_ntp.populate_report_summary_tables.job.sql

SELECT 'update_master_data' AS job_name FROM DUAL;

@@dfn_ntp.update_master_data.job.sql

SELECT 'update_cash_accounts' AS job_name FROM DUAL;

@@dfn_ntp.update_cash_accounts.job.sql

SELECT 'disable_transaction' AS job_name FROM DUAL;

@@dfn_ntp.disable_cash_and_holding_transaction.job.sql

SELECT 'enable_transaction' AS job_name FROM DUAL;

@@dfn_ntp.enable_cash_and_holding_transaction.job.sql

SELECT 'update_symbol_data' AS job_name FROM DUAL;

@@dfn_ntp.update_symbol_data.job.sql

SELECT 'eod_trade_confirm_activity' AS job_name FROM DUAL;

@@dfn_ntp.eod_trade_confirm_activity.job.sql

SELECT 'notify_order_limit_breach' AS job_name FROM DUAL;

@@dfn_ntp.notify_order_limit_breach.job.sql

SELECT 'calculate_custody_charges' AS job_name FROM DUAL;

@@dfn_ntp.calculate_custody_charges.job.sql

SELECT 'capitalize_custody_charges' AS job_name FROM DUAL;

@@dfn_ntp.capitalize_custody_charges.job.sql

SELECT 'update_incentive' AS job_name FROM DUAL;

@@dfn_ntp.update_incentive.job.sql

SELECT 'margin_trd_notification' AS job_name FROM DUAL;

@@dfn_ntp.margin_trd_notification.job.sql

SELECT 'm2m_profit_calculation' AS job_name FROM DUAL;

@@dfn_ntp.m2m_profit_calculation.job.sql

SELECT 'archive_table_data' AS job_name FROM DUAL;

@@dfn_ntp.archive_table_data.job.sql

SELECT 'margin_funding_covering' AS job_name FROM DUAL;

@@dfn_ntp.margin_funding_covering.job.sql

SELECT 'bond_maturity' AS job_name FROM DUAL;

@@dfn_ntp.bond_maturity.job.sql

SELECT 'custody_execb_settlement' AS job_name FROM DUAL;

@@dfn_ntp.custody_execb_settlement.job.sql

SELECT 'populate_portfolio_value_b' AS job_name FROM DUAL;

@@dfn_ntp.populate_portfolio_value_b.job.sql

SELECT 'derivative_symbol_expiry' AS job_name FROM DUAL;

@@dfn_ntp.derivative_symbol_expiry.job.sql

SELECT 'populate_murabaha_amortize' AS job_name FROM DUAL;

@@dfn_ntp.populate_murabaha_amortize.job.sql

SELECT 'oms_cache_update' AS job_name FROM DUAL;

@@dfn_ntp.oms_cache_update.job.sql

SPOOL OFF