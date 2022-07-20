CREATE OR REPLACE PROCEDURE dfn_ntp.sp_wv_off_user_service_fee_rpt (
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
    SELECT t59.t59_id,
       u09.u09_customer_id_u01,
       u09.u09_login_name,
       u01.u01_external_ref_no,
       t59.t59_datetime,
       v35.v35_product_name AS m152_product_name,
       t59.t59_broker_fee_waiveof_amnt,
       t59.t59_service_fee_waiveof_amnt,
       t60.t60_exchange_fee_waiveof_amnt,
       status_list.v01_description AS status,
       u09.u09_price_user_name,
       t59.t59_from_date,
       t59.t59_to_date
  FROM t59_product_subscription_log t59
       JOIN m154_subscription_waiveoff_grp m154
           ON t59.t59_subfee_waiveof_grp_id_m154 = m154.m154_id
       JOIN m155_product_waiveoff_details m155
           ON m154.m154_id = m155.m155_group_id_m154
       LEFT JOIN t60_exchange_subscription_log t60
           ON m154.m154_id = t60.t60_subfee_waiveof_grp_id_m154
       JOIN m152_products m152
           ON m155.m155_product_id_m152 = m152.m152_id
       JOIN u09_customer_login u09
           ON t59.t59_customer_login_u09 = u09.u09_id
       JOIN u01_customer u01
           ON t59.t59_customer_id_u01 = u01.u01_id
       JOIN u17_employee u17
           ON m155.m155_created_by_id_u17 = u17.u17_id
       JOIN v35_products v35 ON m152_product_id_v35 = v35_id
       LEFT JOIN vw_status_list status_list
           ON m155_status_id_v01 = status_list.v01_id
       WHERE t59.t59_datetime BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'')
                        AND TO_DATE('''
        || TO_CHAR (ptodate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'') + 0.99999 AND
        t59.t59_institute_id_m02 = '
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