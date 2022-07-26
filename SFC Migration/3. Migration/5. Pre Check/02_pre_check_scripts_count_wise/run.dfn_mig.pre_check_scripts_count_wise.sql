SPOOL log.run.dfn_mig.pre_check_scripts_count_wise REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@23_p_dfn_ntp.m29_markets.data.sql
COMMIT
/
@@25_p_dfn_ntp.m20_symbol.data.sql
COMMIT
/
@@29_i_dfn_ntp.m23_commission_slabs.data.sql
COMMIT
/
@@43_p_dfn_ntp.m34_exec_broker_commission.data.sql
COMMIT
/
@@47_p_dfn_ntp.m59_exchange_market_status.data.sql
COMMIT
/
@@48_p_dfn_ntp.m30_ex_market_permissions.data.sql
COMMIT
/
@@69_i_dfn_ntp.m65_saibor_basis_rates.data.sql
COMMIT
/
@@83_p_dfn_ntp.m70_custody_exchanges.data.sql
COMMIT
/
@@84_p_dfn_ntp.m72_exec_broker_cash_account.data.sql
COMMIT
/
--@@85_i_dfn_ntp.m74_margin_interest_group.data.sql -- SFC Uses Different Logic
--COMMIT
--/
@@87_i_dfn_ntp.m78_symbol_marginability.data.sql
COMMIT
/
@@88_i_dfn_ntp.m79_pending_symbl_mrg_request.data.sql
COMMIT
/
@@90_p_dfn_ntp.m87_exec_broker_exchange.data.sql
COMMIT
/
@@108_i_dfn_ntp.m119_sharia_symbol.data.sql
COMMIT
/
@@110_p_dfn_ntp.m125_exchange_instrument_type.data.sql
COMMIT
/
@@141_i_dfn_ntp.u06_cash_account.data.sql
COMMIT
/
@@143_i_dfn_ntp.u07_trading_account.data.sql
COMMIT
/
@@144_i_dfn_ntp.u08_customer_beneficiary_acc.data.sql
COMMIT
/
@@145_i_dfn_ntp.u09_customer_login.data.sql
COMMIT
/
@@146_i_dfn_ntp.u46_user_sessions.data.sql
COMMIT
/
@@162_i_dfn_ntp.u14_trading_symbol_restriction.data.sql
COMMIT
/
@@163_i_dfn_ntp.u16_trading_instrument_restric.data.sql
COMMIT
/
@@165_i_dfn_ntp.u23_customer_margin_product.data.sql
COMMIT
/
@@167_i_dfn_ntp.m43_institute_exchanges.data.sql
COMMIT
/
@@168_i_dfn_ntp.u24_holdings.data.sql
COMMIT
/
@@185_i_dfn_ntp.u49_poa_trading_privileges.data.sql
COMMIT
/
@@186_i_dfn_ntp.u55_poa_symbol_restrictions.data.sql
COMMIT
/
@@188_i_dfn_ntp.t01_order.data.sql
COMMIT
/
@@189_i_dfn_ntp.t02_transaction_log.data.sql
COMMIT
/
@@201_i_dfn_ntp.t05_institute_cash_acc_log.data.sql
COMMIT
/
@@202_i_dfn_ntp.t06_cash_transaction.data.sql
COMMIT
/
@@204_i_dfn_ntp.t10_cash_block_request.data.sql
COMMIT
/
@@206_i_dfn_ntp.t12_share_transaction.data.sql
COMMIT
/
@@207_i_dfn_ntp.t20_pending_pledg.data.sql
COMMIT
/
@@208_i_dfn_ntp.t21_daily_interest_for_charges.data.sql
COMMIT
/
@@228_i_dfn_ntp.h07_user_sessions.data.sql
COMMIT
/
@@230_i_dfn_ntp.h10_bank_accounts_summary.data.sql
COMMIT
/
@@241_i_dfn_ntp.a06_audit.data.sql
COMMIT
/
@@263_i_dfn_ntp.m158_priceuser_agreement.data.sql
COMMIT
/
/* Janaka: Will be Handled from ETI Migration
@@267_i_dfn_ntp.m152_products.data.sql
COMMIT
/
@@270_i_dfn_ntp.m155_product_waiveoff_details.data.sql
COMMIT
/
@@281_i_dfn_ntp.m156_exchange_waiveoff_details.data.sql
COMMIT
/
*/
@@284_i_dfn_ntp.m160_offline_symbol_update_log.data.sql
COMMIT
/
@@301_i_dfn_ntp.m170_institute_cash_acc_config.data.sql
COMMIT
/
@@303_i_dfn_ntp.t501_payment_detail_c.data.sql
COMMIT
/
@@310_i_dfn_ntp.t41_cust_corp_act_distribution.data.sql
COMMIT
/
@@323_i_dfn_ntp.m18_derivative_spread_matrix.data.sql
COMMIT
/
@@324_i_dfn_ntp.t15_authorization_request.data.sql
COMMIT
/
@@326_i_dfn_ntp.t48_tax_invoices.data.sql
COMMIT
/
@@327_i_dfn_ntp.t49_tax_invoice_details.data.sql
COMMIT
/
@@330_i_dfn_ntp.t70_mark_to_market.data.sql
COMMIT
/
@@341_i_dfn_ntp.t75_murabaha_contracts.data.sql
COMMIT
/

SPOOL OFF

EXIT
