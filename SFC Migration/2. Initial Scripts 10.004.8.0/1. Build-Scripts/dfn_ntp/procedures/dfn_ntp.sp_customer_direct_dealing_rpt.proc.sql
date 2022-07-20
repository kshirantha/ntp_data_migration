CREATE OR REPLACE PROCEDURE dfn_ntp.sp_customer_direct_dealing_rpt (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (4000);
    s1      VARCHAR2 (4000);
    s2      VARCHAR2 (4000);
BEGIN
    prows := 0;

    l_qry :=
        'SELECT u01.u01_id,
       u01.u01_customer_no,
       u01.u01_institute_id_m02,
       u01.u01_display_name,
       u01.u01_display_name_lang,
       u01.u01_default_id_no,
       u01.u01_direct_dealing_enabled,
       u01.u01_dd_reference_no,
       u01.u01_dd_from_date,
       u01.u01_dd_to_date,
       u06.u06_display_name,
       u06.u06_investment_account_no,
       u07.u07_display_name,
       u01.u01_default_id_type_m15,
       m15.m15_name AS default_id_type_txt,
       m15.m15_name_lang AS default_id_type_txt_lang,
       u07.u07_id
  FROM u01_customer u01
       JOIN u06_cash_account u06 ON u01.u01_id = u06.u06_customer_id_u01
       JOIN u07_trading_account u07
           ON u06.u06_id = u07.u07_cash_account_id_u06
       JOIN m15_identity_type m15 ON u01.u01_default_id_type_m15 = m15.m15_id
 WHERE        u01.u01_direct_dealing_enabled = 1';


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