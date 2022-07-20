CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_trading_acc_list_base (
    p_view                  OUT SYS_REFCURSOR,
    prows                   OUT NUMBER,
    psortby                     VARCHAR2 DEFAULT NULL,
    pfromrownumber              NUMBER DEFAULT NULL,
    ptorownumber                NUMBER DEFAULT NULL,
    psearchcriteria             VARCHAR2 DEFAULT NULL,
    puserid                     NUMBER DEFAULT NULL,
    ptradingaccountid           NUMBER DEFAULT NULL,
    p_user_filter_enabled       NUMBER DEFAULT 0)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT u07.u07_id,
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
       u01.u01_default_id_no,
       u01.u01_agent_code as agent_code,
       u07.u07_account_category,
       CASE u07.u07_is_default WHEN 1 THEN ''Yes'' WHEN 0 THEN ''No'' END
           AS u07_is_default_txt,
       CASE u07.u07_is_default WHEN 1 THEN ''Yes'' WHEN 0 THEN ''No'' END
           AS is_default,
       u07.u07_type,
       CASE u07.u07_type
           WHEN 1 THEN ''Fully Disclosed''
           WHEN 2 THEN ''Non Disclosed''
           WHEN 3 THEN ''Swap''
       END
           AS u07_type_txt,
       u07.u07_trading_enabled,
       CASE u07.u07_trading_enabled WHEN 1 THEN ''Yes'' WHEN 0 THEN ''No'' END
           AS u07_trading_enabled_txt,
       u07.u07_sharia_compliant,
       CASE u07.u07_sharia_compliant WHEN 1 THEN ''Yes'' WHEN 0 THEN ''No'' END
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
       u07.u07_commission_dis_grp_id_m24,
       m24.m24_description AS commision_discount_group,
       u07.u07_modified_by_id_u17,
       u17b.u17_full_name AS modified_by,
       u07.u07_modified_date,
       u07.u07_status_changed_by_id_u17,
       u07.u07_exe_broker_id_m26,
       m26_exec_broker.m26_name AS executing_broker,
       u07.u07_exchange_account_no,
       u07.u07_display_name,
       u07.u07_custodian_id_m26,
       m26_custody.m26_name AS custodian,
       u07.u07_cust_settle_group_id_m35,
       m35.m35_description AS settle_group,
       u07.u07_ca_charge_enabled,
       DECODE (u07.u07_ca_charge_enabled, 1, ''Yes'', ''No'')
           AS u07_ca_charge_enabled_desc,
       u07_status_changed_reason,
       u06.u06_margin_enabled,
       u06.u06_currency_code_m03,
       u07.u07_exchange_customer_name,
       u07.u07_allocation_eligible,
       u07.u07_murabaha_margin_enabled,
       u07.u07_clearing_acc_m86,
       m86.m86_account_number,
       u07.u07_custodian_type_v01,
       u07_custodian_type.v01_description AS u07_custodian_type,
       u07.u07_update_extenal_system_b,
       DECODE (u07.u07_update_extenal_system_b, 1, ''Yes'', ''No'') AS fis_updated
  FROM u07_trading_account u07
       JOIN u01_customer u01
           ON u07.u07_customer_id_u01 = u01.u01_id
       LEFT JOIN m08_trading_group m08
           ON u07.u07_trading_group_id_m08 = m08.m08_id
       LEFT JOIN u17_employee u17a
           ON u07.u07_created_by_id_u17 = u17a.u17_id
       JOIN m02_institute m02
           ON u07.u07_institute_id_m02 = m02.m02_id
       JOIN m22_commission_group m22
           ON u07.u07_commission_group_id_m22 = m22.m22_id
       LEFT JOIN m24_commission_discount_group m24
           ON u07.u07_commission_dis_grp_id_m24 = m24.m24_id
       LEFT JOIN u17_employee u17b
           ON u07.u07_modified_by_id_u17 = u17b.u17_id
       LEFT JOIN vw_m26_exec_broker m26_exec_broker
           ON u07.u07_exe_broker_id_m26 = m26_exec_broker.m26_id
       LEFT JOIN vw_m26_custody m26_custody
           ON u07.u07_custodian_id_m26 = m26_custody.m26_id
       JOIN m35_customer_settl_group m35
           ON u07.u07_cust_settle_group_id_m35 = m35.m35_id
       LEFT JOIN u06_cash_account u06
           ON u07.u07_cash_account_id_u06 = u06.u06_id
       LEFT JOIN m86_ex_clearing_accounts m86
           ON u07.u07_clearing_acc_m86 = m86.m86_id
       LEFT JOIN v01_system_master_data u07_custodian_type
           ON     u07.u07_custodian_type_v01 = u07_custodian_type.v01_id
              AND u07_custodian_type.v01_type = 57
       LEFT JOIN v01_system_master_data u07_status
           ON     u07.u07_status_id_v01 = u07_status.v01_id
              AND u07_status.v01_type = 4'
        || fn_get_trading_acc_filter (
               ptrading_column         => 'u07_id',
               ptab_alies              => 'u07',
               puser_id                => puserid,
               p_user_filter_enabled   => p_user_filter_enabled)
        || CASE
               WHEN ptradingaccountid IS NOT NULL
               THEN
                   ' WHERE u07.u07_id = ' || ptradingaccountid
               ELSE
                   ' '
           END;


    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);


    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/