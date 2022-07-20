SPOOL log.run.dfn_ntp.tables REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 't24_customer_margin_request' AS table_name FROM DUAL;

@@dfn_ntp.t24_customer_margin_request.tab.sql

SELECT 'm130_titles' AS table_name FROM DUAL;

@@dfn_ntp.m130_titles.tab.sql

SELECT 't22_order_audit' AS table_name FROM DUAL;

@@dfn_ntp.t22_order_audit.tab.sql

SELECT 'v34_price_instrument_type' AS table_name FROM DUAL;

@@dfn_ntp.v34_price_instrument_type.tab.sql

SELECT 'v08_sub_asset_type' AS table_name FROM DUAL;

@@dfn_ntp.v08_sub_asset_type.tab.sql

SELECT 'm128_marital_status' AS table_name FROM DUAL;

@@dfn_ntp.m128_marital_status.tab.sql

SELECT 'r24_holding_account' AS table_name FROM DUAL;

@@dfn_ntp.r24_holding_account.tab.sql

SELECT 'r06_cash_account' AS table_name FROM DUAL;

@@dfn_ntp.r06_cash_account.tab.sql

SELECT 'm09_companies' AS table_name FROM DUAL;

@@dfn_ntp.m09_companies.tab.sql

SELECT 't25_stock_transfer' AS table_name FROM DUAL;

@@dfn_ntp.t25_stock_transfer.tab.sql

SELECT 'm28_customer_grade_data' AS table_name FROM DUAL;

@@dfn_ntp.m28_customer_grade_data.tab.sql

SELECT 'm33_nationality_category' AS table_name FROM DUAL;

@@dfn_ntp.m33_nationality_category.tab.sql

SELECT 'm74_margin_interest_group' AS table_name FROM DUAL;

@@dfn_ntp.m74_margin_interest_group.tab.sql

SELECT 'm141_cust_corporate_action' AS table_name FROM DUAL;

@@dfn_ntp.m141_cust_corporate_action.tab.sql

SELECT 'm143_corp_act_cash_adjustments' AS table_name FROM DUAL;

@@dfn_ntp.m143_corp_act_cash_adjustments.tab.sql

SELECT 'm142_corp_act_hold_adjustments' AS table_name FROM DUAL;

@@dfn_ntp.m142_corp_act_hold_adjustments.tab.sql

SELECT 'm32_ex_market_status_tif' AS table_name FROM DUAL;

@@dfn_ntp.m32_ex_market_status_tif.tab.sql

SELECT 'a18_user_login_audit' AS table_name FROM DUAL;

@@dfn_ntp.a18_user_login_audit.tab.sql

SELECT 't04_disable_exchange_acc_req' AS table_name FROM DUAL;

@@dfn_ntp.t04_disable_exchange_acc_req.tab.sql

SELECT 'v11_symbol_settle_category' AS table_name FROM DUAL;

@@dfn_ntp.v11_symbol_settle_category.tab.sql

SELECT 'u55_poa_symbol_restrictions' AS table_name FROM DUAL;

@@dfn_ntp.u55_poa_symbol_restrictions.tab.sql

SELECT 'm133_gl_account_types' AS table_name FROM DUAL;

@@dfn_ntp.m133_gl_account_types.tab.sql

SELECT 't05_institute_cash_acc_log' AS table_name FROM DUAL;

@@dfn_ntp.t05_institute_cash_acc_log.tab.sql

SELECT 'm17_bank_branches' AS table_name FROM DUAL;

@@dfn_ntp.m17_bank_branches.tab.sql

SELECT 'h09_cash_account_update' AS table_name FROM DUAL;

@@dfn_ntp.h09_cash_account_update.tab.sql

SELECT 'm136_gl_event_categories' AS table_name FROM DUAL;

@@dfn_ntp.m136_gl_event_categories.tab.sql

SELECT 'm137_gl_event_data_sources' AS table_name FROM DUAL;

@@dfn_ntp.m137_gl_event_data_sources.tab.sql

SELECT 'm139_gl_column_destribution' AS table_name FROM DUAL;

@@dfn_ntp.m139_gl_column_destribution.tab.sql

SELECT 't27_gl_batches' AS table_name FROM DUAL;

@@dfn_ntp.t27_gl_batches.tab.sql

SELECT 't28_gl_record_wise_entries' AS table_name FROM DUAL;

@@dfn_ntp.t28_gl_record_wise_entries.tab.sql

SELECT 'm21_introducing_broker' AS table_name FROM DUAL;

@@dfn_ntp.m21_introducing_broker.tab.sql

SELECT 'm27_ib_commission_structures' AS table_name FROM DUAL;

@@dfn_ntp.m27_ib_commission_structures.tab.sql

SELECT 't29_gl_column_wise_entries' AS table_name FROM DUAL;

@@dfn_ntp.t29_gl_column_wise_entries.tab.sql

SELECT 'm140_corp_action_templates' AS table_name FROM DUAL;

@@dfn_ntp.m140_corp_action_templates.tab.sql

SELECT 'r06_cash_account_tmp' AS table_name FROM DUAL;

@@dfn_ntp.r06_cash_account_tmp.tab.sql

SELECT 'm135_gl_accounts' AS table_name FROM DUAL;

@@dfn_ntp.m135_gl_accounts.tab.sql

SELECT 't53_order_canceled_requests' AS table_name FROM DUAL;

@@dfn_ntp.t53_order_canceled_requests.tab.sql

SELECT 't42_cust_corp_act_hold_adjust' AS table_name FROM DUAL;

@@dfn_ntp.t42_cust_corp_act_hold_adjust.tab.sql

SELECT 't43_cust_corp_act_cash_adjust' AS table_name FROM DUAL;

@@dfn_ntp.t43_cust_corp_act_cash_adjust.tab.sql

SELECT 't41_cust_corp_act_distribution' AS table_name FROM DUAL;

@@dfn_ntp.t41_cust_corp_act_distribution.tab.sql

SELECT 'h10_bank_accounts_summary' AS table_name FROM DUAL;

@@dfn_ntp.h10_bank_accounts_summary.tab.sql

SELECT 'u54_customer_external_login' AS table_name FROM DUAL;

@@dfn_ntp.u54_customer_external_login.tab.sql

SELECT 'v05_institution_entitlements' AS table_name FROM DUAL;

@@dfn_ntp.v05_institution_entitlements.tab.sql

SELECT 'h03_currency_rate' AS table_name FROM DUAL;

@@dfn_ntp.h03_currency_rate.tab.sql

SELECT 'm83_approval_required_columns' AS table_name FROM DUAL;

@@dfn_ntp.m83_approval_required_columns.tab.sql

SELECT 'a08_approval_column_audit_log' AS table_name FROM DUAL;

@@dfn_ntp.a08_approval_column_audit_log.tab.sql

SELECT 'm84_approval_exclude_columns' AS table_name FROM DUAL;

@@dfn_ntp.m84_approval_exclude_columns.tab.sql

SELECT 'z09_export_templates' AS table_name FROM DUAL;

@@dfn_ntp.z09_export_templates.tab.sql

SELECT 'a09_function_approval_log' AS table_name FROM DUAL;

@@dfn_ntp.a09_function_approval_log.tab.sql

SELECT 'm87_exec_broker_exchange' AS table_name FROM DUAL;

@@dfn_ntp.m87_exec_broker_exchange.tab.sql

SELECT 'm31_exec_broker_routing' AS table_name FROM DUAL;

@@dfn_ntp.m31_exec_broker_routing.tab.sql

SELECT 'a06_audit' AS table_name FROM DUAL;

@@dfn_ntp.a06_audit.tab.sql

SELECT 'm93_bank_accounts' AS table_name FROM DUAL;

@@dfn_ntp.m93_bank_accounts.tab.sql

SELECT 'm63_sectors' AS table_name FROM DUAL;

@@dfn_ntp.m63_sectors.tab.sql

SELECT 'm64_saibor_basis_durations' AS table_name FROM DUAL;

@@dfn_ntp.m64_saibor_basis_durations.tab.sql

SELECT 'm65_saibor_basis_rates' AS table_name FROM DUAL;

