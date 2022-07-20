CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_subscriptio_expire_list (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;


    l_qry :=
        'SELECT u01.u01_id,
       u01.u01_customer_no,
       u01.u01_institute_id_m02,
       u01.u01_display_name,
       u01.u01_display_name_lang,
       m152.m152_id,
       v35.v35_product_code AS m152_product_code,
       v35.v35_product_name AS m152_product_name,
       v35.v35_product_name_lang AS m152_product_name_lang,
       u09.u09_login_name,
       t56.t56_from_date,
       t56.t56_to_date,
       t56.t56_status,
       CASE
           WHEN t56.t56_status = 1 THEN ''Approved''
           WHEN t56.t56_status = 0 THEN ''Suspended''
       END
           AS status,
       u09.u09_price_user_name,
       u01.u01_external_ref_no,
       t56.t56_service_fee,
       t56.t56_broker_fee,
       t56.t56_vat_service_fee,
       t56.t56_vat_broker_fee
  FROM u01_customer u01
       JOIN t56_product_subscription_data t56
           ON u01.u01_id = t56.t56_customer_id_u01
       JOIN m152_products m152
           ON t56.t56_product_id_m152 = m152.m152_id
       JOIN v35_products v35 ON m152.m152_product_id_v35 = v35_id
       LEFT JOIN u09_customer_login u09
           ON t56.t56_customer_login_u09 = u09.u09_id
 WHERE     t56.t56_to_date <= TRUNC (SYSDATE)';

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