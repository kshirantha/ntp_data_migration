CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_daily_cash_summary (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE,
    ptodate               DATE,
    puserfilter           VARCHAR2 DEFAULT NULL,
    pinstitute            NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT h02.h02_date,
       h02.h02_customer_id_u01,
       u01.u01_customer_no,
       u01.u01_external_ref_no,
       u01.u01_display_name,
       u01.u01_display_name_lang,
       u01.u01_institute_id_m02,
       u06.u06_external_ref_no,
       u06.u06_display_name,
       u06.u06_currency_code_m03,
       (h02.h02_balance + h02.h02_payable_blocked - h02.h02_receivable_amount)
           AS h02_balance,
       ROUND (
             NVL (h02.h02_balance, 0)
           + NVL (u06.od_limit_today, 0)
           + NVL (u06.u06_blocked, 0),
           2)
           AS non_margin_buying_power,
       u06.u06_primary_od_limit,
       u06.u06_primary_expiry,
       u06.u06_secondary_od_limit,
       u06.u06_secondary_expiry
  FROM vw_h02_cash_account_summary h02,
       u01_customer u01,
       vw_u06_cash_account_base u06
WHERE h02.h02_date = TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')'
        || CASE
               WHEN puserfilter IS NOT NULL THEN ' AND ' || puserfilter
               ELSE ''
           END
        || '
AND h02.h02_customer_id_u01 = u01.u01_id
AND h02.h02_cash_account_id_u06 = u06.u06_id
AND u01.U01_ACCOUNT_TYPE_ID_V01 != 1
AND u06.u06_institute_id_m02 = '
        || pinstitute;

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              NULL,
                              NULL,
                              NULL);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/