@@dfn_ntp.m65_saibor_basis_rates.tab.sql

SELECT 'a05_cache_mon_audit_log' AS table_name FROM DUAL;

@@dfn_ntp.a05_cache_mon_audit_log.tab.sql

SELECT 'app_seq_store' AS table_name FROM DUAL;

@@dfn_ntp.app_seq_store.tab.sql

SELECT 'm67_fix_logins' AS table_name FROM DUAL;

@@dfn_ntp.m67_fix_logins.tab.sql

SELECT 'm68_institute_order_channels' AS table_name FROM DUAL;

@@dfn_ntp.m68_institute_order_channels.tab.sql

SELECT 'v29_order_channel' AS table_name FROM DUAL;

@@dfn_ntp.v29_order_channel.tab.sql

SELECT 'm69_institute_trading_limits' AS table_name FROM DUAL;

@@dfn_ntp.m69_institute_trading_limits.tab.sql

SELECT 'h05_institute_trading_limits' AS table_name FROM DUAL;

@@dfn_ntp.h05_institute_trading_limits.tab.sql

SELECT 'm70_custody_exchanges' AS table_name FROM DUAL;

@@dfn_ntp.m70_custody_exchanges.tab.sql

SELECT 'm72_exec_broker_cash_account' AS table_name FROM DUAL;

@@dfn_ntp.m72_exec_broker_cash_account.tab.sql

SELECT 'm71_institute_restrictions' AS table_name FROM DUAL;

@@dfn_ntp.m71_institute_restrictions.tab.sql

SELECT 'm73_margin_products' AS table_name FROM DUAL;

@@dfn_ntp.m73_margin_products.tab.sql

SELECT 'm75_stock_concentration_group' AS table_name FROM DUAL;

@@dfn_ntp.m75_stock_concentration_group.tab.sql

SELECT 'm76_stock_conc_symbol_details' AS table_name FROM DUAL;

@@dfn_ntp.m76_stock_conc_symbol_details.tab.sql

SELECT 'm77_symbol_marginability_grps' AS table_name FROM DUAL;

@@dfn_ntp.m77_symbol_marginability_grps.tab.sql

SELECT 'm78_symbol_marginability' AS table_name FROM DUAL;

@@dfn_ntp.m78_symbol_marginability.tab.sql

SELECT 'm51_employee_trading_groups' AS table_name FROM DUAL;

@@dfn_ntp.m51_employee_trading_groups.tab.sql

SELECT 'm79_pending_symbl_mrg_request' AS table_name FROM DUAL;

@@dfn_ntp.m79_pending_symbl_mrg_request.tab.sql

SELECT 'm80_margin_products_equation' AS table_name FROM DUAL;

@@dfn_ntp.m80_margin_products_equation.tab.sql

SELECT 'm82_audit_activity' AS table_name FROM DUAL;

@@dfn_ntp.m82_audit_activity.tab.sql

SELECT 'm81_audit_category' AS table_name FROM DUAL;

@@dfn_ntp.m81_audit_category.tab.sql

SELECT 'a04_approval_audit_log' AS table_name FROM DUAL;

@@dfn_ntp.a04_approval_audit_log.tab.sql

SELECT 'a07_approval_column_audit' AS table_name FROM DUAL;

@@dfn_ntp.a07_approval_column_audit.tab.sql

SELECT 'm59_exchange_market_status' AS table_name FROM DUAL;

@@dfn_ntp.m59_exchange_market_status.tab.sql

SELECT 'v22_symbol_status' AS table_name FROM DUAL;

@@dfn_ntp.v22_symbol_status.tab.sql

SELECT 'u41_notification_configuration' AS table_name FROM DUAL;

@@dfn_ntp.u41_notification_configuration.tab.sql

SELECT 'm102_notification_schedule' AS table_name FROM DUAL;

@@dfn_ntp.m102_notification_schedule.tab.sql

SELECT 'm99_notification_items' AS table_name FROM DUAL;

@@dfn_ntp.m99_notification_items.tab.sql

SELECT 'm100_notification_sub_items' AS table_name FROM DUAL;

@@dfn_ntp.m100_notification_sub_items.tab.sql

SELECT 'm101_notification_channels' AS table_name FROM DUAL;

@@dfn_ntp.m101_notification_channels.tab.sql

SELECT 'm103_notify_subitem_schedule' AS table_name FROM DUAL;

@@dfn_ntp.m103_notify_subitem_schedule.tab.sql

SELECT 't06_cash_transaction' AS table_name FROM DUAL;

@@dfn_ntp.t06_cash_transaction.tab.sql

SELECT 't11_block_amount_details' AS table_name FROM DUAL;

@@dfn_ntp.t11_block_amount_details.tab.sql

SELECT 'u18_trading_channel_restrict' AS table_name FROM DUAL;

@@dfn_ntp.u18_trading_channel_restrict.tab.sql

SELECT 'a11_log_data' AS table_name FROM DUAL;

@@dfn_ntp.a11_log_data.tab.sql

SELECT 'm60_institute_banks' AS table_name FROM DUAL;

@@dfn_ntp.m60_institute_banks.tab.sql

SELECT 'v23_price_update_codes' AS table_name FROM DUAL;

@@dfn_ntp.v23_price_update_codes.tab.sql

SELECT 'v24_industry_codes' AS table_name FROM DUAL;

@@dfn_ntp.v24_industry_codes.tab.sql

SELECT 'v25_payment_types' AS table_name FROM DUAL;

@@dfn_ntp.v25_payment_types.tab.sql

SELECT 'v26_interest_day_basis' AS table_name FROM DUAL;

@@dfn_ntp.v26_interest_day_basis.tab.sql

SELECT 'v27_bond_ratings' AS table_name FROM DUAL;

@@dfn_ntp.v27_bond_ratings.tab.sql

SELECT 'u43_user_cash_accounts' AS table_name FROM DUAL;

@@dfn_ntp.u43_user_cash_accounts.tab.sql

SELECT 'v28_document_types' AS table_name FROM DUAL;

@@dfn_ntp.v28_document_types.tab.sql

SELECT 'm61_uploadable_documents' AS table_name FROM DUAL;

@@dfn_ntp.m61_uploadable_documents.tab.sql

SELECT 'm62_institute_documents' AS table_name FROM DUAL;

@@dfn_ntp.m62_institute_documents.tab.sql

SELECT 'r07_fix_log' AS table_name FROM DUAL;

@@dfn_ntp.r07_fix_log.tab.sql

SELECT 'r08_order_audit' AS table_name FROM DUAL;

@@dfn_ntp.r08_order_audit.tab.sql

SELECT 't23_share_txn_requests' AS table_name FROM DUAL;

@@dfn_ntp.t23_share_txn_requests.tab.sql

SELECT 't19_c_umessage_share_details' AS table_name FROM DUAL;

@@dfn_ntp.t19_c_umessage_share_details.tab.sql

SELECT 'm35_customer_settl_group' AS table_name FROM DUAL;

@@dfn_ntp.m35_customer_settl_group.tab.sql

SELECT 'z08_version' AS table_name FROM DUAL;

@@dfn_ntp.z08_version.tab.sql

SELECT 'm34_exec_broker_commission' AS table_name FROM DUAL;

@@dfn_ntp.m34_exec_broker_commission.tab.sql

SELECT 'u03_customer_kyc' AS table_name FROM DUAL;

@@dfn_ntp.u03_customer_kyc.tab.sql

SELECT 'a12_rest_data' AS table_name FROM DUAL;

@@dfn_ntp.a12_rest_data.tab.sql

SELECT 't12_share_transaction' AS table_name FROM DUAL;

@@dfn_ntp.t12_share_transaction.tab.sql

SELECT 't18_c_umessage' AS table_name FROM DUAL;

@@dfn_ntp.t18_c_umessage.tab.sql

SELECT 't21_daily_interest_for_charges' AS table_name FROM DUAL;

@@dfn_ntp.t21_daily_interest_for_charges.tab.sql

SELECT 'm115_client_routes' AS table_name FROM DUAL;

@@dfn_ntp.m115_client_routes.tab.sql

