CREATE OR REPLACE FORCE VIEW dfn_ntp.trading_account_list
(
    u07_id,
    u07_customer_id_u01,
    u07_cash_account_id_u06,
    u07_exchange_code_m01,
    u07_exchange_id_m01,
    u07_display_name_u06,
    u07_customer_no_u01,
    u07_display_name_u01,
    u07_default_id_no_u01,
    u07_is_default,
    u01_external_ref_no,
    u01_nationality_id_m05,
    u01_default_id_no,
    u07_is_default_txt,
    is_default,
    u07_type,
    u07_type_txt,
    u07_trading_enabled,
    u07_trading_enabled_txt,
    u07_sharia_compliant,
    u07_sharia_compliant_txt,
    u07_trading_group_id_m08,
    m08_name,
    u07_created_by_id_u17,
    created_by,
    u07_created_date,
    u07_institute_id_m02,
    institute_name,
    u07_status_id_v01,
    u07_discount_prec_from_date,
    u07_discount_prec_to_date,
    status_description,
    v01_description_lang,
    u07_commission_group_id_m22,
    commition_group,
    u07_discount_percentage,
    u07_commission_dis_grp_id_m24,
    commision_discount_group,
    u07_modified_by_id_u17,
    modified_by,
    u07_modified_date,
    u07_status_changed_by_id_u17,
    status_changed_by,
    u07_status_changed_date,
    u07_exe_broker_id_m26,
    executing_broker,
    u07_exchange_account_no,
    u07_display_name,
    u07_custodian_id_m26,
    custodian,
    u07_cust_settle_group_id_m35,
    settle_group,
    u07_pending_restriction,
    u07_trade_rejection_enabled,
    trade_rejection_enabled,
    u07_short_selling_enabled,
    short_selling_enabled,
    u07_sharia_compliant_grp_m120,
    sharia_compliant_grp,
    u07_market_segment_v01,
    market_segment,
    u07_ca_charge_enabled,
    u07_ca_charge_enabled_desc,
    u07_status_changed_reason,
    u06_margin_enabled,
    u06_currency_code_m03,
    u06_iban_no,
    m73_product_type,
    m73_name,
    m77_name,
    u07_account_category,
    u07_custodian_type_v01,
    custodian_type,
    u07_parent_trading_acc_id_u07,
    u07_forgn_bank_account,
    portfolio_value,
    u07_market_maker_enabled,
    u07_market_maker_group_id_m131,
    u07_trade_conf_config_id_m151,
    u07_trade_conf_format_id_v12,
    u07_exchange_customer_name,
    u07_allocation_eligible,
    u07_maintenance_margin_value,
    u07_prefred_inst_type_id,
    u06_external_ref_no,
    u07_murabaha_margin_enabled,
    u07_exg_acc_type_id_v37,
    u07_clearing_acc_m86,
    u07_pref_mkt_ids_m29,
    u07_other_commsion_grp_id_m22
)
AS
    SELECT u07.u07_id,
           u07.u07_customer_id_u01,
           u07.u07_cash_account_id_u06,
           u07.u07_exchange_code_m01,
           u07.u07_exchange_id_m01,
           u07.u07_display_name_u06,
           u07.u07_customer_no_u01,
           u07.u07_display_name_u01,
           u07.u07_default_id_no_u01,
           u07.u07_is_default,
           u01.u01_external_ref_no,
           u01.u01_nationality_id_m05,
           u01.u01_default_id_no,
           CASE u07.u07_is_default WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END
               AS u07_is_default_txt,
           CASE u07.u07_is_default WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END
               AS is_default,
           u07.u07_type,
           CASE u07.u07_type
               WHEN 1 THEN 'Fully Disclosed'
               WHEN 2 THEN 'Non Disclosed'
               WHEN 3 THEN 'Swap'
           END
               AS u07_type_txt,
           u07.u07_trading_enabled,
           CASE u07.u07_trading_enabled
               WHEN 1 THEN 'Yes'
               WHEN 0 THEN 'No'
           END
               AS u07_trading_enabled_txt,
           u07.u07_sharia_compliant,
           CASE u07.u07_sharia_compliant
               WHEN 1 THEN 'Yes'
               WHEN 0 THEN 'No'
           END
               AS u07_sharia_compliant_txt,
           u07.u07_trading_group_id_m08,
           m08.m08_name,
           u07.u07_created_by_id_u17,
           u17a.u17_full_name AS created_by,
           u07.u07_created_date,
           u07.u07_institute_id_m02,
           m02.m02_name AS institute_name,
           u07.u07_status_id_v01,
           u07.u07_discount_prec_from_date,
           u07.u07_discount_prec_to_date,
           u07_status.v01_description AS status_description,
           u07_status.v01_description_lang,
           u07.u07_commission_group_id_m22,
           m22.m22_description AS commition_group,
           u07.u07_discount_percentage,
           u07.u07_commission_dis_grp_id_m24,
           m24.m24_description AS commision_discount_group,
           u07.u07_modified_by_id_u17,
           u17b.u17_full_name AS modified_by,
           u07.u07_modified_date,
           u07.u07_status_changed_by_id_u17,
           u17c.u17_full_name AS status_changed_by,
           u07.u07_status_changed_date,
           u07.u07_exe_broker_id_m26,
           m26_exec_broker.m26_name AS executing_broker,
           u07.u07_exchange_account_no,
           u07.u07_display_name,
           u07.u07_custodian_id_m26,
           m26_custody.m26_name AS custodian,
           u07.u07_cust_settle_group_id_m35,
           m35.m35_description AS settle_group,
           u07.u07_pending_restriction,
           u07.u07_trade_rejection_enabled,
           CASE u07.u07_trade_rejection_enabled
               WHEN 1 THEN 'Yes'
               WHEN 0 THEN 'No'
           END
               AS trade_rejection_enabled,
           u07.u07_short_selling_enabled,
           CASE u07.u07_short_selling_enabled
               WHEN 1 THEN 'Yes'
               WHEN 0 THEN 'No'
           END
               AS short_selling_enabled,
           u07.u07_sharia_compliant_grp_m120,
           m120.m120_name AS sharia_compliant_grp,
           u07.u07_market_segment_v01,
           CASE u07.u07_market_segment_v01
               WHEN 1 THEN 'Main Market'
               WHEN 2 THEN 'Second Market'
               WHEN 3 THEN 'Main Market & Second Market'
           END
               AS market_segment,
           u07.u07_ca_charge_enabled,
           DECODE (u07.u07_ca_charge_enabled, 1, 'Yes', 'No')
               AS u07_ca_charge_enabled_desc,
           u07_status_changed_reason,
           u06.u06_margin_enabled,
           u06.u06_currency_code_m03,
           u06.u06_iban_no,
           m73.m73_product_type,
           m73.m73_name,
           m77.m77_name,
           u07.u07_account_category,
           u07.u07_custodian_type_v01,
           CASE u07.u07_custodian_type_v01
               WHEN 0 THEN 'None'
               WHEN 1 THEN 'ICM'
           END
               AS custodian_type,
           u07.u07_parent_trading_acc_id_u07,
           u07.u07_forgn_bank_account,
           NVL (pv.portfolio_value, 0) AS portfolio_value,
           u07.u07_market_maker_enabled,
           u07.u07_market_maker_group_id_m131,
           u07.u07_trade_conf_config_id_m151,
           u07.u07_trade_conf_format_id_v12,
           u07.u07_exchange_customer_name,
           u07.u07_allocation_eligible,
           u07.u07_maintenance_margin_value,
           u07.u07_prefred_inst_type_id,
           u06.u06_display_name AS u06_external_ref_no,
           u07.u07_murabaha_margin_enabled,
           u07.u07_exg_acc_type_id_v37,
           u07.u07_clearing_acc_m86,
           u07.u07_pref_mkt_ids_m29,
           u07.u07_other_commsion_grp_id_m22
      FROM u07_trading_account u07,
           m08_trading_group m08,
           u17_employee u17a,
           v01_system_master_data u07_status,
           m22_commission_group m22,
           m02_institute m02,
           m24_commission_discount_group m24,
           u17_employee u17b,
           u17_employee u17c,
           vw_m26_exec_broker m26_exec_broker,
           vw_m26_custody m26_custody,
           m35_customer_settl_group m35,
           u01_customer u01,
           m120_sharia_compliant_group m120,
           u06_cash_account u06,
           u23_customer_margin_product u23,
           m73_margin_products m73,
           m77_symbol_marginability_grps m77,
           vw_u07_portfolio_value pv
     WHERE     u07.u07_trading_group_id_m08 = m08.m08_id
           AND u07.u07_created_by_id_u17 = u17a.u17_id
           AND u07.u07_status_id_v01 = u07_status.v01_id
           AND u07_status.v01_type = 4
           AND u07.u07_institute_id_m02 = m02.m02_id
           AND u07.u07_commission_group_id_m22 = m22.m22_id
           AND u07.u07_commission_dis_grp_id_m24 = m24.m24_id(+)
           AND u07.u07_modified_by_id_u17 = u17b.u17_id(+)
           AND u07.u07_status_changed_by_id_u17 = u17c.u17_id
           AND u07.u07_exe_broker_id_m26 = m26_exec_broker.m26_id(+)
           AND u07.u07_custodian_id_m26 = m26_custody.m26_id(+)
           AND u07.u07_cust_settle_group_id_m35 = m35.m35_id
           AND u07.u07_customer_id_u01 = u01.u01_id
           AND u07.u07_sharia_compliant_grp_m120 = m120.m120_id(+)
           AND u07.u07_cash_account_id_u06 = u06.u06_id(+)
           AND u06.u06_margin_product_id_u23 = u23.u23_id(+)
           AND u23.u23_margin_product_m73 = m73.m73_id(+)
           AND u23.u23_sym_margin_group_m77 = m77.m77_id(+)
           AND u07.u07_id = pv.u07_id(+)
/