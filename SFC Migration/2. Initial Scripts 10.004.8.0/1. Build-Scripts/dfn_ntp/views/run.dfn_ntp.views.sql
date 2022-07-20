SPOOL log.run.dfn_ntp.views REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'z07_menu_all' AS view_name FROM DUAL;

@@dfn_ntp.z07_menu_all.view.sql

SELECT 'vw_z09_export_templates' AS view_name FROM DUAL;

@@dfn_ntp.vw_z09_export_templates.view.sql

SELECT 'vw_z04_forms_color' AS view_name FROM DUAL;

@@dfn_ntp.vw_z04_forms_color.view.sql

SELECT 'vw_z03_forms_menu' AS view_name FROM DUAL;

@@dfn_ntp.vw_z03_forms_menu.view.sql

SELECT 'vw_z02_forms_cols' AS view_name FROM DUAL;

@@dfn_ntp.vw_z02_forms_cols.view.sql

SELECT 'vw_z01_forms_m' AS view_name FROM DUAL;

@@dfn_ntp.vw_z01_forms_m.view.sql

SELECT 'vw_v29_order_channel' AS view_name FROM DUAL;

@@dfn_ntp.vw_v29_order_channel.view.sql

SELECT 'vw_v09_instrument_types' AS view_name FROM DUAL;

@@dfn_ntp.vw_v09_instrument_types.view.sql

SELECT 'vw_v07_db_jobs' AS view_name FROM DUAL;

@@dfn_ntp.vw_v07_db_jobs.view.sql

SELECT 'vw_user_cash_accounts' AS view_name FROM DUAL;

@@dfn_ntp.vw_user_cash_accounts.view.sql

SELECT 'vw_update_versions_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_update_versions_all.view.sql

SELECT 'vw_umessage_share_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_umessage_share_details.view.sql

SELECT 'vw_u55_poa_symbol_restrictions' AS view_name FROM DUAL;

@@dfn_ntp.vw_u55_poa_symbol_restrictions.view.sql

SELECT 'vw_u52_poa_trd_restrict_status' AS view_name FROM DUAL;

@@dfn_ntp.vw_u52_poa_trd_restrict_status.view.sql

SELECT 'vw_u51_poa_symbol_restriction' AS view_name FROM DUAL;

@@dfn_ntp.vw_u51_poa_symbol_restriction.view.sql

SELECT 'vw_u50_kyc_ecdd_annual_review' AS view_name FROM DUAL;

@@dfn_ntp.vw_u50_kyc_ecdd_annual_review.view.sql

SELECT 'vw_u49_poa_trd_privilege' AS view_name FROM DUAL;

@@dfn_ntp.vw_u49_poa_trd_privilege.view.sql

SELECT 'vw_u49_poa_trading_privilege' AS view_name FROM DUAL;

@@dfn_ntp.vw_u49_poa_trading_privilege.view.sql

SELECT 'vw_u49_poa_privilege_status' AS view_name FROM DUAL;

@@dfn_ntp.vw_u49_poa_privilege_status.view.sql

SELECT 'vw_u48_corp_contact_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_u48_corp_contact_list.view.sql

SELECT 'vw_u47_poa_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_u47_poa_list.view.sql

SELECT 'vw_u45_uploaded_doc_pages' AS view_name FROM DUAL;

@@dfn_ntp.vw_u45_uploaded_doc_pages.view.sql

SELECT 'vw_u44_uploaded_documents' AS view_name FROM DUAL;

@@dfn_ntp.vw_u44_uploaded_documents.view.sql

SELECT 'vw_u28_employee_exchanges' AS view_name FROM DUAL;

@@dfn_ntp.vw_u28_employee_exchanges.view.sql

SELECT 'vw_u24_unsettled_holdings' AS view_name FROM DUAL;

@@dfn_ntp.vw_u24_unsettled_holdings.view.sql

SELECT 'vw_u24_open_opt_contracts' AS view_name FROM DUAL;

@@dfn_ntp.vw_u24_open_opt_contracts.view.sql

SELECT 'vw_u24_holdings_urgl' AS view_name FROM DUAL;

@@dfn_ntp.vw_u24_holdings_urgl.view.sql

SELECT 'vw_u24_holdings_master' AS view_name FROM DUAL;

@@dfn_ntp.vw_u24_holdings_master.view.sql

SELECT 'vw_u24_holdings_for_symbol' AS view_name FROM DUAL;

@@dfn_ntp.vw_u24_holdings_for_symbol.view.sql

SELECT 'vw_u24_holdings_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_u24_holdings_all.view.sql

SELECT 'vw_u14_trd_symbol_restriction' AS view_name FROM DUAL;

@@dfn_ntp.vw_u14_trd_symbol_restriction.view.sql

SELECT 'vw_u09_acc_locked_customer' AS view_name FROM DUAL;

@@dfn_ntp.vw_u09_acc_locked_customer.view.sql

SELECT 'vw_u07_portfolio_value' AS view_name FROM DUAL;

@@dfn_ntp.vw_u07_portfolio_value.view.sql

SELECT 'vw_u06_dormant_cash_acc' AS view_name FROM DUAL;

@@dfn_ntp.vw_u06_dormant_cash_acc.view.sql

SELECT 'vw_u06_cash_account_base' AS view_name FROM DUAL;

@@dfn_ntp.vw_u06_cash_account_base.view.sql

SELECT 'vw_u05_customer_acc_frozen' AS view_name FROM DUAL;

@@dfn_ntp.vw_u05_customer_acc_frozen.view.sql

SELECT 'vw_u03_customer_kyc' AS view_name FROM DUAL;

@@dfn_ntp.vw_u03_customer_kyc.view.sql

SELECT 'vw_u01_customer_search' AS view_name FROM DUAL;

@@dfn_ntp.vw_u01_customer_search.view.sql

SELECT 'vw_trading_restriction' AS view_name FROM DUAL;

@@dfn_ntp.vw_trading_restriction.view.sql

SELECT 'vw_trading_group' AS view_name FROM DUAL;

@@dfn_ntp.vw_trading_group.view.sql

SELECT 'vw_trading_acc_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_trading_acc_list.view.sql

SELECT 'vw_titles' AS view_name FROM DUAL;

@@dfn_ntp.vw_titles.view.sql

SELECT 'vw_t52_desk_order_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_t52_desk_order_list.view.sql

SELECT 'vw_t29_gl_column_wise_entries' AS view_name FROM DUAL;

@@dfn_ntp.vw_t29_gl_column_wise_entries.view.sql

SELECT 'vw_t28_gl_record_wise_entries' AS view_name FROM DUAL;

@@dfn_ntp.vw_t28_gl_record_wise_entries.view.sql

SELECT 'vw_t27_gl_batches' AS view_name FROM DUAL;

@@dfn_ntp.vw_t27_gl_batches.view.sql

SELECT 'vw_t25_stock_transfer' AS view_name FROM DUAL;

@@dfn_ntp.vw_t25_stock_transfer.view.sql

SELECT 'vw_t24_customer_margin_request' AS view_name FROM DUAL;

@@dfn_ntp.vw_t24_customer_margin_request.view.sql

SELECT 'vw_t23_share_txn_requests' AS view_name FROM DUAL;

@@dfn_ntp.vw_t23_share_txn_requests.view.sql

SELECT 'vw_t22_order_audit_trail' AS view_name FROM DUAL;

@@dfn_ntp.vw_t22_order_audit_trail.view.sql

SELECT 'vw_t20_pledge_all_report' AS view_name FROM DUAL;

@@dfn_ntp.vw_t20_pledge_all_report.view.sql

SELECT 'vw_t18_u_message' AS view_name FROM DUAL;

@@dfn_ntp.vw_t18_u_message.view.sql

SELECT 'vw_t15_account_closure_req' AS view_name FROM DUAL;

@@dfn_ntp.vw_t15_account_closure_req.view.sql

SELECT 'vw_t08_od_withdr_limit_rqsts' AS view_name FROM DUAL;