SELECT 'h08_client_routes' AS table_name FROM DUAL;

@@dfn_ntp.h08_client_routes.tab.sql

SELECT 'u50_kyc_ecdd_annual_review' AS table_name FROM DUAL;

@@dfn_ntp.u50_kyc_ecdd_annual_review.tab.sql

SELECT 'm116_hijri_adjustments' AS table_name FROM DUAL;

@@dfn_ntp.m116_hijri_adjustments.tab.sql

SELECT 'm111_messages' AS table_name FROM DUAL;

@@dfn_ntp.m111_messages.tab.sql

SELECT 'u48_corp_customer_contact' AS table_name FROM DUAL;

@@dfn_ntp.u48_corp_customer_contact.tab.sql

SELECT 'm112_fatca_entities' AS table_name FROM DUAL;

@@dfn_ntp.m112_fatca_entities.tab.sql

SELECT 'm113_fatca_institutions' AS table_name FROM DUAL;

@@dfn_ntp.m113_fatca_institutions.tab.sql

SELECT 't15_authorization_request' AS table_name FROM DUAL;

@@dfn_ntp.t15_authorization_request.tab.sql

SELECT 'u24_holdings' AS table_name FROM DUAL;

@@dfn_ntp.u24_holdings.tab.sql

SELECT 't16_eod_status' AS table_name FROM DUAL;

@@dfn_ntp.t16_eod_status.tab.sql

SELECT 't02_transaction_log' AS table_name FROM DUAL;

@@dfn_ntp.t02_transaction_log.tab.sql

SELECT 'm107_notification_master' AS table_name FROM DUAL;

@@dfn_ntp.m107_notification_master.tab.sql

SELECT 't13_notifications' AS table_name FROM DUAL;

@@dfn_ntp.t13_notifications.tab.sql

SELECT 't14_notification_data' AS table_name FROM DUAL;

@@dfn_ntp.t14_notification_data.tab.sql

SELECT 'h07_user_sessions' AS table_name FROM DUAL;

@@dfn_ntp.h07_user_sessions.tab.sql

SELECT 'u46_user_sessions' AS table_name FROM DUAL;

@@dfn_ntp.u46_user_sessions.tab.sql

SELECT 'm109_customer_family_members' AS table_name FROM DUAL;

@@dfn_ntp.m109_customer_family_members.tab.sql

SELECT 'm110_reasons' AS table_name FROM DUAL;

@@dfn_ntp.m110_reasons.tab.sql

SELECT 'm104_cust_notification_schedul' AS table_name FROM DUAL;

@@dfn_ntp.m104_cust_notification_schedul.tab.sql

SELECT 't09_txn_single_entry_v3' AS table_name FROM DUAL;

@@dfn_ntp.t09_txn_single_entry_v3.tab.sql

SELECT 'm105_other_brokerages' AS table_name FROM DUAL;

@@dfn_ntp.m105_other_brokerages.tab.sql

SELECT 'm106_client_risk_assessment' AS table_name FROM DUAL;

@@dfn_ntp.m106_client_risk_assessment.tab.sql

SELECT 'u44_uploaded_documents' AS table_name FROM DUAL;

@@dfn_ntp.u44_uploaded_documents.tab.sql

SELECT 'u45_uploaded_doc_pages' AS table_name FROM DUAL;

@@dfn_ntp.u45_uploaded_doc_pages.tab.sql

SELECT 'u30_login_cash_acc' AS table_name FROM DUAL;

@@dfn_ntp.u30_login_cash_acc.tab.sql

SELECT 'v01_system_master_data' AS table_name FROM DUAL;

@@dfn_ntp.v01_system_master_data.tab.sql

SELECT 'm45_permission_groups' AS table_name FROM DUAL;

@@dfn_ntp.m45_permission_groups.tab.sql

SELECT 'm46_permission_grp_entlements' AS table_name FROM DUAL;

@@dfn_ntp.m46_permission_grp_entlements.tab.sql

SELECT 'm47_permission_grp_users' AS table_name FROM DUAL;

@@dfn_ntp.m47_permission_grp_users.tab.sql

SELECT 'u28_employee_exchanges' AS table_name FROM DUAL;

@@dfn_ntp.u28_employee_exchanges.tab.sql

SELECT 'u29_emp_notification_groups' AS table_name FROM DUAL;

@@dfn_ntp.u29_emp_notification_groups.tab.sql

SELECT 'm04_currency_rate' AS table_name FROM DUAL;

@@dfn_ntp.m04_currency_rate.tab.sql

SELECT 'u14_trading_symbol_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u14_trading_symbol_restriction.tab.sql

SELECT 'u16_trading_instrument_restric' AS table_name FROM DUAL;

@@dfn_ntp.u16_trading_instrument_restric.tab.sql

SELECT 'z01_forms_m' AS table_name FROM DUAL;

@@dfn_ntp.z01_forms_m.tab.sql

SELECT 'z02_forms_cols' AS table_name FROM DUAL;

@@dfn_ntp.z02_forms_cols.tab.sql

SELECT 'z03_forms_menu' AS table_name FROM DUAL;

@@dfn_ntp.z03_forms_menu.tab.sql

SELECT 'z04_forms_color' AS table_name FROM DUAL;

@@dfn_ntp.z04_forms_color.tab.sql

SELECT 'm50_employee_trd_limits' AS table_name FROM DUAL;

@@dfn_ntp.m50_employee_trd_limits.tab.sql

SELECT 'm43_institute_exchanges' AS table_name FROM DUAL;

@@dfn_ntp.m43_institute_exchanges.tab.sql

SELECT 'm36_settlement_calendar' AS table_name FROM DUAL;

@@dfn_ntp.m36_settlement_calendar.tab.sql

SELECT 'v00_sys_config' AS table_name FROM DUAL;

@@dfn_ntp.v00_sys_config.tab.sql

SELECT 'm19_routing_data' AS table_name FROM DUAL;

@@dfn_ntp.m19_routing_data.tab.sql

SELECT 'm29_markets' AS table_name FROM DUAL;

@@dfn_ntp.m29_markets.tab.sql

SELECT 'v02_ent_sensitive_levels' AS table_name FROM DUAL;

@@dfn_ntp.v02_ent_sensitive_levels.tab.sql

SELECT 'v03_entitlement_type' AS table_name FROM DUAL;

@@dfn_ntp.v03_entitlement_type.tab.sql

SELECT 'v04_entitlements' AS table_name FROM DUAL;

@@dfn_ntp.v04_entitlements.tab.sql

SELECT 'm44_institution_entitlements' AS table_name FROM DUAL;

@@dfn_ntp.m44_institution_entitlements.tab.sql

SELECT 'u10_login_trading_acc' AS table_name FROM DUAL;

@@dfn_ntp.u10_login_trading_acc.tab.sql

SELECT 'm52_notification_group' AS table_name FROM DUAL;

@@dfn_ntp.m52_notification_group.tab.sql

SELECT 'z07_menu' AS table_name FROM DUAL;

@@dfn_ntp.z07_menu.tab.sql

SELECT 'm01_exchanges' AS table_name FROM DUAL;

@@dfn_ntp.m01_exchanges.tab.sql

SELECT 'm55_price_block_types' AS table_name FROM DUAL;

@@dfn_ntp.m55_price_block_types.tab.sql

SELECT 'm56_password_complexity_levels' AS table_name FROM DUAL;

@@dfn_ntp.m56_password_complexity_levels.tab.sql

SELECT 'v06_order_type' AS table_name FROM DUAL;

@@dfn_ntp.v06_order_type.tab.sql

SELECT 'v09_instrument_types' AS table_name FROM DUAL;

@@dfn_ntp.v09_instrument_types.tab.sql

SELECT 'm57_exchange_order_types' AS table_name FROM DUAL;

@@dfn_ntp.m57_exchange_order_types.tab.sql

SELECT 'v10_tif' AS table_name FROM DUAL;

@@dfn_ntp.v10_tif.tab.sql

SELECT 'm58_exchange_tif' AS table_name FROM DUAL;

@@dfn_ntp.m58_exchange_tif.tab.sql

