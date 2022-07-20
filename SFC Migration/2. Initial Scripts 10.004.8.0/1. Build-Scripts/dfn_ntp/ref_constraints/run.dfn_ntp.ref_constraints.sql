SPOOL log.run.dfn_ntp.ref_constraint REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'u52_poa_trad_privilege_pending' AS table_name FROM DUAL;

@@dfn_ntp.u52_poa_trad_privilege_pending.ref.sql

SELECT 'u41_notification_configuration' AS table_name FROM DUAL;

@@dfn_ntp.u41_notification_configuration.ref.sql

SELECT 'm95_settlement_calendar_config' AS table_name FROM DUAL;

@@dfn_ntp.m95_settlement_calendar_config.ref.sql

SELECT 'u21_login_trading_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u21_login_trading_restriction.ref.sql

SELECT 'm83_approval_required_columns' AS table_name FROM DUAL;

@@dfn_ntp.m83_approval_required_columns.ref.sql

SELECT 'm79_pending_symbl_mrg_request' AS table_name FROM DUAL;

@@dfn_ntp.m79_pending_symbl_mrg_request.ref.sql

SELECT 'u08_customer_beneficiary_acc' AS table_name FROM DUAL;

@@dfn_ntp.u08_customer_beneficiary_acc.ref.sql

SELECT 't04_disable_exchange_acc_req' AS table_name FROM DUAL;

@@dfn_ntp.t04_disable_exchange_acc_req.ref.sql

SELECT 'm84_approval_exclude_columns' AS table_name FROM DUAL;

@@dfn_ntp.m84_approval_exclude_columns.ref.sql

SELECT 'm69_institute_trading_limits' AS table_name FROM DUAL;

@@dfn_ntp.m69_institute_trading_limits.ref.sql

SELECT 'm44_institution_entitlements' AS table_name FROM DUAL;

@@dfn_ntp.m44_institution_entitlements.ref.sql

SELECT 'm109_customer_family_members' AS table_name FROM DUAL;

@@dfn_ntp.m109_customer_family_members.ref.sql

SELECT 'u54_customer_external_login' AS table_name FROM DUAL;

@@dfn_ntp.u54_customer_external_login.ref.sql

SELECT 'u23_customer_margin_product' AS table_name FROM DUAL;

@@dfn_ntp.u23_customer_margin_product.ref.sql

SELECT 'u05_customer_identification' AS table_name FROM DUAL;

@@dfn_ntp.u05_customer_identification.ref.sql

SELECT 'm139_gl_column_destribution' AS table_name FROM DUAL;

@@dfn_ntp.m139_gl_column_destribution.ref.sql

SELECT 'm138_gl_record_destribution' AS table_name FROM DUAL;

@@dfn_ntp.m138_gl_record_destribution.ref.sql

SELECT 'm120_sharia_compliant_group' AS table_name FROM DUAL;

@@dfn_ntp.m120_sharia_compliant_group.ref.sql

SELECT 'u51_poa_symbol_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u51_poa_symbol_restriction.ref.sql

SELECT 'u49_poa_trading_privileges' AS table_name FROM DUAL;

@@dfn_ntp.u49_poa_trading_privileges.ref.sql

SELECT 't29_gl_column_wise_entries' AS table_name FROM DUAL;

@@dfn_ntp.t29_gl_column_wise_entries.ref.sql

SELECT 't28_gl_record_wise_entries' AS table_name FROM DUAL;

@@dfn_ntp.t28_gl_record_wise_entries.ref.sql

SELECT 'm71_institute_restrictions' AS table_name FROM DUAL;

@@dfn_ntp.m71_institute_restrictions.ref.sql

SELECT 'm59_exchange_market_status' AS table_name FROM DUAL;

@@dfn_ntp.m59_exchange_market_status.ref.sql

SELECT 'm137_gl_event_data_sources' AS table_name FROM DUAL;

@@dfn_ntp.m137_gl_event_data_sources.ref.sql