@@dfn_ntp.vw_t08_od_withdr_limit_rqsts.view.sql

SELECT 'vw_t06_pending_cash_trnsctins' AS view_name FROM DUAL;

@@dfn_ntp.vw_t06_pending_cash_trnsctins.view.sql

SELECT 'vw_t06_cash_transactions' AS view_name FROM DUAL;

@@dfn_ntp.vw_t06_cash_transactions.view.sql

SELECT 'vw_t04_disable_ex_acc_req' AS view_name FROM DUAL;

@@dfn_ntp.vw_t04_disable_ex_acc_req.view.sql

SELECT 'vw_t02_unsettled_cash' AS view_name FROM DUAL;

@@dfn_ntp.vw_t02_unsettled_cash.view.sql

SELECT 'vw_t02_holdings_rgl' AS view_name FROM DUAL;

@@dfn_ntp.vw_t02_holdings_rgl.view.sql

SELECT 'vw_t02_holdings_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_t02_holdings_log.view.sql

SELECT 'vw_t02_execution_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_t02_execution_log.view.sql

SELECT 'vw_t02_daily_trade_sum_symbol' AS view_name FROM DUAL;

@@dfn_ntp.vw_t02_daily_trade_sum_symbol.view.sql

SELECT 'vw_t02_cash_txn_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_t02_cash_txn_log.view.sql

SELECT 'vw_t01_unsettled_trades' AS view_name FROM DUAL;

@@dfn_ntp.vw_t01_unsettled_trades.view.sql

SELECT 'vw_t01_order_summary_daily' AS view_name FROM DUAL;

@@dfn_ntp.vw_t01_order_summary_daily.view.sql

SELECT 'vw_system_configurations' AS view_name FROM DUAL;

@@dfn_ntp.vw_system_configurations.view.sql

SELECT 'vw_symbol_prices' AS view_name FROM DUAL;

@@dfn_ntp.vw_symbol_prices.view.sql

SELECT 'vw_symbol_marginability_groups' AS view_name FROM DUAL;

@@dfn_ntp.vw_symbol_marginability_groups.view.sql

SELECT 'vw_stock_conc_symbol_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_stock_conc_symbol_details.view.sql

SELECT 'vw_stock_concentration_group' AS view_name FROM DUAL;

@@dfn_ntp.vw_stock_concentration_group.view.sql

SELECT 'vw_status_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_status_list.view.sql

SELECT 'vw_sharia_symbol_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_sharia_symbol_list.view.sql

SELECT 'vw_sharia_compliant_group_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_sharia_compliant_group_list.view.sql

SELECT 'vw_settlement_calendar' AS view_name FROM DUAL;

@@dfn_ntp.vw_settlement_calendar.view.sql

SELECT 'vw_sector_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_sector_list.view.sql

SELECT 'vw_routing_data' AS view_name FROM DUAL;

@@dfn_ntp.vw_routing_data.view.sql

SELECT 'vw_relationship_manager' AS view_name FROM DUAL;

@@dfn_ntp.vw_relationship_manager.view.sql

SELECT 'vw_permission_grp_users_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_permission_grp_users_list.view.sql

SELECT 'vw_permission_grp_entlmnt_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_permission_grp_entlmnt_list.view.sql

SELECT 'vw_permission_groups_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_permission_groups_list.view.sql

SELECT 'vw_permission_groups' AS view_name FROM DUAL;

@@dfn_ntp.vw_permission_groups.view.sql

SELECT 'vw_pending_pledge' AS view_name FROM DUAL;

@@dfn_ntp.vw_pending_pledge.view.sql

SELECT 'vw_password_complexity_levels' AS view_name FROM DUAL;

@@dfn_ntp.vw_password_complexity_levels.view.sql

SELECT 'vw_customer_contact_info' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_contact_info.view.sql

SELECT 'vw_order_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_order_list.view.sql

SELECT 'vw_notification_group_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_notification_group_list.view.sql

SELECT 'vw_notification_configuration' AS view_name FROM DUAL;

@@dfn_ntp.vw_notification_configuration.view.sql

SELECT 'vw_minor_accounts_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_minor_accounts_list.view.sql

SELECT 'vw_master_customer_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_master_customer_list.view.sql

SELECT 'vw_market_code' AS view_name FROM DUAL;

@@dfn_ntp.vw_market_code.view.sql

SELECT 'vw_markets' AS view_name FROM DUAL;

@@dfn_ntp.vw_markets.view.sql

SELECT 'vw_margin_products' AS view_name FROM DUAL;

@@dfn_ntp.vw_margin_products.view.sql

SELECT 'vw_margin_interest_group' AS view_name FROM DUAL;

@@dfn_ntp.vw_margin_interest_group.view.sql

SELECT 'vw_m97_holding_txn_codes_base' AS view_name FROM DUAL;

@@dfn_ntp.vw_m97_holding_txn_codes_base.view.sql

SELECT 'vw_m97_charges_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_m97_charges_all.view.sql

SELECT 'vw_m97_cash_txn_codes_base' AS view_name FROM DUAL;

@@dfn_ntp.vw_m97_cash_txn_codes_base.view.sql

SELECT 'vw_m93_bank_accounts' AS view_name FROM DUAL;

@@dfn_ntp.vw_m93_bank_accounts.view.sql

SELECT 'vw_m87_exec_broker_exchange' AS view_name FROM DUAL;

@@dfn_ntp.vw_m87_exec_broker_exchange.view.sql

SELECT 'vw_m79_pending_symbl_mrg_rqst' AS view_name FROM DUAL;

@@dfn_ntp.vw_m79_pending_symbl_mrg_rqst.view.sql

SELECT 'vw_m78_symbol_marginability' AS view_name FROM DUAL;

@@dfn_ntp.vw_m78_symbol_marginability.view.sql

SELECT 'vw_m71_institute_restrictions' AS view_name FROM DUAL;

@@dfn_ntp.vw_m71_institute_restrictions.view.sql

SELECT 'vw_m70_custody_exchanges' AS view_name FROM DUAL;

@@dfn_ntp.vw_m70_custody_exchanges.view.sql

SELECT 'vw_m69_inst_trading_limits' AS view_name FROM DUAL;

@@dfn_ntp.vw_m69_inst_trading_limits.view.sql

SELECT 'vw_m67_fix_logins' AS view_name FROM DUAL;

@@dfn_ntp.vw_m67_fix_logins.view.sql

SELECT 'vw_m65_saibor_basis_rates' AS view_name FROM DUAL;

@@dfn_ntp.vw_m65_saibor_basis_rates.view.sql

SELECT 'vw_m62_institute_documents' AS view_name FROM DUAL;

@@dfn_ntp.vw_m62_institute_documents.view.sql

SELECT 'vw_m61_uploadable_documents' AS view_name FROM DUAL;

@@dfn_ntp.vw_m61_uploadable_documents.view.sql

SELECT 'vw_m60_institute_banks' AS view_name FROM DUAL;

@@dfn_ntp.vw_m60_institute_banks.view.sql

SELECT 'vw_m59_exchange_market_status' AS view_name FROM DUAL;

@@dfn_ntp.vw_m59_exchange_market_status.view.sql

SELECT 'vw_m57_exchange_order_types' AS view_name FROM DUAL;

@@dfn_ntp.vw_m57_exchange_order_types.view.sql

SELECT 'vw_m43_institute_exchanges' AS view_name FROM DUAL;

@@dfn_ntp.vw_m43_institute_exchanges.view.sql

SELECT 'vw_m33_nationality_category' AS view_name FROM DUAL;

@@dfn_ntp.vw_m33_nationality_category.view.sql

SELECT 'vw_m32_ex_market_status_tif' AS view_name FROM DUAL;

@@dfn_ntp.vw_m32_ex_market_status_tif.view.sql

SELECT 'vw_m31_exec_broker_routing' AS view_name FROM DUAL;

@@dfn_ntp.vw_m31_exec_broker_routing.view.sql

SELECT 'vw_m30_ex_market_permissions' AS view_name FROM DUAL;