SELECT 'v19_market_status' AS table_name FROM DUAL;

@@dfn_ntp.v19_market_status.tab.sql

SELECT 'm20_symbol_extended' AS table_name FROM DUAL;

@@dfn_ntp.m20_symbol_extended.tab.sql

SELECT 'u47_power_of_attorney' AS table_name FROM DUAL;

@@dfn_ntp.u47_power_of_attorney.tab.sql

SELECT 'm90_region' AS table_name FROM DUAL;

@@dfn_ntp.m90_region.tab.sql

SELECT 'm92_oms_cache_store_map' AS table_name FROM DUAL;

@@dfn_ntp.m92_oms_cache_store_map.tab.sql

SELECT 'a10_entity_status_history' AS table_name FROM DUAL;

@@dfn_ntp.a10_entity_status_history.tab.sql

SELECT 'v30_order_status' AS table_name FROM DUAL;

@@dfn_ntp.v30_order_status.tab.sql

SELECT 'm23_commission_slabs' AS table_name FROM DUAL;

@@dfn_ntp.m23_commission_slabs.tab.sql

SELECT 'm25_commission_discount_slabs' AS table_name FROM DUAL;

@@dfn_ntp.m25_commission_discount_slabs.tab.sql

SELECT 'u20_login_cash_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u20_login_cash_restriction.tab.sql

SELECT 'u21_login_trading_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u21_login_trading_restriction.tab.sql

SELECT 'u11_cash_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u11_cash_restriction.tab.sql

SELECT 'u12_trading_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u12_trading_restriction.tab.sql

SELECT 'v31_restriction' AS table_name FROM DUAL;

@@dfn_ntp.v31_restriction.tab.sql

SELECT 'm95_settlement_calendar_config' AS table_name FROM DUAL;

@@dfn_ntp.m95_settlement_calendar_config.tab.sql

SELECT 'm53_approval_required_tables' AS table_name FROM DUAL;

@@dfn_ntp.m53_approval_required_tables.tab.sql

SELECT 'm96_holidays' AS table_name FROM DUAL;

@@dfn_ntp.m96_holidays.tab.sql

SELECT 'm88_function_approval' AS table_name FROM DUAL;

@@dfn_ntp.m88_function_approval.tab.sql

SELECT 'a03_approval_audit' AS table_name FROM DUAL;

@@dfn_ntp.a03_approval_audit.tab.sql

SELECT 'm138_gl_record_destribution' AS table_name FROM DUAL;

@@dfn_ntp.m138_gl_record_destribution.tab.sql

SELECT 'm134_gl_account_categories' AS table_name FROM DUAL;

@@dfn_ntp.m134_gl_account_categories.tab.sql

SELECT 'm114_company_positions' AS table_name FROM DUAL;

@@dfn_ntp.m114_company_positions.tab.sql

SELECT 't20_pending_pledge' AS table_name FROM DUAL;

@@dfn_ntp.t20_pending_pledge.tab.sql

SELECT 't10_cash_block_request' AS table_name FROM DUAL;

@@dfn_ntp.t10_cash_block_request.tab.sql

SELECT 'redis_process_validation_error' AS table_name FROM DUAL;

@@dfn_ntp.redis_process_validation_error.tab.sql

SELECT 'redis_process_seq' AS table_name FROM DUAL;

@@dfn_ntp.redis_process_seq.tab.sql

SELECT 't08_od_withdraw_limit' AS table_name FROM DUAL;

@@dfn_ntp.t08_od_withdraw_limit.tab.sql

SELECT 'm125_exchange_instrument_type' AS table_name FROM DUAL;

@@dfn_ntp.m125_exchange_instrument_type.tab.sql

SELECT 'u51_poa_symbol_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u51_poa_symbol_restriction.tab.sql

SELECT 'u52_poa_trad_privilege_pending' AS table_name FROM DUAL;

@@dfn_ntp.u52_poa_trad_privilege_pending.tab.sql

SELECT 'u49_poa_trading_privileges' AS table_name FROM DUAL;

@@dfn_ntp.u49_poa_trading_privileges.tab.sql

SELECT 'm85_approval_columns' AS table_name FROM DUAL;

@@dfn_ntp.m85_approval_columns.tab.sql

SELECT 'm121_charge_fee_types' AS table_name FROM DUAL;

@@dfn_ntp.m121_charge_fee_types.tab.sql

SELECT 'm117_charge_groups' AS table_name FROM DUAL;

@@dfn_ntp.m117_charge_groups.tab.sql

SELECT 'm118_charge_fee_structure' AS table_name FROM DUAL;

@@dfn_ntp.m118_charge_fee_structure.tab.sql

SELECT 'm120_sharia_compliant_group' AS table_name FROM DUAL;

@@dfn_ntp.m120_sharia_compliant_group.tab.sql

SELECT 'm122_exchange_tick_sizes' AS table_name FROM DUAL;

@@dfn_ntp.m122_exchange_tick_sizes.tab.sql

SELECT 'm119_sharia_symbol' AS table_name FROM DUAL;

@@dfn_ntp.m119_sharia_symbol.tab.sql

SELECT 'm123_master_data_versions' AS table_name FROM DUAL;

@@dfn_ntp.m123_master_data_versions.tab.sql

SELECT 'r02_fix_log_recon' AS table_name FROM DUAL;

@@dfn_ntp.r02_fix_log_recon.tab.sql

SELECT 'z25_auto_update_versions' AS table_name FROM DUAL;

@@dfn_ntp.z25_auto_update_versions.tab.sql

SELECT 'm126_rules' AS table_name FROM DUAL;

@@dfn_ntp.m126_rules.tab.sql

SELECT 'r04_level2_recon' AS table_name FROM DUAL;

@@dfn_ntp.r04_level2_recon.tab.sql

SELECT 'r01_cash_resolution_recon' AS table_name FROM DUAL;

@@dfn_ntp.r01_cash_resolution_recon.tab.sql

SELECT 'r03_holding_resolution_recon' AS table_name FROM DUAL;

@@dfn_ntp.r03_holding_resolution_recon.tab.sql

SELECT 'v07_db_jobs' AS table_name FROM DUAL;

@@dfn_ntp.v07_db_jobs.tab.sql

SELECT 'm30_ex_market_permissions' AS table_name FROM DUAL;

@@dfn_ntp.m30_ex_market_permissions.tab.sql

SELECT 'v33_corporate_action_types' AS table_name FROM DUAL;

@@dfn_ntp.v33_corporate_action_types.tab.sql

SELECT 'm97_transaction_codes' AS table_name FROM DUAL;

@@dfn_ntp.m97_transaction_codes.tab.sql

SELECT 'u53_process_detail' AS table_name FROM DUAL;

@@dfn_ntp.u53_process_detail.tab.sql

SELECT 'm127_reason_types' AS table_name FROM DUAL;

@@dfn_ntp.m127_reason_types.tab.sql

SELECT 'v32_language_dictionary' AS table_name FROM DUAL;

@@dfn_ntp.v32_language_dictionary.tab.sql

SELECT 'm124_commission_types' AS table_name FROM DUAL;

@@dfn_ntp.m124_commission_types.tab.sql

SELECT 'a01_db_jobs_execution_log' AS table_name FROM DUAL;

@@dfn_ntp.a01_db_jobs_execution_log.tab.sql

SELECT 't09_error_records' AS table_name FROM DUAL;

@@dfn_ntp.t09_error_records.tab.sql

SELECT 'r05_order_audit_recon' AS table_name FROM DUAL;

@@dfn_ntp.r05_order_audit_recon.tab.sql

SELECT 't52_desk_orders' AS table_name FROM DUAL;

@@dfn_ntp.t52_desk_orders.tab.sql

SELECT 't01_order' AS table_name FROM DUAL;

@@dfn_ntp.t01_order.tab.sql

SELECT 'h00_dates' AS table_name FROM DUAL;

@@dfn_ntp.h00_dates.tab.sql

SELECT 'u17_employee' AS table_name FROM DUAL;

@@dfn_ntp.u17_employee.tab.sql

SELECT 'm20_symbol' AS table_name FROM DUAL;

