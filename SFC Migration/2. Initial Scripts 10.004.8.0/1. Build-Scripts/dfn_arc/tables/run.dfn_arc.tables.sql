SPOOL log.run.dfn_arc.tables REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'config_partition' AS table_name FROM DUAL;

@@dfn_arc.config_partition.tab.sql

SELECT 'a03_approval_audit' AS table_name FROM DUAL;

@@dfn_arc.a03_approval_audit.tab.sql

SELECT 'a04_approval_audit_log' AS table_name FROM DUAL;

@@dfn_arc.a04_approval_audit_log.tab.sql

SELECT 'a06_audit' AS table_name FROM DUAL;

@@dfn_arc.a06_audit.tab.sql

SELECT 'a07_approval_column_audit' AS table_name FROM DUAL;

@@dfn_arc.a07_approval_column_audit.tab.sql

SELECT 'a08_approval_column_audit_log' AS table_name FROM DUAL;

@@dfn_arc.a08_approval_column_audit_log.tab.sql

SELECT 'a09_function_approval_log' AS table_name FROM DUAL;

@@dfn_arc.a09_function_approval_log.tab.sql

SELECT 'a10_entity_status_history' AS table_name FROM DUAL;

@@dfn_arc.a10_entity_status_history.tab.sql

SELECT 'a13_cash_holding_adjust_log' AS table_name FROM DUAL;

@@dfn_arc.a13_cash_holding_adjust_log.tab.sql

SELECT 'a18_user_login_audit' AS table_name FROM DUAL;

@@dfn_arc.a18_user_login_audit.tab.sql

SELECT 'h01_holding_summary' AS table_name FROM DUAL;

@@dfn_arc.h01_holding_summary.tab.sql

SELECT 'h02_cash_account_summary' AS table_name FROM DUAL;

@@dfn_arc.h02_cash_account_summary.tab.sql

SELECT 'h03_currency_rate' AS table_name FROM DUAL;

@@dfn_arc.h03_currency_rate.tab.sql

SELECT 'h07_user_sessions' AS table_name FROM DUAL;

@@dfn_arc.h07_user_sessions.tab.sql

SELECT 'm36_settlement_calendar' AS table_name FROM DUAL;

@@dfn_arc.m36_settlement_calendar.tab.sql

SELECT 't01_order' AS table_name FROM DUAL;

@@dfn_arc.t01_order.tab.sql

SELECT 't02_transaction_log' AS table_name FROM DUAL;

@@dfn_arc.t02_transaction_log.tab.sql

SELECT 't06_cash_transaction' AS table_name FROM DUAL;

@@dfn_arc.t06_cash_transaction.tab.sql

SELECT 't09_error_records' AS table_name FROM DUAL;

@@dfn_arc.t09_error_records.tab.sql

SELECT 't09_txn_single_entry_v3' AS table_name FROM DUAL;

@@dfn_arc.t09_txn_single_entry_v3.tab.sql

SELECT 't11_block_amount_details' AS table_name FROM DUAL;

@@dfn_arc.t11_block_amount_details.tab.sql

SELECT 't12_share_transaction' AS table_name FROM DUAL;

@@dfn_arc.t12_share_transaction.tab.sql

SELECT 't13_notifications' AS table_name FROM DUAL;

@@dfn_arc.t13_notifications.tab.sql

SELECT 't21_daily_interest_for_charges' AS table_name FROM DUAL;

@@dfn_arc.t21_daily_interest_for_charges.tab.sql

SELECT 't22_order_audit' AS table_name FROM DUAL;

@@dfn_arc.t22_order_audit.tab.sql

SELECT 't58_cache_clear_request' AS table_name FROM DUAL;

@@dfn_arc.t58_cache_clear_request.tab.sql

SELECT 't59_product_subscription_log' AS table_name FROM DUAL;

@@dfn_arc.t59_product_subscription_log.tab.sql

SELECT 't60_exchange_subscription_log' AS table_name FROM DUAL;

@@dfn_arc.t60_exchange_subscription_log.tab.sql

SPOOL OFF