@@dfn_ntp.vw_m30_ex_market_permissions.view.sql

SELECT 'vw_m28_customer_grade_data' AS view_name FROM DUAL;

@@dfn_ntp.vw_m28_customer_grade_data.view.sql

SELECT 'vw_m27_ib_comm_structures' AS view_name FROM DUAL;

@@dfn_ntp.vw_m27_ib_comm_structures.view.sql

SELECT 'vw_m26_exec_broker_custody_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_m26_exec_broker_custody_all.view.sql

SELECT 'vw_m26_exec_broker' AS view_name FROM DUAL;

@@dfn_ntp.vw_m26_exec_broker.view.sql

SELECT 'vw_m26_custody' AS view_name FROM DUAL;

@@dfn_ntp.vw_m26_custody.view.sql

SELECT 'vw_m21_introducing_broker' AS view_name FROM DUAL;

@@dfn_ntp.vw_m21_introducing_broker.view.sql

SELECT 'vw_m20_symbol_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_m20_symbol_all.view.sql

SELECT 'vw_m18_instrument' AS view_name FROM DUAL;

@@dfn_ntp.vw_m18_instrument.view.sql

SELECT 'vw_m17_bank_branches' AS view_name FROM DUAL;

@@dfn_ntp.vw_m17_bank_branches.view.sql

SELECT 'vw_m16_bank_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_m16_bank_list.view.sql

SELECT 'vw_m142_corp_hold_adjustment' AS view_name FROM DUAL;

@@dfn_ntp.vw_m142_corp_hold_adjustment.view.sql

SELECT 'vw_m141_cust_corporate_action' AS view_name FROM DUAL;

@@dfn_ntp.vw_m141_cust_corporate_action.view.sql

SELECT 'vw_m140_corp_action_templates' AS view_name FROM DUAL;

@@dfn_ntp.vw_m140_corp_action_templates.view.sql

SELECT 'vw_m139_gl_column_destribution' AS view_name FROM DUAL;

@@dfn_ntp.vw_m139_gl_column_destribution.view.sql

SELECT 'vw_m138_gl_record_destribution' AS view_name FROM DUAL;

@@dfn_ntp.vw_m138_gl_record_destribution.view.sql

SELECT 'vw_m137_gl_event_data_sources' AS view_name FROM DUAL;

@@dfn_ntp.vw_m137_gl_event_data_sources.view.sql

SELECT 'vw_m136_gl_event_categories' AS view_name FROM DUAL;

@@dfn_ntp.vw_m136_gl_event_categories.view.sql

SELECT 'vw_m135_gl_accounts' AS view_name FROM DUAL;

@@dfn_ntp.vw_m135_gl_accounts.view.sql

SELECT 'vw_m134_gl_account_categories' AS view_name FROM DUAL;

@@dfn_ntp.vw_m134_gl_account_categories.view.sql

SELECT 'vw_m133_gl_account_types' AS view_name FROM DUAL;

@@dfn_ntp.vw_m133_gl_account_types.view.sql

SELECT 'vw_m128_marital_status' AS view_name FROM DUAL;

@@dfn_ntp.vw_m128_marital_status.view.sql

SELECT 'vw_m122_exchange_tick_sizes' AS view_name FROM DUAL;

@@dfn_ntp.vw_m122_exchange_tick_sizes.view.sql

SELECT 'vw_m119_sharia_compliant_sym' AS view_name FROM DUAL;

@@dfn_ntp.vw_m119_sharia_compliant_sym.view.sql

SELECT 'vw_m118_charge_fee_structure' AS view_name FROM DUAL;

@@dfn_ntp.vw_m118_charge_fee_structure.view.sql

SELECT 'vw_m117_charge_groups' AS view_name FROM DUAL;

@@dfn_ntp.vw_m117_charge_groups.view.sql

SELECT 'vw_m116_hijri_adjustments_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_m116_hijri_adjustments_list.view.sql

SELECT 'vw_m110_reasons' AS view_name FROM DUAL;

@@dfn_ntp.vw_m110_reasons.view.sql

SELECT 'vw_m105_other_brokerages' AS view_name FROM DUAL;

@@dfn_ntp.vw_m105_other_brokerages.view.sql

SELECT 'vw_m105_exchange_brokers' AS view_name FROM DUAL;

@@dfn_ntp.vw_m105_exchange_brokers.view.sql

SELECT 'vw_m09_companies' AS view_name FROM DUAL;

@@dfn_ntp.vw_m09_companies.view.sql

SELECT 'vw_m07_locations_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_m07_locations_all.view.sql

SELECT 'vw_m02_institute_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_m02_institute_list.view.sql

SELECT 'vw_login_trading_restriction' AS view_name FROM DUAL;

@@dfn_ntp.vw_login_trading_restriction.view.sql

SELECT 'vw_login_trading_acc_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_login_trading_acc_list.view.sql

SELECT 'vw_login_cash_restriction' AS view_name FROM DUAL;

@@dfn_ntp.vw_login_cash_restriction.view.sql

SELECT 'vw_login_cash_acc_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_login_cash_acc_list.view.sql

SELECT 'vw_location_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_location_list.view.sql

SELECT 'vw_i_user_login' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_user_login.view.sql

SELECT 'vw_i_transaction_history' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_transaction_history.view.sql

SELECT 'vw_i_trading_account_header' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_trading_account_header.view.sql

SELECT 'vw_i_tradingacc_for_dealer' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_tradingacc_for_dealer.view.sql

SELECT 'vw_i_holding_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_holding_details.view.sql

SELECT 'vw_i_employee_login' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_employee_login.view.sql

SELECT 'vw_i_customer_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_customer_list.view.sql

SELECT 'vw_i_cash_account_header' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_cash_account_header.view.sql

SELECT 'vw_i_beneficiary_accounts' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_beneficiary_accounts.view.sql

SELECT 'vw_issue_locations' AS view_name FROM DUAL;

@@dfn_ntp.vw_issue_locations.view.sql

SELECT 'vw_institute_order_channels' AS view_name FROM DUAL;

@@dfn_ntp.vw_institute_order_channels.view.sql

SELECT 'vw_id_expired_customer_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_id_expired_customer_list.view.sql

SELECT 'vw_identity_type' AS view_name FROM DUAL;

@@dfn_ntp.vw_identity_type.view.sql

SELECT 'vw_holidays' AS view_name FROM DUAL;

@@dfn_ntp.vw_holidays.view.sql

SELECT 'vw_h05_inst_trading_limits' AS view_name FROM DUAL;

@@dfn_ntp.vw_h05_inst_trading_limits.view.sql

SELECT 'vw_h02_cust_cash_balances' AS view_name FROM DUAL;

@@dfn_ntp.vw_h02_cust_cash_balances.view.sql

SELECT 'vw_h02_cash_account_summary' AS view_name FROM DUAL;

@@dfn_ntp.vw_h02_cash_account_summary.view.sql

SELECT 'vw_h01_holding_summary' AS view_name FROM DUAL;

@@dfn_ntp.vw_h01_holding_summary.view.sql

SELECT 'vw_gl_cash_transactions' AS view_name FROM DUAL;

@@dfn_ntp.vw_gl_cash_transactions.view.sql

SELECT 'vw_exec_broker_commission' AS view_name FROM DUAL;

@@dfn_ntp.vw_exec_broker_commission.view.sql

SELECT 'vw_exec_broker_cash_account' AS view_name FROM DUAL;

@@dfn_ntp.vw_exec_broker_cash_account.view.sql

SELECT 'vw_exchange_order_types' AS view_name FROM DUAL;

@@dfn_ntp.vw_exchange_order_types.view.sql

SELECT 'vw_exchange_instrument_type' AS view_name FROM DUAL;

@@dfn_ntp.vw_exchange_instrument_type.view.sql

SELECT 'vw_exchanges' AS view_name FROM DUAL;

@@dfn_ntp.vw_exchanges.view.sql

SELECT 'vw_esp_market_price_today' AS view_name FROM DUAL;