SELECT 'm134_gl_account_categories' AS table_name FROM DUAL;

@@dfn_ntp.m134_gl_account_categories.ref.sql

SELECT 'v34_price_instrument_type' AS table_name FROM DUAL;

@@dfn_ntp.v34_price_instrument_type.ref.sql

SELECT 'u48_corp_customer_contact' AS table_name FROM DUAL;

@@dfn_ntp.u48_corp_customer_contact.ref.sql

SELECT 'm74_margin_interest_group' AS table_name FROM DUAL;

@@dfn_ntp.m74_margin_interest_group.ref.sql

SELECT 'a01_db_jobs_execution_log' AS table_name FROM DUAL;

@@dfn_ntp.a01_db_jobs_execution_log.ref.sql

SELECT 'm78_symbol_marginability' AS table_name FROM DUAL;

@@dfn_ntp.m78_symbol_marginability.ref.sql

SELECT 'm57_exchange_order_types' AS table_name FROM DUAL;

@@dfn_ntp.m57_exchange_order_types.ref.sql

SELECT 'm10_relationship_manager' AS table_name FROM DUAL;

@@dfn_ntp.m10_relationship_manager.ref.sql

SELECT 'u12_trading_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u12_trading_restriction.ref.sql

SELECT 'm12_employee_department' AS table_name FROM DUAL;

@@dfn_ntp.m12_employee_department.ref.sql

SELECT 'u45_uploaded_doc_pages' AS table_name FROM DUAL;

@@dfn_ntp.u45_uploaded_doc_pages.ref.sql

SELECT 'u44_uploaded_documents' AS table_name FROM DUAL;

@@dfn_ntp.u44_uploaded_documents.ref.sql

SELECT 'u04_cma_identification' AS table_name FROM DUAL;

@@dfn_ntp.u04_cma_identification.ref.sql

SELECT 't23_share_txn_requests' AS table_name FROM DUAL;

@@dfn_ntp.t23_share_txn_requests.ref.sql

SELECT 'm65_saibor_basis_rates' AS table_name FROM DUAL;

@@dfn_ntp.m65_saibor_basis_rates.ref.sql

SELECT 'u47_power_of_attorney' AS table_name FROM DUAL;

@@dfn_ntp.u47_power_of_attorney.ref.sql

SELECT 'u10_login_trading_acc' AS table_name FROM DUAL;

@@dfn_ntp.u10_login_trading_acc.ref.sql

SELECT 'm105_other_brokerages' AS table_name FROM DUAL;

@@dfn_ntp.m105_other_brokerages.ref.sql

SELECT 'u11_cash_restriction' AS table_name FROM DUAL;

@@dfn_ntp.u11_cash_restriction.ref.sql

SELECT 'm23_commission_slabs' AS table_name FROM DUAL;

@@dfn_ntp.m23_commission_slabs.ref.sql

SELECT 'u07_trading_account' AS table_name FROM DUAL;

@@dfn_ntp.u07_trading_account.ref.sql

SELECT 'm73_margin_products' AS table_name FROM DUAL;

@@dfn_ntp.m73_margin_products.ref.sql

SELECT 'u53_process_detail' AS table_name FROM DUAL;

@@dfn_ntp.u53_process_detail.ref.sql

SELECT 'u30_login_cash_acc' AS table_name FROM DUAL;

@@dfn_ntp.u30_login_cash_acc.ref.sql

SELECT 'u09_customer_login' AS table_name FROM DUAL;

@@dfn_ntp.u09_customer_login.ref.sql

SELECT 'm14_issue_location' AS table_name FROM DUAL;

@@dfn_ntp.m14_issue_location.ref.sql

SELECT 'm119_sharia_symbol' AS table_name FROM DUAL;

@@dfn_ntp.m119_sharia_symbol.ref.sql

SELECT 'm93_bank_accounts' AS table_name FROM DUAL;

@@dfn_ntp.m93_bank_accounts.ref.sql

