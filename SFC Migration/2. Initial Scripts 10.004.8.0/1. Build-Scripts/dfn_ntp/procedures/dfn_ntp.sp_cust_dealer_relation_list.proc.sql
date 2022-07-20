CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cust_dealer_relation_list (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL)
IS
    l_qry         VARCHAR2 (15000);
    l_qry_count   VARCHAR2 (15000);
    s1            VARCHAR2 (15000);
    s2            VARCHAR2 (15000);
BEGIN
    l_qry :=
        'SELECT u07.u07_customer_id_u01,
               u07.u07_customer_no_u01 AS u01_customer_no,
               u01.u01_id,
               u01.u01_full_name AS custname,
               u01.u01_institute_id_m02,
               u07.u07_display_name,
               u17.u17_id AS dealer_id,
               u17.u17_full_name AS dealer,
               m12.m12_name AS department,
               m11.m11_name AS employee_type,
               CASE WHEN u17.u17_trading_enabled = 1 THEN ''Yes'' ELSE ''No'' END
                   AS trading,
               CASE
                   WHEN u17.u17_login_status = 0 THEN ''Pending''
                   WHEN u17.u17_login_status = 1 THEN ''Active''
                   WHEN u17.u17_login_status = 2 THEN ''Locked''
                   WHEN u17.u17_login_status = 3 THEN ''Suspended''
                   WHEN u17.u17_login_status = 4 THEN ''Deleted''
                   ELSE ''Unknown''
               END
                   AS loginstatus,
               u17.u17_telephone,
               u17.u17_email,
               status.v01_description,
               CASE WHEN u01.u01_trading_enabled = 1 THEN ''Yes'' ELSE ''No'' END
                   AS cust_trading,
               m05.m05_name AS country_name,
               CASE
                   WHEN u01.u01_account_category_id_v01 = 1 THEN ''INDIVIDUAL''
                   WHEN u01.u01_account_category_id_v01 = 2 THEN ''CORPORATE''
                   ELSE ''UNKNOWN''
               END
                   AS acctype,
               CASE
                   WHEN u01.u01_account_type_id_v01 = 2 THEN ''Sub A/C''
                   WHEN u01.u01_account_type_id_v01 = 1 THEN ''Master A/C''
               END
                   AS acccategory
          FROM u01_customer u01
               INNER JOIN u07_trading_account u07
                   ON u01.u01_id = u07.u07_customer_id_u01
               INNER JOIN m51_employee_trading_groups m51
                   ON u07.u07_trading_group_id_m08 = m51.m51_trading_group_id_m08
               INNER JOIN u17_employee u17
                   ON m51.m51_employee_id_u17 = u17.u17_id
               INNER JOIN m12_employee_department m12
                   ON u17.u17_department_id_m12 = m12.m12_id
               INNER JOIN m11_employee_type m11
                   ON u17.u17_type_id_m11 = m11.m11_id AND m11.m11_category = 2
               INNER JOIN vw_status_list status
                   ON u01.u01_status_id_v01 = status.v01_id
               INNER JOIN m05_country m05
                   ON u01.u01_nationality_id_m05 = m05.m05_id';

    l_qry_count :=
        'SELECT u07.u07_trading_group_id_m08
                      FROM u07_trading_account u07
                           JOIN m51_employee_trading_groups m51
                               ON u07.u07_trading_group_id_m08 =
                                      m51.m51_trading_group_id_m08
                           JOIN u17_employee u17
                               ON m51.m51_employee_id_u17 = u17.u17_id
                           JOIN m11_employee_type m11
                               ON     u17.u17_type_id_m11 = m11.m11_id
                                  AND m11.m11_category = 2';

    s1 :=
        fn_get_sp_data_query (psearchcriteria   => psearchcriteria,
                              l_qry             => l_qry,
                              psortby           => NULL, --Sorting will slow down the report
                              ptorownumber      => ptorownumber,
                              pfromrownumber    => pfromrownumber);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
