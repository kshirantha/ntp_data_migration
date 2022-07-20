SPOOL log.run.dfn_ntp.master_data REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'v00_sys_config' AS script_name FROM DUAL;

@@dfn_ntp.v00_sys_config.dat.sql

SELECT 'v00_sys_config_broker_wise' AS script_name FROM DUAL;

@@dfn_ntp.v00_sys_config_broker_wise.dat.sql

SELECT 'v01_system_master_data' AS script_name FROM DUAL;

@@dfn_ntp.v01_system_master_data.dat.sql

SELECT 'v02_ent_sensitive_levels' AS script_name FROM DUAL;

@@dfn_ntp.v02_ent_sensitive_levels.dat.sql

SELECT 'v03_entitlement_type' AS script_name FROM DUAL;

@@dfn_ntp.v03_entitlement_type.dat.sql

SELECT 'v04_entitlements' AS script_name FROM DUAL;

@@dfn_ntp.v04_entitlements.dat.sql

SELECT 'v06_order_type' AS script_name FROM DUAL;

@@dfn_ntp.v06_order_type.dat.sql

SELECT 'v07_db_jobs' AS script_name FROM DUAL;

@@dfn_ntp.v07_db_jobs.dat.sql

SELECT 'v08_sub_asset_type' AS script_name FROM DUAL;

@@dfn_ntp.v08_sub_asset_type.dat.sql

SELECT 'v09_instrument_types' AS script_name FROM DUAL;

@@dfn_ntp.v09_instrument_types.dat.sql

SELECT 'v10_tif' AS script_name FROM DUAL;

@@dfn_ntp.v10_tif.dat.sql

SELECT 'v11_symbol_settle_category' AS script_name FROM DUAL;

@@dfn_ntp.v11_symbol_settle_category.dat.sql

SELECT 'v12_trade_config_format' AS script_name FROM DUAL;

@@dfn_ntp.v12_trade_config_format.dat.sql

SELECT 'v19_market_status' AS script_name FROM DUAL;

@@dfn_ntp.v19_market_status.dat.sql

SELECT 'v20_default_master_data' AS script_name FROM DUAL;

@@dfn_ntp.v20_default_master_data.dat.sql

SELECT 'v22_symbol_status' AS script_name FROM DUAL;

@@dfn_ntp.v22_symbol_status.dat.sql

SELECT 'v23_price_update_codes' AS script_name FROM DUAL;

@@dfn_ntp.v23_price_update_codes.dat.sql

SELECT 'v24_industry_codes' AS script_name FROM DUAL;

@@dfn_ntp.v24_industry_codes.dat.sql

SELECT 'v25_payment_types' AS script_name FROM DUAL;

@@dfn_ntp.v25_payment_types.dat.sql

SELECT 'v26_interest_day_basis' AS script_name FROM DUAL;

@@dfn_ntp.v26_interest_day_basis.dat.sql

SELECT 'v27_bond_ratings' AS script_name FROM DUAL;

@@dfn_ntp.v27_bond_ratings.dat.sql

SELECT 'v28_document_types' AS script_name FROM DUAL;

@@dfn_ntp.v28_document_types.dat.sql

SELECT 'v29_order_channel' AS script_name FROM DUAL;

@@dfn_ntp.v29_order_channel.dat.sql

SELECT 'v30_order_status' AS script_name FROM DUAL;

@@dfn_ntp.v30_order_status.dat.sql

SELECT 'm127_reason_types' AS script_name FROM DUAL;

@@dfn_ntp.m127_reason_types.dat.sql

SELECT 'v31_restriction' AS script_name FROM DUAL;

@@dfn_ntp.v31_restriction.dat.sql

SELECT 'v32_language_dictionary' AS script_name FROM DUAL;

@@dfn_ntp.v32_language_dictionary.dat.sql

SELECT 'v33_corporate_action_types' AS script_name FROM DUAL;

@@dfn_ntp.v33_corporate_action_types.dat.sql

SELECT 'v34_price_instrument_type' AS script_name FROM DUAL;

@@dfn_ntp.v34_price_instrument_type.dat.sql

SELECT 'v35_products' AS script_name FROM DUAL;

@@dfn_ntp.v35_products.dat.sql

SELECT 'v36_margin_product_equation' AS script_name FROM DUAL;

@@dfn_ntp.v36_margin_product_equation.dat.sql

SELECT 'm150_broker' AS script_name FROM DUAL;

@@dfn_ntp.m150_broker.dat.sql

SELECT 'm35_customer_settl_group' AS script_name FROM DUAL;

@@dfn_ntp.m35_customer_settl_group.dat.sql

SELECT 'm55_price_block_types' AS script_name FROM DUAL;