SELECT 'm17_bank_branches' AS table_name FROM DUAL;

@@dfn_ntp.m17_bank_branches.ref.sql

SELECT 'm08_trading_group' AS table_name FROM DUAL;

@@dfn_ntp.m08_trading_group.ref.sql

SELECT 'm04_currency_rate' AS table_name FROM DUAL;

@@dfn_ntp.m04_currency_rate.ref.sql

SELECT 'v04_entitlements' AS table_name FROM DUAL;

@@dfn_ntp.v04_entitlements.ref.sql

SELECT 'u06_cash_account' AS table_name FROM DUAL;

@@dfn_ntp.u06_cash_account.ref.sql

SELECT 'm58_exchange_tif' AS table_name FROM DUAL;

@@dfn_ntp.m58_exchange_tif.ref.sql

SELECT 'm135_gl_accounts' AS table_name FROM DUAL;

@@dfn_ntp.m135_gl_accounts.ref.sql

SELECT 'v31_restriction' AS table_name FROM DUAL;

@@dfn_ntp.v31_restriction.ref.sql

SELECT 't27_gl_batches' AS table_name FROM DUAL;

@@dfn_ntp.t27_gl_batches.ref.sql

SELECT 'm02_institute' AS table_name FROM DUAL;

@@dfn_ntp.m02_institute.ref.sql

SELECT 'm01_exchanges' AS table_name FROM DUAL;

@@dfn_ntp.m01_exchanges.ref.sql

SELECT 'u17_employee' AS table_name FROM DUAL;

@@dfn_ntp.u17_employee.ref.sql

SELECT 'u01_customer' AS table_name FROM DUAL;

@@dfn_ntp.u01_customer.ref.sql

SELECT 'm96_holidays' AS table_name FROM DUAL;

@@dfn_ntp.m96_holidays.ref.sql

SELECT 'm110_reasons' AS table_name FROM DUAL;

@@dfn_ntp.m110_reasons.ref.sql

SELECT 'm07_location' AS table_name FROM DUAL;

@@dfn_ntp.m07_location.ref.sql

SELECT 'm63_sectors' AS table_name FROM DUAL;

@@dfn_ntp.m63_sectors.ref.sql

SELECT 'm20_symbol' AS table_name FROM DUAL;

@@dfn_ntp.m20_symbol.ref.sql

SELECT 'a06_audit' AS table_name FROM DUAL;

@@dfn_ntp.a06_audit.ref.sql

SELECT 'm06_city' AS table_name FROM DUAL;

@@dfn_ntp.m06_city.ref.sql

SELECT 'm149_notify_templates' AS table_name FROM DUAL;

@@dfn_ntp.m149_notify_templates.ref.sql

SELECT 'm174_data_loader_field_map' AS table_name FROM DUAL;

@@dfn_ntp.m174_data_loader_field_map.ref.sql

SELECT 'm183_om_questionnaire' AS table_name FROM DUAL;

@@dfn_ntp.m183_om_questionnaire.ref.sql

SELECT 't77_system_notify_eventdata' AS table_name FROM DUAL;

@@dfn_ntp.t77_system_notify_eventdata.ref.sql

SELECT 'm59_exchange_board_status' AS table_name FROM DUAL;

@@dfn_ntp.m59_exchange_board_status.tab.sql

SELECT 'f02_falcon_processes' AS table_name FROM DUAL;

@@dfn_ntp.f02_falcon_processes.ref.sql

SELECT 'f04_falcon_log_files' AS table_name FROM DUAL;

@@dfn_ntp.f04_falcon_log_files.ref.sql

SELECT 'f05_falcon_component_info' AS table_name FROM DUAL;

@@dfn_ntp.f05_falcon_component_info.ref.sql

SELECT 'm505_product_wise_waiveoff_c' AS table_name FROM DUAL;

@@dfn_ntp.m505_product_wise_waiveoff_c.ref.sql

SPOOL OFF