@@dfn_ntp.m20_symbol.tab.sql

SELECT 'm02_institute' AS table_name FROM DUAL;

@@dfn_ntp.m02_institute.tab.sql

SELECT 'm24_commission_discount_group' AS table_name FROM DUAL;

@@dfn_ntp.m24_commission_discount_group.tab.sql

SELECT 'm26_executing_broker' AS table_name FROM DUAL;

@@dfn_ntp.m26_executing_broker.tab.sql

SELECT 'u09_customer_login' AS table_name FROM DUAL;

@@dfn_ntp.u09_customer_login.tab.sql

SELECT 'e01_corporate_actions' AS table_name FROM DUAL;

@@dfn_ntp.e01_corporate_actions.tab.sql

SELECT 'e03_weekly_reconciliation' AS table_name FROM DUAL;

@@dfn_ntp.e03_weekly_reconciliation.tab.sql

SELECT 'h02_cash_account_summary' AS table_name FROM DUAL;

@@dfn_ntp.h02_cash_account_summary.tab.sql

SELECT 'h01_holding_summary' AS table_name FROM DUAL;

@@dfn_ntp.h01_holding_summary.tab.sql

SELECT 'e02_eod_fix_log' AS table_name FROM DUAL;

@@dfn_ntp.e02_eod_fix_log.tab.sql

SELECT 'm11_employee_type' AS table_name FROM DUAL;

@@dfn_ntp.m11_employee_type.tab.sql

SELECT 'm12_employee_department' AS table_name FROM DUAL;

@@dfn_ntp.m12_employee_department.tab.sql

SELECT 'u01_customer' AS table_name FROM DUAL;

@@dfn_ntp.u01_customer.tab.sql

SELECT 'u06_cash_account' AS table_name FROM DUAL;

@@dfn_ntp.u06_cash_account.tab.sql

SELECT 'u07_trading_account' AS table_name FROM DUAL;

@@dfn_ntp.u07_trading_account.tab.sql

SELECT 'u08_customer_beneficiary_acc' AS table_name FROM DUAL;

@@dfn_ntp.u08_customer_beneficiary_acc.tab.sql

SELECT 'm05_country' AS table_name FROM DUAL;

@@dfn_ntp.m05_country.tab.sql

SELECT 'm06_city' AS table_name FROM DUAL;

@@dfn_ntp.m06_city.tab.sql

SELECT 'm03_currency' AS table_name FROM DUAL;

@@dfn_ntp.m03_currency.tab.sql

SELECT 'm07_location' AS table_name FROM DUAL;

@@dfn_ntp.m07_location.tab.sql

SELECT 'm08_trading_group' AS table_name FROM DUAL;

@@dfn_ntp.m08_trading_group.tab.sql

SELECT 'm10_relationship_manager' AS table_name FROM DUAL;

@@dfn_ntp.m10_relationship_manager.tab.sql

SELECT 'm14_issue_location' AS table_name FROM DUAL;

@@dfn_ntp.m14_issue_location.tab.sql

SELECT 'm15_identity_type' AS table_name FROM DUAL;

@@dfn_ntp.m15_identity_type.tab.sql

SELECT 'u04_cma_identification' AS table_name FROM DUAL;

@@dfn_ntp.u04_cma_identification.tab.sql

SELECT 'u05_customer_identification' AS table_name FROM DUAL;

@@dfn_ntp.u05_customer_identification.tab.sql

SELECT 'm16_bank' AS table_name FROM DUAL;

@@dfn_ntp.m16_bank.tab.sql

SELECT 'u02_customer_contact_info' AS table_name FROM DUAL;

@@dfn_ntp.u02_customer_contact_info.tab.sql

SELECT 'u23_customer_margin_product' AS table_name FROM DUAL;

@@dfn_ntp.u23_customer_margin_product.tab.sql

SELECT 'm22_commission_group' AS table_name FROM DUAL;

@@dfn_ntp.m22_commission_group.tab.sql

SELECT 'm145_notify_event_cat' AS table_name FROM DUAL;

@@dfn_ntp.m145_notify_event_cat.tab.sql

SELECT 'm146_notify_tag_master' AS table_name FROM DUAL;

@@dfn_ntp.m146_notify_tag_master.tab.sql

SELECT 'm147_notify_event_cat_tag_map' AS table_name FROM DUAL;

@@dfn_ntp.m147_notify_event_cat_tag_map.tab.sql

SELECT 'm148_notify_events_master' AS table_name FROM DUAL;

@@dfn_ntp.m148_notify_events_master.tab.sql

SELECT 'm149_notify_templates' AS table_name FROM DUAL;

@@dfn_ntp.m149_notify_templates.tab.sql

SELECT 't17_trade_processing_requests' AS table_name FROM DUAL;

@@dfn_ntp.t17_trade_processing_requests.tab.sql

SELECT 'u22_customer_margin_call_log' AS table_name FROM DUAL;

@@dfn_ntp.u22_customer_margin_call_log.tab.sql

SELECT 't44_pending_cust_ca_adjust' AS table_name FROM DUAL;

@@dfn_ntp.t44_pending_cust_ca_adjust.tab.sql

SELECT 't45_pending_ca_cash_adjustment' AS table_name FROM DUAL;

@@dfn_ntp.t45_pending_ca_cash_adjustment.tab.sql

SELECT 't46_pending_ca_hold_adjustment' AS table_name FROM DUAL;

@@dfn_ntp.t46_pending_ca_hold_adjustment.tab.sql

SELECT 't54_slice_orders' AS table_name FROM DUAL;

@@dfn_ntp.t54_slice_orders.tab.sql

SELECT 'h11_holding_summary_log' AS table_name FROM DUAL;

@@dfn_ntp.h11_holding_summary_log.tab.sql

SELECT 'h12_cash_account_summary_log' AS table_name FROM DUAL;

@@dfn_ntp.h12_cash_account_summary_log.tab.sql

SELECT 'v20_default_master_data' AS table_name FROM DUAL;

@@dfn_ntp.v20_default_master_data.tab.sql

SELECT 'z10_version_audit_log' AS table_name FROM DUAL;

@@dfn_ntp.z10_version_audit_log.tab.sql

SELECT 'm131_market_maker_grps' AS table_name FROM DUAL;

@@dfn_ntp.m131_market_maker_grps.tab.sql

SELECT 'm132_market_maker_grp_details' AS table_name FROM DUAL;

@@dfn_ntp.m132_market_maker_grp_details.tab.sql

SELECT 'u13_ext_custody_portfolios' AS table_name FROM DUAL;

@@dfn_ntp.u13_ext_custody_portfolios.tab.sql

SELECT 't30_gl_txn_candidates' AS table_name FROM DUAL;

@@dfn_ntp.t30_gl_txn_candidates.tab.sql

SELECT 'a13_cash_holding_adjust_log' AS table_name FROM DUAL;

@@dfn_ntp.a13_cash_holding_adjust_log.tab.sql

SELECT 'z02_forms_cols_c' AS table_name FROM DUAL;

@@dfn_ntp.z02_forms_cols_c.tab.sql

SELECT 'z03_forms_menu_c' AS table_name FROM DUAL;

@@dfn_ntp.z03_forms_menu_c.tab.sql

SELECT 'z04_forms_color_c' AS table_name FROM DUAL;

@@dfn_ntp.z04_forms_color_c.tab.sql

SELECT 'a19_cash_account_adjust_log' AS table_name FROM DUAL;

@@dfn_ntp.a19_cash_account_adjust_log.tab.sql

SELECT 'a20_holding_adjust_log' AS table_name FROM DUAL;

@@dfn_ntp.a20_holding_adjust_log.tab.sql

SELECT 'm150_broker' AS table_name FROM DUAL;

@@dfn_ntp.m150_broker.tab.sql

SELECT 't32_weekly_reconciliation' AS table_name FROM DUAL;

@@dfn_ntp.t32_weekly_reconciliation.tab.sql

SELECT 'm37_other_login' AS table_name FROM DUAL;

@@dfn_ntp.m37_other_login.tab.sql

