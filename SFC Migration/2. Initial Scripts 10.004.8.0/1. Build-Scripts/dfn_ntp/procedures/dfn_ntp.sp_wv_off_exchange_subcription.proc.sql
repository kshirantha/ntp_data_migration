CREATE OR REPLACE PROCEDURE dfn_ntp.sp_wv_off_exchange_subcription (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    pinstituteid      IN     NUMBER,
    pfromdate         IN     DATE,
    ptodate           IN     DATE,
    psortby                  VARCHAR2 DEFAULT NULL,
    pfromrownumber           NUMBER DEFAULT NULL,
    ptorownumber             NUMBER DEFAULT NULL,
    psearchcriteria          VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           '
    SELECT t60.t60_id,
       u09.u09_customer_id_u01,
       u09.u09_login_name,
       u01.u01_external_ref_no,
       t60.t60_datetime,
       m153.m153_exchange_code_m01,
       t60.t60_exchange_fee_waiveof_amnt,
       CASE
           WHEN t60.t60_status = 0 THEN ''Suspend''
           WHEN t60.t60_status = 1 THEN ''Approved''
           WHEN t60.t60_status = 2 THEN ''Downgraded''
           WHEN t60.t60_status = 3 THEN ''Rejected''
       END
           AS status,
       u09.u09_price_user_name,
       t60.t60_from_date,
       t60.t60_to_date
  FROM t60_exchange_subscription_log t60
       JOIN m153_exchange_subscription_prd m153
           ON t60.t60_exchange_product_id_m153 = m153.m153_id
       LEFT JOIN u09_customer_login u09
           ON t60.t60_customer_login_u09 = u09.u09_id -- is this required?
       JOIN u01_customer u01
           ON t60.t60_customer_id_u01 = u01.u01_id
 WHERE     t60.t60_datetime BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'')
                        AND TO_DATE('''
        || TO_CHAR (ptodate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'') + 0.99999 AND
        t60.t60_institute_id_m02 = '
        || pinstituteid;

    s1 :=
        fn_get_sp_data_query (psearchcriteria   => NULL,
                              psortby           => NULL,
                              ptorownumber      => NULL,
                              pfromrownumber    => NULL,
                              l_qry             => l_qry);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