@@dfn_ntp.vw_esp_market_price_today.view.sql

SELECT 'vw_esp_market_price_history' AS view_name FROM DUAL;

@@dfn_ntp.vw_esp_market_price_history.view.sql

SELECT 'vw_entitlement_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_entitlement_list.view.sql

SELECT 'vw_emp_notification_grp_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_emp_notification_grp_list.view.sql

SELECT 'vw_employee_trding_limits' AS view_name FROM DUAL;

@@dfn_ntp.vw_employee_trding_limits.view.sql

SELECT 'vw_employee_trading_groups' AS view_name FROM DUAL;

@@dfn_ntp.vw_employee_trading_groups.view.sql

SELECT 'vw_employee_list_country' AS view_name FROM DUAL;

@@dfn_ntp.vw_employee_list_country.view.sql

SELECT 'vw_employee_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_employee_list.view.sql

SELECT 'vw_e03_weekly_reconciliation' AS view_name FROM DUAL;

@@dfn_ntp.vw_e03_weekly_reconciliation.view.sql

SELECT 'vw_e01_corporate_actions' AS view_name FROM DUAL;

@@dfn_ntp.vw_e01_corporate_actions.view.sql

SELECT 'vw_departments' AS view_name FROM DUAL;

@@dfn_ntp.vw_departments.view.sql

SELECT 'vw_dc_invalid_cash_and_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_invalid_cash_and_log.view.sql

SELECT 'vw_dc_id_types' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_id_types.view.sql

SELECT 'vw_dc_icm_custodin_wise_stlmnt' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_icm_custodin_wise_stlmnt.view.sql

SELECT 'vw_customer_sms_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_sms_all.view.sql

SELECT 'vw_customer_sms' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_sms.view.sql

SELECT 'vw_customer_settl_group' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_settl_group.view.sql

SELECT 'vw_customer_restrictions' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_restrictions.view.sql

SELECT 'vw_customer_login' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_login.view.sql

SELECT 'vw_customer_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_list.view.sql

SELECT 'vw_customer_identification' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_identification.view.sql

SELECT 'vw_custodian_trade_rejection' AS view_name FROM DUAL;

@@dfn_ntp.vw_custodian_trade_rejection.view.sql

SELECT 'vw_currency_rates' AS view_name FROM DUAL;

@@dfn_ntp.vw_currency_rates.view.sql

SELECT 'vw_currencies' AS view_name FROM DUAL;

@@dfn_ntp.vw_currencies.view.sql

SELECT 'vw_country_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_country_list.view.sql

SELECT 'vw_company_positions' AS view_name FROM DUAL;

@@dfn_ntp.vw_company_positions.view.sql

SELECT 'vw_comm_discount_groups' AS view_name FROM DUAL;

@@dfn_ntp.vw_comm_discount_groups.view.sql

SELECT 'vw_commission_structures' AS view_name FROM DUAL;

@@dfn_ntp.vw_commission_structures.view.sql

SELECT 'vw_commission_groups' AS view_name FROM DUAL;

@@dfn_ntp.vw_commission_groups.view.sql

SELECT 'vw_commission_discount_rate' AS view_name FROM DUAL;

@@dfn_ntp.vw_commission_discount_rate.view.sql

SELECT 'vw_commission_discount_expiry' AS view_name FROM DUAL;

@@dfn_ntp.vw_commission_discount_expiry.view.sql

SELECT 'vw_city_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_city_list.view.sql

SELECT 'vw_cash_restriction' AS view_name FROM DUAL;

@@dfn_ntp.vw_cash_restriction.view.sql

SELECT 'vw_cash_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_cash_details.view.sql

SELECT 'vw_cash_block_request_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_cash_block_request_list.view.sql

SELECT 'vw_cash_acc_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_cash_acc_list.view.sql

SELECT 'vw_cash_account_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_cash_account_list.view.sql

SELECT 'vw_block_amount_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_block_amount_details.view.sql

SELECT 'vw_beneficiary_accounts' AS view_name FROM DUAL;

@@dfn_ntp.vw_beneficiary_accounts.view.sql

SELECT 'vw_audit_category' AS view_name FROM DUAL;

@@dfn_ntp.vw_audit_category.view.sql

SELECT 'vw_audit_activity' AS view_name FROM DUAL;

@@dfn_ntp.vw_audit_activity.view.sql

SELECT 'vw_audit' AS view_name FROM DUAL;

@@dfn_ntp.vw_audit.view.sql

SELECT 'vw_assigned_inst_entlmnt_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_assigned_inst_entlmnt_list.view.sql

SELECT 'vw_announcements' AS view_name FROM DUAL;

@@dfn_ntp.vw_announcements.view.sql

SELECT 'vw_acc_locked_users' AS view_name FROM DUAL;

@@dfn_ntp.vw_acc_locked_users.view.sql

SELECT 'vw_accrued_interest_adjst_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_accrued_interest_adjst_list.view.sql

SELECT 'vw_access_level' AS view_name FROM DUAL;

@@dfn_ntp.vw_access_level.view.sql

SELECT 'vw_a18_failed_user_logins' AS view_name FROM DUAL;

@@dfn_ntp.vw_a18_failed_user_logins.view.sql

SELECT 'vw_a10_entity_status_history' AS view_name FROM DUAL;

@@dfn_ntp.vw_a10_entity_status_history.view.sql

SELECT 'vw_a09_function_approval_audit' AS view_name FROM DUAL;

@@dfn_ntp.vw_a09_function_approval_audit.view.sql

SELECT 'vw_a09_cash_transaction_audit' AS view_name FROM DUAL;

@@dfn_ntp.vw_a09_cash_transaction_audit.view.sql

SELECT 'vw_a09_account_closure_audit' AS view_name FROM DUAL;

@@dfn_ntp.vw_a09_account_closure_audit.view.sql

SELECT 'vw_a08_aprl_column_audit_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_a08_aprl_column_audit_log.view.sql

SELECT 'vw_a07_approval_column_audit' AS view_name FROM DUAL;

@@dfn_ntp.vw_a07_approval_column_audit.view.sql

SELECT 'vw_a04_aprl_audit_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_a04_aprl_audit_log.view.sql

SELECT 'vw_a03_approval_audit' AS view_name FROM DUAL;

@@dfn_ntp.vw_a03_approval_audit.view.sql

SELECT 'vw_a01_db_jobs_execution_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_a01_db_jobs_execution_log.view.sql

SELECT 'u46_user_sessions_all' AS view_name FROM DUAL;

@@dfn_ntp.u46_user_sessions_all.view.sql

SELECT 'trading_account_list' AS view_name FROM DUAL;

@@dfn_ntp.trading_account_list.view.sql

SELECT 't12_pending_stock_requests' AS view_name FROM DUAL;

@@dfn_ntp.t12_pending_stock_requests.view.sql

SELECT 't02_transaction_log_order' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_order.view.sql

SELECT 't02_transaction_log_holding' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_holding.view.sql

SELECT 't02_transaction_log_cash' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_cash.view.sql

SELECT 'smv_daily_trade_transaction' AS view_name FROM DUAL;

@@dfn_ntp.smv_daily_trade_transaction.view.sql

SELECT 'relationship_manager_list' AS view_name FROM DUAL;

@@dfn_ntp.relationship_manager_list.view.sql

SELECT 'recently_not_logged_in_users' AS view_name FROM DUAL;

@@dfn_ntp.recently_not_logged_in_users.view.sql

SELECT 'h07_user_sessions_history_emp' AS view_name FROM DUAL;

@@dfn_ntp.h07_user_sessions_history_emp.view.sql

SELECT 'beneficiary_account_list' AS view_name FROM DUAL;

@@dfn_ntp.beneficiary_account_list.view.sql

SELECT 'vw_m143_corp_cash_adjustment' AS view_name FROM DUAL;

@@dfn_ntp.vw_m143_corp_cash_adjustment.view.sql

SELECT 'vw_cust_margin_cash_acc_de' AS view_name FROM DUAL;