@@dfn_ntp.m55_price_block_types.dat.sql

SELECT 'm56_password_complexity_levels' AS script_name FROM DUAL;

@@dfn_ntp.m56_password_complexity_levels.dat.sql

SELECT 'm03_currency' AS script_name FROM DUAL;

@@dfn_ntp.m03_currency.dat.sql

SELECT 'm05_country' AS script_name FROM DUAL;

@@dfn_ntp.m05_country.dat.sql

SELECT 'm06_city' AS script_name FROM DUAL;

@@dfn_ntp.m06_city.dat.sql

SELECT 'm02_institute' AS script_name FROM DUAL;

@@dfn_ntp.m02_institute.dat.sql

SELECT 'm11_employee_type' AS script_name FROM DUAL;

@@dfn_ntp.m11_employee_type.dat.sql

SELECT 'm15_identity_type' AS script_name FROM DUAL;

@@dfn_ntp.m15_identity_type.dat.sql

SELECT 'm12_employee_department' AS script_name FROM DUAL;

@@dfn_ntp.m12_employee_department.dat.sql

SELECT 'm07_location' AS script_name FROM DUAL;

@@dfn_ntp.m07_location.dat.sql

SELECT 'u17_employee' AS script_name FROM DUAL;

@@dfn_ntp.u17_employee.dat.sql

SELECT 'm33_nationality_category' AS script_name FROM DUAL;

@@dfn_ntp.m33_nationality_category.dat.sql

SELECT 'm39_price_qty_factors' AS script_name FROM DUAL;

@@dfn_ntp.m39_price_qty_factors.dat.sql

SELECT 'm44_institution_entitlements' AS script_name FROM DUAL;

@@dfn_ntp.m44_institution_entitlements.dat.sql

SELECT 'm45_permission_groups' AS script_name FROM DUAL;

@@dfn_ntp.m45_permission_groups.dat.sql

SELECT 'm46_permission_grp_entlements' AS script_name FROM DUAL;

@@dfn_ntp.m46_permission_grp_entlements.dat.sql

SELECT 'm47_permission_grp_users' AS script_name FROM DUAL;

@@dfn_ntp.m47_permission_grp_users.dat.sql

SELECT 'm52_notification_group' AS script_name FROM DUAL;

@@dfn_ntp.m52_notification_group.dat.sql

SELECT 'm53_approval_required_tables' AS script_name FROM DUAL;

@@dfn_ntp.m53_approval_required_tables.dat.sql

SELECT 'm61_uploadable_documents' AS script_name FROM DUAL;

@@dfn_ntp.m61_uploadable_documents.dat.sql

SELECT 'm64_saibor_basis_durations' AS script_name FROM DUAL;

@@dfn_ntp.m64_saibor_basis_durations.dat.sql

SELECT 'm80_margin_products_equation' AS script_name FROM DUAL;

@@dfn_ntp.m80_margin_products_equation.dat.sql

SELECT 'm81_audit_category' AS script_name FROM DUAL;

@@dfn_ntp.m81_audit_category.dat.sql

SELECT 'm82_audit_activity' AS script_name FROM DUAL;

@@dfn_ntp.m82_audit_activity.dat.sql

SELECT 'm85_approval_columns' AS script_name FROM DUAL;

@@dfn_ntp.m85_approval_columns.dat.sql

SELECT 'm83_approval_required_columns' AS script_name FROM DUAL;

@@dfn_ntp.m83_approval_required_columns.dat.sql

SELECT 'm84_approval_exclude_columns' AS script_name FROM DUAL;

@@dfn_ntp.m84_approval_exclude_columns.dat.sql

SELECT 'm88_function_approval' AS script_name FROM DUAL;

@@dfn_ntp.m88_function_approval.dat.sql

SELECT 'm90_region' AS script_name FROM DUAL;

@@dfn_ntp.m90_region.dat.sql

SELECT 'm92_oms_cache_store_map' AS script_name FROM DUAL;

@@dfn_ntp.m92_oms_cache_store_map.dat.sql

SELECT 'm97_transaction_codes' AS script_name FROM DUAL;

@@dfn_ntp.m97_transaction_codes.dat.sql

SELECT 'm99_notification_items' AS script_name FROM DUAL;

@@dfn_ntp.m99_notification_items.dat.sql

SELECT 'm100_notification_sub_items' AS script_name FROM DUAL;

@@dfn_ntp.m100_notification_sub_items.dat.sql

SELECT 'm101_notification_channels' AS script_name FROM DUAL;

@@dfn_ntp.m101_notification_channels.dat.sql

SELECT 'm102_notification_schedule' AS script_name FROM DUAL;

