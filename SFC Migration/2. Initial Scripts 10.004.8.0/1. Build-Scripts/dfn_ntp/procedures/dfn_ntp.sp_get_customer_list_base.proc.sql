CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_customer_list_base (
    p_view                  OUT SYS_REFCURSOR,
    prows                   OUT NUMBER,
    psortby                     VARCHAR2 DEFAULT NULL,
    pfromrownumber              NUMBER DEFAULT NULL,
    ptorownumber                NUMBER DEFAULT NULL,
    psearchcriteria             VARCHAR2 DEFAULT NULL,
    puserid                     NUMBER DEFAULT NULL,
    p_user_filter_enabled       NUMBER DEFAULT 0,
    pcustomerid                 NUMBER DEFAULT NULL)
IS
    l_qry       VARCHAR2 (15000);
    s1          VARCHAR2 (15000);
    s2          VARCHAR2 (15000);
    userfiler   NUMBER := NULL;
BEGIN
    prows := 0;
    l_qry :=
           'SELECT u01.u01_id,
       u01.u01_customer_no,
       u01.u01_institute_id_m02,
       m02.m02_name,
       u01.u01_account_category_id_v01,
       CASE
           WHEN u01.u01_account_type_id_v01 = 2 THEN ''Sub A/C''
           WHEN u01.u01_account_type_id_v01 = 1 THEN ''Master A/C''
       END
           AS acctype,
       u01.u01_display_name,
       u01.u01_display_name_lang,
       u01.u01_full_name,
       u01.u01_full_name_lang,
       u01.u01_date_of_birth,
       u01.u01_default_id_no,
       u01.u01_default_id_type_m15,
       m15.m15_name AS u01_default_id_type_txt,
       m15.m15_name_lang AS u01_default_id_type_txt_lang,
       u01.u01_preferred_lang_id_v01,
       u01.u01_created_date,
       u01.u01_status_id_v01,
       status.v01_description AS status_description,
       status.v01_description_lang,
       u01.u01_grade,
       u01.u01_trading_enabled,
       u01.u01_nationality_id_m05,
       nationality.m05_name AS nationalitycountry,
       u01.u01_online_trading_enabled,
       u01.u01_status_changed_reason,
       CASE WHEN u01.u01_trading_enabled = 1 THEN ''Yes'' ELSE ''No'' END
           AS trading,
       CASE WHEN u01.u01_online_trading_enabled = 1 THEN ''Yes'' ELSE ''No'' END
           AS online_trading,
       u01.u01_external_ref_no,
       u01.u01_account_type_id_v01,
       u01.u01_master_account_id_u01,
       CASE
           WHEN u01.u01_account_category_id_v01 = 1 THEN ''Individual''
           WHEN u01.u01_account_category_id_v01 = 2 THEN ''Corporate''
       END
           AS acccategory,
       DECODE (u01.u01_poa_available,  1, ''Yes'',  0, ''No'')
           AS u01_poa_available_desc,
       u01.u01_poa_available,
       u01.u01_minor_account,
       CASE WHEN u01.u01_minor_account = 1 THEN ''Yes'' ELSE ''No'' END
           AS minor_account,
       u01.u01_def_mobile AS default_mobile,
       u01.u01_def_email AS default_email,
       u01.u01_agent_type AS agent_type,
       u01.u01_agent_code AS agent_code,
       m02.m02_primary_institute_id_m02,
	   u01.u01_investor_id,
	   u01.u01_dd_reference_no,
        u01.u01_batch_id_t80,
        bs.v01_description AS block_status
  FROM u01_customer u01
       JOIN m15_identity_type m15
           ON u01.u01_default_id_type_m15 = m15.m15_id
       JOIN v01_system_master_data status
           ON u01.u01_status_id_v01 = status.v01_id AND status.v01_type = 4
       JOIN m05_country nationality
           ON u01.u01_nationality_id_m05 = nationality.m05_id
       JOIN m02_institute m02
           ON u01.u01_institute_id_m02 = m02.m02_id
       LEFT JOIN vw_block_status_list_b bs
           ON u01.u01_block_status_b = bs.v01_id'
        || fn_get_customer_filter (
               pcust_column            => 'u01_id',
               ptab_alies              => 'u01',
               puser_id                => puserid,
               p_user_filter_enabled   => p_user_filter_enabled)
        || CASE
               WHEN pcustomerid IS NOT NULL
               THEN
                   ' WHERE u01.u01_id = ' || pcustomerid
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