@@dfn_ntp.vw_cust_margin_cash_acc_de.view.sql

SELECT 'vw_gl_order_executions' AS view_name FROM DUAL;

@@dfn_ntp.vw_gl_order_executions.view.sql

SELECT 'vw_t17_trade_process_requests' AS view_name FROM DUAL;

@@dfn_ntp.vw_t17_trade_process_requests.view.sql

SELECT 'vw_trade_processing_order_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_trade_processing_order_list.view.sql

SELECT 'vw_notification_category_tags' AS view_name FROM DUAL;

@@dfn_ntp.vw_notification_category_tags.view.sql

SELECT 'vw_notification_tags' AS view_name FROM DUAL;

@@dfn_ntp.vw_notification_tags.view.sql

SELECT 'vw_dc_margin_customers' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_margin_customers.view.sql

SELECT 't02_transaction_log_cash_all' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_cash_all.view.sql

SELECT 't02_transaction_log_hold_all' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_hold_all.view.sql

SELECT 't02_transaction_log_order_all' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_order_all.view.sql

SELECT 'vw_t02_cash_txn_log_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_t02_cash_txn_log_all.view.sql

SELECT 'vw_customer_margin_call_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_margin_call_log.view.sql

SELECT 'vw_dc_invalid_cash_block' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_invalid_cash_block.view.sql

SELECT 'vw_dc_invalid_holdings_and_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_invalid_holdings_and_log.view.sql

SELECT 'vw_u06_cash_balance_rpt' AS view_name FROM DUAL;

@@dfn_ntp.vw_u06_cash_balance_rpt.view.sql

SELECT 'vw_t44_pending_ca_adjst_rqsts' AS view_name FROM DUAL;

@@dfn_ntp.vw_t44_pending_ca_adjst_rqsts.view.sql

SELECT 'vw_t43_cust_corp_act_cash_pen' AS view_name FROM DUAL;

@@dfn_ntp.vw_t43_cust_corp_act_cash_pen.view.sql

SELECT 'vw_t43_cust_corp_act_cash' AS view_name FROM DUAL;

@@dfn_ntp.vw_t43_cust_corp_act_cash.view.sql

SELECT 'vw_t42_cust_corp_act_hold_pen' AS view_name FROM DUAL;

@@dfn_ntp.vw_t42_cust_corp_act_hold_pen.view.sql

SELECT 'vw_t42_cust_corp_act_hold' AS view_name FROM DUAL;

@@dfn_ntp.vw_t42_cust_corp_act_hold.view.sql

SELECT 'vw_t41_ca_cust_distribution' AS view_name FROM DUAL;

@@dfn_ntp.vw_t41_ca_cust_distribution.view.sql

SELECT 'vw_forms_cols' AS view_name FROM DUAL;

@@dfn_ntp.vw_forms_cols.view.sql

SELECT 'vw_customer_margin_product' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_margin_product.view.sql

SELECT 'vw_t01_right_subscription_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_t01_right_subscription_list.view.sql

SELECT 'vw_bulk_pledges' AS view_name FROM DUAL;

@@dfn_ntp.vw_bulk_pledges.view.sql

SELECT 'vw_t01_order_list_base' AS view_name FROM DUAL;

@@dfn_ntp.vw_t01_order_list_base.view.sql

SELECT 'vw_m131_mkt_maker_groups' AS view_name FROM DUAL;

@@dfn_ntp.vw_m131_mkt_maker_groups.view.sql

SELECT 'vw_m132_mkt_maker_grp_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_m132_mkt_maker_grp_details.view.sql

SELECT 'vw_u13_ext_custody_portfolios' AS view_name FROM DUAL;

@@dfn_ntp.vw_u13_ext_custody_portfolios.view.sql

SELECT 'vw_order_list_bp_exceeded' AS view_name FROM DUAL;

@@dfn_ntp.vw_order_list_bp_exceeded.view.sql

SELECT 'vw_customer_holding_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_holding_list.view.sql

SELECT 'vw_custodian_holding_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_custodian_holding_list.view.sql

SELECT 'h07_user_sessions_history_cust' AS view_name FROM DUAL;

@@dfn_ntp.h07_user_sessions_history_cust.view.sql

SELECT 'vw_a18_failed_customer_logins' AS view_name FROM DUAL;

@@dfn_ntp.vw_a18_failed_customer_logins.view.sql

SELECT 'vw_a18_inactive_users' AS view_name FROM DUAL;

@@dfn_ntp.vw_a18_inactive_users.view.sql

SELECT 'vw_recently_not_logged_in_cust' AS view_name FROM DUAL;

@@dfn_ntp.vw_recently_not_logged_in_cust.view.sql

SELECT 'vw_z02_forms_cols_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_z02_forms_cols_all.view.sql

SELECT 'vw_z03_forms_menu_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_z03_forms_menu_all.view.sql

SELECT 'vw_z04_forms_color_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_z04_forms_color_all.view.sql

SELECT 'vw_t02_order_include_icm' AS view_name FROM DUAL;

@@dfn_ntp.vw_t02_order_include_icm.view.sql

SELECT 'vw_t54_algo_order_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_t54_algo_order_list.view.sql

SELECT 'vw_cash_restriction_summary' AS view_name FROM DUAL;

@@dfn_ntp.vw_cash_restriction_summary.view.sql

SELECT 'vw_transfer_restriction' AS view_name FROM DUAL;

@@dfn_ntp.vw_transfer_restriction.view.sql

SELECT 'vw_m150_brokerage_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_m150_brokerage_list.view.sql

SELECT 'vw_t32_weekly_reconciliation' AS view_name FROM DUAL;

@@dfn_ntp.vw_t32_weekly_reconciliation.view.sql

SELECT 'vw_cust_exchange_subscription' AS view_name FROM DUAL;

@@dfn_ntp.vw_cust_exchange_subscription.view.sql

SELECT 'vw_cust_broker_subscription' AS view_name FROM DUAL;

@@dfn_ntp.vw_cust_broker_subscription.view.sql

SELECT 'vw_m152_products_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_m152_products_list.view.sql

SELECT 'vw_m153_exchange_products_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_m153_exchange_products_list.view.sql

SELECT 'vw_m154_subscriptn_waveof_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_m154_subscriptn_waveof_list.view.sql

SELECT 'vw_m155_product_waveof_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_m155_product_waveof_details.view.sql

SELECT 'vw_m156_exchange_waveof_detail' AS view_name FROM DUAL;

@@dfn_ntp.vw_m156_exchange_waveof_detail.view.sql

SELECT 'vw_t33_corporate_actions' AS view_name FROM DUAL;

@@dfn_ntp.vw_t33_corporate_actions.view.sql

SELECT 'vw_m151_trade_config_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_m151_trade_config_list.view.sql

SELECT 'vw_m95_settlement_calendar_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_m95_settlement_calendar_all.view.sql

SELECT 'vw_institution_txn_codes' AS view_name FROM DUAL;

@@dfn_ntp.vw_institution_txn_codes.view.sql

SELECT 'vw_order_status_requests' AS view_name FROM DUAL;

@@dfn_ntp.vw_order_status_requests.view.sql

SELECT 'vw_t12_bulk_security_transfers' AS view_name FROM DUAL;

@@dfn_ntp.vw_t12_bulk_security_transfers.view.sql

SELECT 'vw_t61_bulk_share_transactions' AS view_name FROM DUAL;

@@dfn_ntp.vw_t61_bulk_share_transactions.view.sql

SELECT 'vw_symbol_price_upload_summary' AS view_name FROM DUAL;

@@dfn_ntp.vw_symbol_price_upload_summary.view.sql

SELECT 'vw_symbol_price_upload_detail' AS view_name FROM DUAL;

@@dfn_ntp.vw_symbol_price_upload_detail.view.sql

SELECT 'vw_offline_symbol_with_holding' AS view_name FROM DUAL;

@@dfn_ntp.vw_offline_symbol_with_holding.view.sql

SELECT 'vw_db_advanced_approvals' AS view_name FROM DUAL;