@@dfn_ntp.m102_notification_schedule.dat.sql

SELECT 'm103_notify_subitem_schedule' AS script_name FROM DUAL;

@@dfn_ntp.m103_notify_subitem_schedule.dat.sql

SELECT 'm106_client_risk_assessment' AS script_name FROM DUAL;

@@dfn_ntp.m106_client_risk_assessment.dat.sql

SELECT 'm107_notification_master' AS script_name FROM DUAL;

@@dfn_ntp.m107_notification_master.dat.sql

SELECT 'm111_messages' AS script_name FROM DUAL;

@@dfn_ntp.m111_messages.dat.sql

SELECT 'm112_fatca_entities' AS script_name FROM DUAL;

@@dfn_ntp.m112_fatca_entities.dat.sql

SELECT 'm113_fatca_institutions' AS script_name FROM DUAL;

@@dfn_ntp.m113_fatca_institutions.dat.sql

SELECT 'm123_master_data_versions' AS script_name FROM DUAL;

@@dfn_ntp.m123_master_data_versions.dat.sql

SELECT 'm124_commission_types' AS script_name FROM DUAL;

@@dfn_ntp.m124_commission_types.dat.sql

SELECT 'm126_rules' AS script_name FROM DUAL;

@@dfn_ntp.m126_rules.dat.sql

SELECT 'm128_marital_status' AS script_name FROM DUAL;

@@dfn_ntp.m128_marital_status.dat.sql

SELECT 'm130_titles' AS script_name FROM DUAL;

@@dfn_ntp.m130_titles.dat.sql

SELECT 'm145_notify_event_cat' AS script_name FROM DUAL;

@@dfn_ntp.m145_notify_event_cat.dat.sql

SELECT 'm146_notify_tag_master' AS script_name FROM DUAL;

@@dfn_ntp.m146_notify_tag_master.dat.sql

SELECT 'm147_notify_event_cat_tag_map' AS script_name FROM DUAL;

@@dfn_ntp.m147_notify_event_cat_tag_map.dat.sql

SELECT 'm148_notify_events_master' AS script_name FROM DUAL;

@@dfn_ntp.m148_notify_events_master.dat.sql

SELECT 'm149_notify_templates' AS script_name FROM DUAL;

@@dfn_ntp.m149_notify_templates.dat.sql

SELECT 'm179_feature_channel_restrict' AS script_name FROM DUAL;

@@dfn_ntp.m179_feature_channel_restrict.dat.sql

SELECT 'u53_process_detail' AS script_name FROM DUAL;

@@dfn_ntp.u53_process_detail.dat.sql

SELECT 'z01_forms_m' AS script_name FROM DUAL;

@@dfn_ntp.z01_forms_m.dat.sql

SELECT 'z02_forms_cols' AS script_name FROM DUAL;

@@dfn_ntp.z02_forms_cols.dat.sql

SELECT 'z03_forms_menu' AS script_name FROM DUAL;

@@dfn_ntp.z03_forms_menu.dat.sql

SELECT 'z04_forms_color' AS script_name FROM DUAL;

@@dfn_ntp.z04_forms_color.dat.sql

SELECT 'z07_menu' AS script_name FROM DUAL;

@@dfn_ntp.z07_menu.dat.sql

SELECT 'z01_forms_m_c' AS script_name FROM DUAL;

@@dfn_ntp.z01_forms_m_c.dat.sql

SELECT 'z02_forms_cols_c' AS script_name FROM DUAL;

@@dfn_ntp.z02_forms_cols_c.dat.sql

SELECT 'z03_forms_menu_c' AS script_name FROM DUAL;

@@dfn_ntp.z03_forms_menu_c.dat.sql

SELECT 'z04_forms_color_c' AS script_name FROM DUAL;

@@dfn_ntp.z04_forms_color_c.dat.sql

SELECT 'z07_menu_c' AS script_name FROM DUAL;

@@dfn_ntp.z07_menu_c.dat.sql

SELECT 'z08_version' AS script_name FROM DUAL;

@@dfn_ntp.z08_version.dat.sql

SELECT 'app_seq_store' AS script_name FROM DUAL;

@@dfn_ntp.app_seq_store.dat.sql

SELECT 'v19_board_status' AS script_name FROM DUAL;

@@dfn_ntp.v19_board_status.dat.sql

SELECT 'v37_trading_acc_types' AS script_name FROM DUAL;

@@dfn_ntp.v37_trading_acc_types.dat.sql

SELECT 'm501_intgrtn_srvc_data_b' AS script_name FROM DUAL;

@@dfn_ntp.m501_intgrtn_srvc_data_b.dat.sql

SPOOL OFF