SELECT 't31_eod_fix_log' AS table_name FROM DUAL;

@@dfn_ntp.t31_eod_fix_log.tab.sql

SELECT 't33_corporate_actions' AS table_name FROM DUAL;

@@dfn_ntp.t33_corporate_actions.tab.sql

SELECT 'm157_subcription_prd_channels' AS table_name FROM DUAL;

@@dfn_ntp.m157_subcription_prd_channels.tab.sql

SELECT 't58_cache_clear_request' AS table_name FROM DUAL;

@@dfn_ntp.t58_cache_clear_request.tab.sql

SELECT 'm152_products' AS table_name FROM DUAL;

@@dfn_ntp.m152_products.tab.sql

SELECT 'm153_exchange_subscription_prd' AS table_name FROM DUAL;

@@dfn_ntp.m153_exchange_subscription_prd.tab.sql

SELECT 'm154_subscription_waiveoff_grp' AS table_name FROM DUAL;

@@dfn_ntp.m154_subscription_waiveoff_grp.tab.sql

SELECT 'm155_product_waiveoff_details' AS table_name FROM DUAL;

@@dfn_ntp.m155_product_waiveoff_details.tab.sql

SELECT 'm156_exchange_waiveoff_details' AS table_name FROM DUAL;

@@dfn_ntp.m156_exchange_waiveoff_details.tab.sql

SELECT 't56_product_subscription_data' AS table_name FROM DUAL;

@@dfn_ntp.t56_product_subscription_data.tab.sql

SELECT 't57_exchange_subscription_data' AS table_name FROM DUAL;

@@dfn_ntp.t57_exchange_subscription_data.tab.sql

SELECT 't59_product_subscription_log' AS table_name FROM DUAL;

@@dfn_ntp.t59_product_subscription_log.tab.sql

SELECT 't60_exchange_subscription_log' AS table_name FROM DUAL;

@@dfn_ntp.t60_exchange_subscription_log.tab.sql

SELECT 'm158_priceuser_agreement' AS table_name FROM DUAL;

@@dfn_ntp.m158_priceuser_agreement.tab.sql

SELECT 'm151_trade_confirm_config' AS table_name FROM DUAL;

@@dfn_ntp.m151_trade_confirm_config.tab.sql

SELECT 'v12_trade_config_format' AS table_name FROM DUAL;

@@dfn_ntp.v12_trade_config_format.tab.sql

SELECT 'v35_products' AS table_name FROM DUAL;

@@dfn_ntp.v35_products.tab.sql

SELECT 'm98_institution_txn_codes' AS table_name FROM DUAL;

@@dfn_ntp.m98_institution_txn_codes.tab.sql

SELECT 't61_bulk_share_transactions' AS table_name FROM DUAL;

@@dfn_ntp.t61_bulk_share_transactions.tab.sql

SELECT 't62_order_status_requests' AS table_name FROM DUAL;

@@dfn_ntp.t62_order_status_requests.tab.sql

SELECT 'v00_sys_config_broker_wise' AS table_name FROM DUAL;

@@dfn_ntp.v00_sys_config_broker_wise.tab.sql

SELECT 'z01_forms_m_c' AS table_name FROM DUAL;

@@dfn_ntp.z01_forms_m_c.tab.sql

SELECT 'z07_menu_c' AS table_name FROM DUAL;

@@dfn_ntp.z07_menu_c.tab.sql

SELECT 'm159_offline_symbol_sessions' AS table_name FROM DUAL;

@@dfn_ntp.m159_offline_symbol_sessions.tab.sql

SELECT 'm160_offline_symbol_update_log' AS table_name FROM DUAL;

@@dfn_ntp.m160_offline_symbol_update_log.tab.sql

SELECT 't55_trade_allocation_details' AS table_name FROM DUAL;

@@dfn_ntp.t55_trade_allocation_details.tab.sql

SELECT 'temp' AS table_name FROM DUAL;

@@dfn_ntp.temp.tab.sql

SELECT 't63_tc_request_list' AS table_name FROM DUAL;

@@dfn_ntp.t63_tc_request_list.tab.sql

SELECT 't64_trade_confirmation_list' AS table_name FROM DUAL;

@@dfn_ntp.t64_trade_confirmation_list.tab.sql

SELECT 'm161_uploaded_price_user_pool' AS table_name FROM DUAL;

@@dfn_ntp.m161_uploaded_price_user_pool.tab.sql

SELECT 'm161_price_user_pool' AS table_name FROM DUAL;

@@dfn_ntp.m161_price_user_pool.tab.sql

SELECT 't65_trade_processing_execution' AS table_name FROM DUAL;

@@dfn_ntp.t65_trade_processing_execution.tab.sql

SELECT 't66_tc_notify_request' AS table_name FROM DUAL;

@@dfn_ntp.t66_tc_notify_request.tab.sql

SELECT 'm164_cust_charge_discounts' AS table_name FROM DUAL;

@@dfn_ntp.m164_cust_charge_discounts.tab.sql

SELECT 't47_dealer_commission' AS table_name FROM DUAL;

@@dfn_ntp.t47_dealer_commission.tab.sql

SELECT 't07_nastro_account_log' AS table_name FROM DUAL;

@@dfn_ntp.t07_nastro_account_log.tab.sql

SELECT 't38_conditional_order' AS table_name FROM DUAL;

@@dfn_ntp.t38_conditional_order.tab.sql

SELECT 't500_payment_sessions_c' AS table_name FROM DUAL;

@@dfn_ntp.t500_payment_sessions_c.tab.sql

SELECT 't501_payment_detail_c' AS table_name FROM DUAL;

@@dfn_ntp.t501_payment_detail_c.tab.sql

SELECT 't502_change_account_requests_c' AS table_name FROM DUAL;

@@dfn_ntp.t502_change_account_requests_c.tab.sql

SELECT 'm165_discount_charge_groups' AS table_name FROM DUAL;

@@dfn_ntp.m165_discount_charge_groups.tab.sql

SELECT 'm166_custody_charges_group' AS table_name FROM DUAL;

@@dfn_ntp.m166_custody_charges_group.tab.sql

SELECT 'm167_custody_charges_slab' AS table_name FROM DUAL;

@@dfn_ntp.m167_custody_charges_slab.tab.sql

SELECT 't67_stock_block_request' AS table_name FROM DUAL;

@@dfn_ntp.t67_stock_block_request.tab.sql

SELECT 'm168_otc_trading_instruments' AS table_name FROM DUAL;

@@dfn_ntp.m168_otc_trading_instruments.tab.sql

SELECT 'm169_otc_trading_commission' AS table_name FROM DUAL;

@@dfn_ntp.m169_otc_trading_commission.tab.sql

SELECT 't69_money_market_contract' AS table_name FROM DUAL;

@@dfn_ntp.t69_money_market_contract.tab.sql

SELECT 'm171_bond_issue_config' AS table_name FROM DUAL;

@@dfn_ntp.m171_bond_issue_config.tab.sql

SELECT 'm172_bond_issue_term_structure' AS table_name FROM DUAL;

@@dfn_ntp.m172_bond_issue_term_structure.tab.sql

SELECT 't68_bond_contract' AS table_name FROM DUAL;

@@dfn_ntp.t68_bond_contract.tab.sql

SELECT 'v13_system_properties' AS table_name FROM DUAL;

@@dfn_ntp.v13_system_properties.tab.sql

SELECT 'm38_arc_table_configuration' AS table_name FROM DUAL;

@@dfn_ntp.m38_arc_table_configuration.tab.sql

SELECT 'a14_arc_table_log' AS table_name FROM DUAL;

@@dfn_ntp.a14_arc_table_log.tab.sql

SELECT 'm176_order_limit_group' AS table_name FROM DUAL;

@@dfn_ntp.m176_order_limit_group.tab.sql

SELECT 'm177_cash_transfer_limit_group' AS table_name FROM DUAL;

@@dfn_ntp.m177_cash_transfer_limit_group.tab.sql

SELECT 'm178_asset_management_company' AS table_name FROM DUAL;

@@dfn_ntp.m178_asset_management_company.tab.sql