@@dfn_ntp.vw_db_advanced_approvals.view.sql

SELECT 'vw_db_online_users' AS view_name FROM DUAL;

@@dfn_ntp.vw_db_online_users.view.sql

SELECT 'vw_db_function_approvals' AS view_name FROM DUAL;

@@dfn_ntp.vw_db_function_approvals.view.sql

SELECT 'vw_db_custodian_wise_orders' AS view_name FROM DUAL;

@@dfn_ntp.vw_db_custodian_wise_orders.view.sql

SELECT 'vw_db_customer_status_types' AS view_name FROM DUAL;

@@dfn_ntp.vw_db_customer_status_types.view.sql

SELECT 'vw_db_margin_customer_status' AS view_name FROM DUAL;

@@dfn_ntp.vw_db_margin_customer_status.view.sql

SELECT 'vw_db_cash_account_status' AS view_name FROM DUAL;

@@dfn_ntp.vw_db_cash_account_status.view.sql

SELECT 'vw_get_from_price_pool' AS view_name FROM DUAL;

@@dfn_ntp.vw_get_from_price_pool.view.sql

SELECT 'vw_uploaded_price_user_pool' AS view_name FROM DUAL;

@@dfn_ntp.vw_uploaded_price_user_pool.view.sql

SELECT 'vw_price_user_pool' AS view_name FROM DUAL;

@@dfn_ntp.vw_price_user_pool.view.sql

SELECT 'vw_u47_power_of_attorney' AS view_name FROM DUAL;

@@dfn_ntp.vw_u47_power_of_attorney.view.sql

SELECT 'vw_client_settlement' AS view_name FROM DUAL;

@@dfn_ntp.vw_client_settlement.view.sql

SELECT 'vw_trade_processing_executions' AS view_name FROM DUAL;

@@dfn_ntp.vw_trade_processing_executions.view.sql

SELECT 'vw_t66_tc_notify_request_list' AS view_name  FROM DUAL;

@@dfn_ntp.vw_t66_tc_notify_request_list.view.sql

SELECT 'vw_cust_charge_discounts' AS view_name FROM DUAL;

@@dfn_ntp.vw_cust_charge_discounts.view.sql

SELECT 'vw_stock_block_request_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_stock_block_request_list.view.sql

SELECT  'vw_m166_custody_charges_group' AS view_name FROM DUAL;

@@dfn_ntp.vw_m166_custody_charges_group.view.sql

SELECT  'vw_custody_charges_group_slab' AS view_name FROM DUAL;

@@dfn_ntp.vw_custody_charges_group_slab.view.sql

SELECT 'vw_confirm_rollback_approvals' AS view_name FROM DUAL;

@@dfn_ntp.vw_confirm_rollback_approvals.view.sql

SELECT 'vw_transaction_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_transaction_list.view.sql

SELECT 'vw_discount_charge_groups' AS view_name FROM DUAL;

@@dfn_ntp.vw_discount_charge_groups.view.sql

SELECT 'vw_custody_hldg_charge_payment' AS view_name FROM DUAL;

@@dfn_ntp.vw_custody_hldg_charge_payment.view.sql

SELECT 'vw_payment_session_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_payment_session_list.view.sql

SELECT 'vw_payment_detail_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_payment_detail_list.view.sql

SELECT 'vw_change_account_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_change_account_list.view.sql

SELECT 'vw_dealer_commission' AS view_name FROM DUAL;

@@dfn_ntp.vw_dealer_commission.view.sql

SELECT 'vw_otc_trd_instruments' AS view_name FROM DUAL;

@@dfn_ntp.vw_otc_trd_instruments.view.sql

SELECT 'vw_otc_trd_commission_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_otc_trd_commission_list.view.sql

SELECT 'vw_money_market_contract_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_money_market_contract_list.view.sql

SELECT 'vw_m171_bond_issue_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_m171_bond_issue_list.view.sql

SELECT 'vw_m172_term_structure' AS view_name FROM DUAL;

@@dfn_ntp.vw_m172_term_structure.view.sql

SELECT 'vw_bond_contract_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_bond_contract_list.view.sql

SELECT 'a03_approval_audit_all' AS view_name FROM DUAL;

@@dfn_ntp.a03_approval_audit_all.view.sql

SELECT 'a04_approval_audit_log_all' AS view_name FROM DUAL;

@@dfn_ntp.a04_approval_audit_log_all.view.sql

SELECT 'a06_audit_all' AS view_name FROM DUAL;

@@dfn_ntp.a06_audit_all.view.sql

SELECT 'a07_approval_column_audit_all' AS view_name FROM DUAL;

@@dfn_ntp.a07_approval_column_audit_all.view.sql

SELECT 'a08_approval_col_audit_log_all' AS view_name FROM DUAL;

@@dfn_ntp.a08_approval_col_audit_log_all.view.sql

SELECT 'a09_function_approval_log_all' AS view_name FROM DUAL;

@@dfn_ntp.a09_function_approval_log_all.view.sql

SELECT 'a10_entity_status_history_all' AS view_name FROM DUAL;

@@dfn_ntp.a10_entity_status_history_all.view.sql

SELECT 'a13_cash_holdng_adjust_log_all' AS view_name FROM DUAL;

@@dfn_ntp.a13_cash_holdng_adjust_log_all.view.sql

SELECT 'a18_user_login_audit_all' AS view_name FROM DUAL;

@@dfn_ntp.a18_user_login_audit_all.view.sql

SELECT 't02_transaction_log_cash_arc' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_cash_arc.view.sql

SELECT 'h01_holding_summary_all' AS view_name FROM DUAL;

@@dfn_ntp.h01_holding_summary_all.view.sql

SELECT 'h02_cash_account_summary_all' AS view_name FROM DUAL;

@@dfn_ntp.h02_cash_account_summary_all.view.sql

SELECT 'h03_currency_rate_all' AS view_name FROM DUAL;

@@dfn_ntp.h03_currency_rate_all.view.sql

SELECT 'h07_user_sessions_all' AS view_name FROM DUAL;

@@dfn_ntp.h07_user_sessions_all.view.sql

SELECT 'm36_settlement_calendar_all' AS view_name FROM DUAL;

@@dfn_ntp.m36_settlement_calendar_all.view.sql

SELECT 't01_order_all' AS view_name FROM DUAL;

@@dfn_ntp.t01_order_all.view.sql

SELECT 't02_transact_log_order_arc_all' AS view_name FROM DUAL;

@@dfn_ntp.t02_transact_log_order_arc_all.view.sql

SELECT 't02_transaction_log_all' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_all.view.sql

SELECT 't06_cash_transaction_all' AS view_name FROM DUAL;

@@dfn_ntp.t06_cash_transaction_all.view.sql

SELECT 't12_share_transaction_all' AS view_name FROM DUAL;

@@dfn_ntp.t12_share_transaction_all.view.sql

SELECT 't22_order_audit_all' AS view_name FROM DUAL;

@@dfn_ntp.t22_order_audit_all.view.sql

SELECT 't59_product_subscripti_log_all' AS view_name FROM DUAL;

@@dfn_ntp.t59_product_subscripti_log_all.view.sql

SELECT 't60_exchange_subscript_log_all' AS view_name FROM DUAL;

@@dfn_ntp.t60_exchange_subscript_log_all.view.sql

SELECT 't02_transaction_log_order_arc' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_order_arc.view.sql

SELECT 'vw_m176_order_limit_group' AS view_name FROM DUAL;

@@dfn_ntp.vw_m176_order_limit_group.view.sql

SELECT 'dfn_ntp.vw_cash_transfer_limit_group' AS view_name FROM DUAL;

@@dfn_ntp.vw_cash_transfer_limit_group.view.sql

SELECT 'vw_mutual_fund_symbols' AS view_name FROM DUAL;

@@dfn_ntp.vw_mutual_fund_symbols.view.sql

SELECT 'vw_m178_asset_management_compa' AS view_name FROM DUAL;

@@dfn_ntp.vw_m178_asset_management_compa.view.sql