SELECT 'm162_incentive_group' AS table_name FROM DUAL;

@@dfn_ntp.m162_incentive_group.tab.sql

SELECT 'm163_incentive_slabs' AS table_name FROM DUAL;

@@dfn_ntp.m163_incentive_slabs.tab.sql

SELECT 't34_post_trade_requests' AS table_name FROM DUAL;

@@dfn_ntp.t34_post_trade_requests.tab.sql

SELECT 't35_post_trade_sources' AS table_name FROM DUAL;

@@dfn_ntp.t35_post_trade_sources.tab.sql

SELECT 't36_post_trade_destination' AS table_name FROM DUAL;

@@dfn_ntp.t36_post_trade_destination.tab.sql

SELECT 'm173_data_loader_template' AS table_name FROM DUAL;

@@dfn_ntp.m173_data_loader_template.tab.sql

SELECT 'm174_data_loader_field_map' AS table_name FROM DUAL;

@@dfn_ntp.m174_data_loader_field_map.tab.sql

SELECT 'm175_data_loader_type_fields' AS table_name FROM DUAL;

@@dfn_ntp.m175_data_loader_type_fields.tab.sql

SELECT 'a21_minimum_commission_audit' AS table_name FROM DUAL;

@@dfn_ntp.a21_minimum_commission_audit.tab.sql

SELECT 't47_incentive_for_staff_n_cust' AS table_name FROM DUAL;

@@dfn_ntp.t47_incentive_for_staff_n_cust.tab.sql

SELECT 'm39_price_qty_factors' AS table_name FROM DUAL;

@@dfn_ntp.m39_price_qty_factors.tab.sql

SELECT 'm18_derivative_spread_matrix' AS table_name FROM DUAL;

@@dfn_ntp.m18_derivative_spread_matrix.tab.sql

SELECT 'm170_institute_cash_acc_config' AS table_name FROM DUAL;

@@dfn_ntp.m170_institute_cash_acc_config.tab.sql

SELECT 'm179_feature_channel_restrict' AS table_name FROM DUAL;

@@dfn_ntp.m179_feature_channel_restrict.tab.sql

SELECT 'm180_institute_default_values' AS table_name FROM DUAL;

@@dfn_ntp.m180_institute_default_values.tab.sql

SELECT 'v36_margin_product_equation' AS table_name FROM DUAL;

@@dfn_ntp.v36_margin_product_equation.tab.sql

SELECT 't70_mark_to_market' AS table_name FROM DUAL;

@@dfn_ntp.t70_mark_to_market.tab.sql

SELECT 'm181_murabaha_baskets' AS table_name FROM DUAL;

@@dfn_ntp.m181_murabaha_baskets.tab.sql

SELECT 'm182_murabaha_bskt_composition' AS table_name FROM DUAL;

@@dfn_ntp.m182_murabaha_bskt_composition.tab.sql

SELECT 't48_tax_invoices' AS table_name FROM DUAL;

@@dfn_ntp.t48_tax_invoices.tab.sql

SELECT 't49_tax_invoice_details' AS table_name FROM DUAL;

@@dfn_ntp.t49_tax_invoice_details.tab.sql

SELECT 'u56_option_base_trade_mapping' AS table_name FROM DUAL;

@@dfn_ntp.u56_option_base_trade_mapping.tab.sql

SELECT 'dfn_ntp.t71_otp' AS table_name FROM DUAL;

@@dfn_ntp.t71_otp.tab.sql

SELECT 'dfn_ntp.m183_om_questionnaire' AS table_name FROM DUAL;

@@dfn_ntp.m183_om_questionnaire.tab.sql

SELECT 'dfn_ntp.u57_ipo_customers' AS table_name FROM DUAL;

@@dfn_ntp.u57_ipo_customers.tab.sql

SELECT 'dfn_ntp.t73_om_margin_trading_request' AS table_name FROM DUAL;

@@dfn_ntp.t73_om_margin_trading_request.tab.sql

SELECT 'dfn_ntp.t74_om_margin_req_murabh_bskt' AS table_name FROM DUAL;

@@dfn_ntp.t74_om_margin_req_murabh_bskt.tab.sql

SELECT 'dfn_ntp.u25_om_mar_req_questionnaire' AS table_name FROM DUAL;

@@dfn_ntp.u25_om_mar_req_questionnaire.tab.sql

SELECT 'dfn_ntp.m184_channel_wise_symbol_restr' AS table_name FROM DUAL;

@@dfn_ntp.m184_channel_wise_symbol_restr.tab.sql

SELECT 'dfn_ntp.t75_murabaha_contracts' AS table_name FROM DUAL;

@@dfn_ntp.t75_murabaha_contracts.tab.sql

SELECT 'dfn_ntp.t76_murabaha_contract_comp' AS table_name FROM DUAL;

@@dfn_ntp.t76_murabaha_contract_comp.tab.sql

SELECT 'dfn_ntp.a15_falcon_messages' AS table_name FROM DUAL;

@@dfn_ntp.a15_falcon_messages.tab.sql

SELECT 'dfn_ntp.a22_insert_new_symbol_audit' AS table_name FROM DUAL;

@@dfn_ntp.a22_insert_new_symbol_audit.tab.sql

SELECT 'dfn_ntp.m66_institute_level_documents' AS table_name FROM DUAL;

@@dfn_ntp.m66_institute_level_documents.tab.sql

SELECT 'dfn_ntp.h13_interest_indices_history' AS table_name FROM DUAL;

@@dfn_ntp.h13_interest_indices_history.tab.sql

SELECT 'e_tmpl_6_customer_default' AS table_name FROM DUAL;

@@dfn_ntp.e_tmpl_6_customer_default.tab.sql

SELECT 'dfn_ntp.t77_system_notify_eventdata' AS table_name FROM DUAL;

@@dfn_ntp.t77_system_notify_eventdata.tab.sql

SELECT 'dfn_ntp.v14_controllable_features' AS table_name FROM DUAL;

@@dfn_ntp.v14_controllable_features.tab.sql

SELECT 'dfn_ntp.m501_intgrtn_srvc_data_b' AS table_name FROM DUAL;

@@dfn_ntp.m501_intgrtn_srvc_data_b.tab.sql

SELECT 'dfn_ntp.h24_gl_cash_account_summary' AS table_name FROM DUAL;

@@dfn_ntp.h24_gl_cash_account_summary.tab.sql

SELECT 'dfn_ntp.v37_trading_acc_types' AS table_name FROM DUAL;

@@dfn_ntp.v37_trading_acc_types.tab.sql

SELECT 'dfn_ntp.m186_exg_trading_acc_types' AS table_name FROM DUAL;

@@dfn_ntp.m186_exg_trading_acc_types.tab.sql

SELECT 'h26_daily_status' AS table_name FROM DUAL;

@@dfn_ntp.h26_daily_status.tab.sql

SELECT 'm40_file_processing_job_config' AS table_name FROM DUAL;

@@dfn_ntp.m40_file_processing_job_config.tab.sql

SELECT 't80_file_processing_batches' AS table_name FROM DUAL;

@@dfn_ntp.t80_file_processing_batches.tab.sql

SELECT 't81_file_processing_log' AS table_name FROM DUAL;

@@dfn_ntp.t81_file_processing_log.tab.sql

SELECT 'dfn_ntp.t83_exec_broker_wise_settlmnt' AS table_name FROM DUAL;

@@dfn_ntp.t83_exec_broker_wise_settlmnt.tab.sql

@@dfn_ntp.t84_exec_broker_settlemnt_log.tab.sql

SELECT 'dfn_ntp.t84_exec_broker_settlemnt_log' AS table_name FROM DUAL;


SELECT 'm185_custody_excb_cash_account' AS table_name FROM DUAL;

@@dfn_ntp.m185_custody_excb_cash_account.tab.sql

SELECT 't78_custodian_wise_settlements' AS table_name FROM DUAL;

@@dfn_ntp.t78_custodian_wise_settlements.tab.sql

SELECT 't79_custody_excb_cash_acnt_log' AS table_name FROM DUAL;

@@dfn_ntp.t79_custody_excb_cash_acnt_log.tab.sql

SELECT 't82_custodian_settlements_log' AS table_name FROM DUAL;

@@dfn_ntp.t82_custodian_settlements_log.tab.sql

SELECT 'dfn_ntp.u42_notification_levels' AS table_name FROM DUAL;

@@dfn_ntp.u42_notification_levels.tab.sql

SELECT 'dfn_ntp.m187_interest_indices' AS table_name FROM DUAL;

@@dfn_ntp.m187_interest_indices.tab.sql

SELECT 'dfn_ntp.e_tmpl_7_price_user' AS table_name FROM DUAL;

@@dfn_ntp.e_tmpl_7_price_user.tab.sql

SELECT 'dfn_ntp.e_tmpl_8_int_indices_default' AS table_name FROM DUAL;

@@dfn_ntp.e_tmpl_8_int_indices_default.tab.sql

SELECT 'dfn_ntp.e_tmpl_1_weekly' AS table_name FROM DUAL;

@@dfn_ntp.e_tmpl_1_weekly.tab.sql

SELECT 'dfn_ntp.m41_file_processing_job_para' AS table_name FROM DUAL;

@@dfn_ntp.m41_file_processing_job_para.tab.sql

SELECT 'dfn_ntp.m42_file_processing_tables' AS table_name FROM DUAL;

@@dfn_ntp.m42_file_processing_tables.tab.sql

SELECT 'dfn_ntp.m48_file_processing_columns' AS table_name FROM DUAL;

@@dfn_ntp.m48_file_processing_columns.tab.sql

SELECT 'dfn_ntp.m48_file_processing_columns' AS table_name FROM DUAL;

@@dfn_ntp.t85_negotiated_deal.tab.sql

SELECT 'dfn_ntp.v19_board_status' AS table_name FROM DUAL;

@@dfn_ntp.v19_board_status.tab.sql

SELECT 'dfn_ntp.m54_boards' AS table_name FROM DUAL;

@@dfn_ntp.m54_boards.tab.sql

SELECT 'dfn_ntp.m59_exchange_board_status' AS table_name FROM DUAL;

@@dfn_ntp.m59_exchange_board_status.tab.sql

SELECT 'dfn_ntp.m30_ex_board_permissions' AS table_name FROM DUAL;

@@dfn_ntp.m30_ex_board_permissions.tab.sql

SELECT 'dfn_ntp.m32_ex_board_status_tif' AS table_name FROM DUAL;

@@dfn_ntp.m32_ex_board_status_tif.tab.sql

SELECT 'dfn_ntp.m86_ex_clearing_accounts' AS table_name FROM DUAL;

@@dfn_ntp.m86_ex_clearing_accounts.tab.sql

SELECT 'dfn_ntp.m89_customer_category' AS table_name FROM DUAL;

@@dfn_ntp.m89_customer_category.tab.sql

SELECT 'dfn_ntp.t88_exec_broker_settlemnt_log' AS table_name FROM DUAL;

@@dfn_ntp.t88_exec_broker_settlemnt_log.tab.sql

SELECT 'dfn_ntp.t84_customer_f' AS table_name FROM DUAL;

@@dfn_ntp.t84_customer_f.tab.sql

SELECT 'h50_daily_portfolio_value_b' AS table_name FROM DUAL;

@@dfn_ntp.h50_daily_portfolio_value_b.tab.sql

SELECT 'm502_invest_center_b' AS table_name FROM DUAL;

@@dfn_ntp.m502_invest_center_b.tab.sql

SELECT 'a50_integration_messages_b' AS table_name FROM DUAL;

@@dfn_ntp.a50_integration_messages_b.tab.sql

SELECT 'dfn_ntp.e100_process_deposit_txn_c' AS table_name FROM DUAL;

@@dfn_ntp.e100_process_deposit_txn_c.tab.sql

SELECT 'dfn_ntp.f01_falcon_servers' AS table_name FROM DUAL;

@@dfn_ntp.f01_falcon_servers.tab.sql

SELECT 'dfn_ntp.f02_falcon_processes' AS table_name FROM DUAL;

@@dfn_ntp.f02_falcon_processes.tab.sql

SELECT 'dfn_ntp.f03_falcon_controllers' AS table_name FROM DUAL;

@@dfn_ntp.f03_falcon_controllers.tab.sql

SELECT 'dfn_ntp.f04_falcon_log_files' AS table_name FROM DUAL;

@@dfn_ntp.f04_falcon_log_files.tab.sql

SELECT 'dfn_ntp.f05_falcon_component_info' AS table_name FROM DUAL;

@@dfn_ntp.f05_falcon_component_info.tab.sql

SELECT 'dfn_ntp.t86_bulk_cash_holding_process' AS table_name FROM DUAL;

@@dfn_ntp.t86_bulk_cash_holding_process.tab.sql

SELECT 'dfn_ntp.t87_bulk_cash_adjustments' AS table_name FROM DUAL;

@@dfn_ntp.t87_bulk_cash_adjustments.tab.sql

SELECT 'dfn_ntp.m1001_sukuk_coupon_payment' AS table_name FROM DUAL;

@@dfn_ntp.m1001_sukuk_coupon_payment.tab.sql

SELECT 't1000_cus_data_change_req_b' AS table_name FROM DUAL;

@@dfn_ntp.t1000_cus_data_change_req_b.tab.sql

SELECT 'dfn_ntp.m189_limit_adjust_requests' AS table_name FROM DUAL;

@@dfn_ntp.m189_limit_adjust_requests.tab.sql

SELECT 'dfn_ntp.m188_order_limit_group_slabs' AS table_name FROM DUAL;

@@dfn_ntp.m188_order_limit_group_slabs.tab.sql

SELECT 'dfn_ntp.t89_channel_cum_order_values' AS table_name FROM DUAL;

@@dfn_ntp.t89_channel_cum_order_values.tab.sql

SELECT 'dfn_ntp.h101_daily_owned_holding_b' AS table_name FROM DUAL;

@@dfn_ntp.h101_daily_owned_holding_b.tab.sql

SELECT 'dfn_ntp.h102_daily_other_owned_hld_b' AS table_name FROM DUAL;

@@dfn_ntp.h102_daily_other_owned_hld_b.tab.sql

SELECT 'dfn_ntp.m1002_cum_annual_perf_b' AS table_name FROM DUAL;

@@dfn_ntp.m1002_cum_annual_perf_b.tab.sql

SELECT 'dfn_ntp.m503_top_holding_sector_b' AS table_name FROM DUAL;

@@dfn_ntp.m503_top_holding_sector_b.tab.sql

SELECT 'dfn_ntp.t1001_order_references_b' AS table_name FROM DUAL;

@@dfn_ntp.t1001_order_references_b.tab.sql

SELECT 'dfn_ntp.u59_trading_acc_fix_logins' AS table_name FROM DUAL;

@@dfn_ntp.u59_trading_acc_fix_logins.tab.sql

SELECT 'dfn_ntp.t90_murabaha_amortize' AS table_name FROM DUAL;

@@dfn_ntp.t90_murabaha_amortize.tab.sql

SELECT 'dfn_ntp.m144_subscription_products' AS table_name FROM DUAL;

@@dfn_ntp.m144_subscription_products.tab.sql

SELECT 'dfn_ntp.m91_file_processing_validation' AS table_name FROM DUAL;

@@dfn_ntp.m91_file_processing_validation.tab.sql

SELECT 'dfn_ntp.t91_eod_reconciliation' AS table_name FROM DUAL;

@@dfn_ntp.t91_eod_reconciliation.tab.sql

SELECT 'dfn_ntp.m190_exchange_comm_types' AS table_name FROM DUAL;

@@dfn_ntp.m190_exchange_comm_types.tab.sql

SELECT 'dfn_ntp.a23_expirable_symbol_log' AS table_name FROM DUAL;

@@dfn_ntp.a23_expirable_symbol_log.tab.sql

SELECT 'dfn_ntp.m505_product_wise_waiveoff_c' AS table_name FROM DUAL;

@@dfn_ntp.m505_product_wise_waiveoff_c.tab.sql

SPOOL OFF