SELECT 'vw_incentive_group' AS view_name FROM DUAL;

@@dfn_ntp.vw_incentive_group.view.sql

SELECT 'vw_incentive_structure' AS view_name FROM DUAL;

@@dfn_ntp.vw_incentive_structure.view.sql

SELECT 'vw_m38_arc_table_configuration' AS view_name FROM DUAL;

@@dfn_ntp.vw_m38_arc_table_configuration.view.sql

SELECT 'vw_t38_cond_order_search_view' AS view_name FROM DUAL;

@@dfn_ntp.vw_t38_cond_order_search_view.view.sql

SELECT 't02_transact_log_cash_arc_all' AS view_name FROM DUAL;

@@dfn_ntp.t02_transact_log_cash_arc_all.view.sql

SELECT 't02_transaction_automation' AS view_name FROM DUAL;

@@dfn_ntp.t02_transaction_automation.view.sql

SELECT 'vw_data_loader_template_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_data_loader_template_list.view.sql

SELECT 'vw_t47_incentive_detail_report' AS view_name FROM DUAL;

@@dfn_ntp.vw_t47_incentive_detail_report.view.sql

SELECT 'vw_price_qty_factors' AS view_name FROM DUAL;

@@dfn_ntp.vw_price_qty_factors.view.sql

SELECT 'vw_m170_institute_cash_account' AS view_name FROM DUAL;

@@dfn_ntp.vw_m170_institute_cash_account.view.sql

SELECT 'vw_symbol_list_base' AS view_name FROM DUAL;

@@dfn_ntp.vw_symbol_list_base.view.sql

SELECT 'vw_holding_for_exchange_symbol' AS view_name FROM DUAL;

@@dfn_ntp.vw_holding_for_exchange_symbol.view.sql

SELECT 'vw_gl_orders' AS view_name FROM DUAL;

@@dfn_ntp.vw_gl_orders.view.sql

SELECT 'vw_dc_rpt_margin_sum_master' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_rpt_margin_sum_master.view.sql

SELECT 'vw_u24_futures_holdings' AS view_name FROM DUAL;

@@dfn_ntp.vw_u24_futures_holdings.view.sql

SELECT 'vw_t34_post_trade_requests' AS view_name FROM DUAL;

@@dfn_ntp.vw_t34_post_trade_requests.view.sql

SELECT 'vw_t35_post_trade_sources' AS view_name FROM DUAL;

@@dfn_ntp.vw_t35_post_trade_sources.view.sql

SELECT 'vw_t36_post_trade_destination' AS view_name FROM DUAL;

@@dfn_ntp.vw_t36_post_trade_destination.view.sql

SELECT 'vw_m179_feat_channel_restrict' AS view_name FROM DUAL;

@@dfn_ntp.vw_m179_feat_channel_restrict.view.sql

SELECT 'vw_m181_murabaha_baskets' AS view_name FROM DUAL;

@@dfn_ntp.vw_m181_murabaha_baskets.view.sql

SELECT 'vw_m182_murabaha_bskt_comp' AS view_name FROM DUAL;

@@dfn_ntp.vw_m182_murabaha_bskt_comp.view.sql

SELECT 'vw_t48_tax_invoices' AS view_name FROM DUAL;

@@dfn_ntp.vw_t48_tax_invoices.view.sql

SELECT 'vw_i_user_reg_trading_account' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_user_reg_trading_account.view.sql

SELECT 'vw_i_user_reg_cash_accounts' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_user_reg_cash_accounts.view.sql

SELECT 'vw_cust_commission_discount' AS view_name FROM DUAL;

@@dfn_ntp.vw_cust_commission_discount.view.sql

SELECT 'vw_om_questionnaire' AS view_name FROM DUAL;

@@dfn_ntp.vw_om_questionnaire.view.sql

SELECT 'vw_u24_h01_holdings_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_u24_h01_holdings_all.view.sql

SELECT 'vw_dc_future_open_position' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_future_open_position.view.sql

SELECT 'vw_client_overall_exposure' AS view_name FROM DUAL;

@@dfn_ntp.vw_client_overall_exposure.view.sql

SELECT 'vw_overall_exposure' AS view_name FROM DUAL;

@@dfn_ntp.vw_overall_exposure.view.sql

SELECT 'vw_h01_holding_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_h01_holding_details.view.sql

SELECT 'vw_t73_om_margin_requests_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_t73_om_margin_requests_list.view.sql

SELECT 'vw_t74_om_mar_req_assign_stock' AS view_name FROM DUAL;

@@dfn_ntp.vw_t74_om_mar_req_assign_stock.view.sql

SELECT 'vw_t73_om_margin_reque_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_t73_om_margin_reque_details.view.sql

SELECT 'vw_u25_om_req_questionnaire' AS view_name FROM DUAL;

@@dfn_ntp.vw_u25_om_req_questionnaire.view.sql

SELECT 'vw_channel_wise_symbol_restr' AS view_name FROM DUAL;

@@dfn_ntp.vw_channel_wise_symbol_restr.view.sql

SELECT 'vw_spread_matrix_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_spread_matrix_list.view.sql

SELECT 'vw_customer_subscription_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_subscription_list.view.sql

SELECT 'vw_customer_margn_product_base' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_margn_product_base.view.sql

SELECT 'vw_stock_concentration_rpt' AS view_name FROM DUAL;

@@dfn_ntp.vw_stock_concentration_rpt.view.sql

SELECT 'vw_stock_conc_master_rpt' AS view_name FROM DUAL;

@@dfn_ntp.vw_stock_conc_master_rpt.view.sql

SELECT 'vw_customer_level_conc_rpt' AS view_name FROM DUAL;

@@dfn_ntp.vw_customer_level_conc_rpt.view.sql

SELECT 'vw_gl_daily_interest' AS view_name FROM DUAL;

@@dfn_ntp.vw_gl_daily_interest.view.sql

SELECT 'vw_margin_enabled_accounts' AS view_name FROM DUAL;

@@dfn_ntp.vw_margin_enabled_accounts.view.sql

SELECT 'vw_book_level_conc_master' AS view_name FROM DUAL;

@@dfn_ntp.vw_book_level_conc_master.view.sql

SELECT 'vw_book_level_concntration_rpt' AS view_name FROM DUAL;

@@dfn_ntp.vw_book_level_concntration_rpt.view.sql

SELECT 'vw_murabaha_agents_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_murabaha_agents_list.view.sql

SELECT 'vw_dc_margin_expired_customers' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_margin_expired_customers.view.sql

SELECT 'vw_symbol_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_symbol_list.view.sql

SELECT 'vw_t75_murabaha_contracts' AS view_name FROM DUAL;

@@dfn_ntp.vw_t75_murabaha_contracts.view.sql

SELECT 'vw_t76_murabaha_contract_comp' AS view_name FROM DUAL;

@@dfn_ntp.vw_t76_murabaha_contract_comp.view.sql

SELECT 'vw_u01_customer_list_file' AS view_name FROM DUAL;

@@dfn_ntp.vw_u01_customer_list_file.view.sql

SELECT 'vw_t21_daily_interest_accruals' AS view_name FROM DUAL;

@@dfn_ntp.vw_t21_daily_interest_accruals.view.sql

SELECT 'vw_trading_limit_utilized' AS view_name FROM DUAL;

@@dfn_ntp.vw_trading_limit_utilized.view.sql

SELECT 'vw_customers_with_od_limit' AS view_name FROM DUAL;

@@dfn_ntp.vw_customers_with_od_limit.view.sql

SELECT 'vw_dc_od_limits_details_all' AS view_name FROM DUAL;

@@dfn_ntp.vw_dc_od_limits_details_all.view.sql

SELECT 'vw_ams_accrued_interest' AS view_name FROM DUAL;

@@dfn_ntp.vw_ams_accrued_interest.view.sql

SELECT 'vw_ams_cash_transaction_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_ams_cash_transaction_list.view.sql

SELECT 'vw_ams_order_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_ams_order_list.view.sql

SELECT 'vw_ams_pledge' AS view_name FROM DUAL;

@@dfn_ntp.vw_ams_pledge.view.sql

SELECT 'vw_ams_stock_transaction' AS view_name FROM DUAL;

@@dfn_ntp.vw_ams_stock_transaction.view.sql

SELECT 'vw_ams_symbol_margin_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_ams_symbol_margin_list.view.sql

SELECT 'vw_ams_transfer_block' AS view_name FROM DUAL;

@@dfn_ntp.vw_ams_transfer_block.view.sql

SELECT 'vw_i_trading_account_header' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_trading_account_header.view.sql

SELECT 'vw_symbol_data' AS view_name FROM DUAL;

@@dfn_ntp.vw_symbol_data.view.sql

SELECT 'vw_h24_gl_cash_account_summary' AS view_name FROM DUAL;

@@dfn_ntp.vw_h24_gl_cash_account_summary.view.sql

SELECT 'vw_gl_margin_transactions' AS view_name FROM DUAL;

@@dfn_ntp.vw_gl_margin_transactions.view.sql

SELECT 'vw_i_desk_order_audit_trail' AS view_name FROM DUAL;

@@dfn_ntp.vw_i_desk_order_audit_trail.view.sql

SELECT 'vw_m40_file_procs_job_conf' AS view_name FROM DUAL;

@@dfn_ntp.vw_m40_file_procs_job_conf.view.sql

SELECT 'vw_t38_algo_order_list' AS view_name FROM DUAL;

@@dfn_ntp.vw_t38_algo_order_list.view.sql

SELECT 'vw_custody_execb_cash_account' AS view_name FROM DUAL;

@@dfn_ntp.vw_custody_execb_cash_account.view.sql

SELECT 'vw_t78_custodian_settlements' AS view_name FROM DUAL;

@@dfn_ntp.vw_t78_custodian_settlements.view.sql

SELECT 'vw_custodian_settlements_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_custodian_settlements_log.view.sql

SELECT 'vw_t83_exec_broker_settlements' AS view_name FROM DUAL;

@@dfn_ntp.vw_t83_exec_broker_settlements.view.sql

SELECT 'vw_exec_broker_settlements_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_exec_broker_settlements_log.view.sql

SELECT 'vw_b2b_cdetails' AS view_name FROM DUAL;

@@dfn_ntp.vw_b2b_cdetails.view.sql

SELECT 'vw_b2b_current_holding' AS view_name FROM DUAL;

@@dfn_ntp.vw_b2b_current_holding.view.sql

SELECT 'vw_b2b_history_holding' AS view_name FROM DUAL;

@@dfn_ntp.vw_b2b_history_holding.view.sql

SELECT 'vw_b2b_margin_portfolio' AS view_name FROM DUAL;

@@dfn_ntp.vw_b2b_margin_portfolio.view.sql

SELECT 'vw_b2b_trade_confirmation' AS view_name FROM DUAL;

@@dfn_ntp.vw_b2b_trade_confirmation.view.sql

SELECT 'vw_vat_invoice' AS view_name FROM DUAL;

@@dfn_ntp.vw_vat_invoice.view.sql

SELECT 'vw_t85_negotiated_deal' AS view_name FROM DUAL;

@@dfn_ntp.vw_t85_negotiated_deal.view.sql

SELECT 'vw_risk_cash_transactions' AS view_name FROM DUAL;

@@dfn_ntp.vw_risk_cash_transactions.view.sql

SELECT 'u06_cash_account_automation' AS view_name FROM DUAL;

@@dfn_ntp.u06_cash_account_automation.view.sql

SELECT 'm01_exchanges_automation' AS view_name FROM DUAL;

@@dfn_ntp.m01_exchanges_automation.view.sql

SELECT 'vw_boards' AS view_name FROM DUAL;

@@dfn_ntp.vw_boards.view.sql

SELECT 'vw_m30_ex_board_permissions' AS view_name FROM DUAL;

@@dfn_ntp.vw_m30_ex_board_permissions.view.sql

SELECT 'vw_m32_ex_board_status_tif' AS view_name FROM DUAL;

@@dfn_ntp.vw_m32_ex_board_status_tif.view.sql

SELECT 'vw_t60_exg_subscription_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_t60_exg_subscription_log.view.sql

SELECT 'vw_t59_product_subscripton_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_t59_product_subscripton_log.view.sql

SELECT 'vw_t80_file_processing_batches' AS view_name FROM DUAL;

@@dfn_ntp.vw_t80_file_processing_batches.view.sql

SELECT 'vw_m187_interest_indices' AS view_name FROM DUAL;

@@dfn_ntp.vw_m187_interest_indices.view.sql

SELECT 'vw_t84_customer_f' AS view_name FROM DUAL;

@@dfn_ntp.vw_t84_customer_f.view.sql

SELECT 'vw_m1001_sukuk_coupon_pay_b' AS view_name FROM DUAL;

@@dfn_ntp.vw_m1001_sukuk_coupon_pay_b.view.sql

SELECT 'vw_csm_todays_executions_dtls' AS view_name FROM DUAL;

@@dfn_ntp.vw_csm_todays_executions_dtls.view.sql

SELECT 'holding_symbols_v' AS view_name FROM DUAL;

@@dfn_ntp.holding_symbols_v.view.sql

SELECT 'vw_a09_stock_requests_audit' AS view_name FROM DUAL;

@@dfn_ntp.vw_a09_stock_requests_audit.view.sql

SELECT 'dfn_ntp.vw_ex_clearing_account' AS view_name FROM DUAL;

@@dfn_ntp.vw_ex_clearing_account.view.sql

SELECT 'dfn_ntp.vw_order_limit_group_slabs' AS view_name FROM DUAL;

@@dfn_ntp.vw_order_limit_group_slabs.view.sql

SELECT 'dfn_ntp.vw_a09_pledge_requests_audit' AS view_name FROM DUAL;

@@dfn_ntp.vw_a09_pledge_requests_audit.view.sql

SELECT 'dfn_ntp.vw_u59_trad_acc_fix_logins' AS view_name FROM DUAL;

@@dfn_ntp.vw_u59_trad_acc_fix_logins.view.sql

SELECT 'dfn_ntp.vw_t13_sms_email_notifications' AS view_name FROM DUAL;

@@dfn_ntp.vw_t13_sms_email_notifications.view.sql

SELECT 'dfn_ntp.vw_m144_subscription_products' AS view_name FROM DUAL;

@@dfn_ntp.vw_m144_subscription_products.view.sql

SELECT 'dfn_ntp.vw_file_processing_logs' AS view_name FROM DUAL;

@@dfn_ntp.vw_file_processing_logs.view.sql

SELECT 'dfn_ntp.vw_m190_exchange_comm_types' AS view_name FROM DUAL;

@@dfn_ntp.vw_m190_exchange_comm_types.view.sql

SELECT 'dfn_ntp.vw_corp_act_template_details' AS view_name FROM DUAL;

@@dfn_ntp.vw_corp_act_template_details.view.sql

SELECT 'dfn_ntp.vw_symbols_to_be_expire' AS view_name FROM DUAL;

@@dfn_ntp.vw_symbols_to_be_expire.view.sql

SELECT 'dfn_ntp.vw_a23_symbol_expire_log' AS view_name FROM DUAL;

@@dfn_ntp.vw_a23_symbol_expire_log.view.sql

SELECT 'dfn_ntp.vw_family_members' AS view_name FROM DUAL;

@@dfn_ntp.vw_family_members.view.sql

SELECT 'dfn_ntp.vw_u06_portfolio_value' AS view_name FROM DUAL;

@@dfn_ntp.vw_u06_portfolio_value.view.sql

SELECT 'vw_block_status_list_b' AS view_name FROM DUAL;

@@dfn_ntp.vw_block_status_list_b.view.sql

SELECT 'vw_t1001_sukuk_pay_det_b' AS view_name FROM DUAL;

@@dfn_ntp.vw_t1001_sukuk_pay_det_b.view.sql

SPOOL OFF