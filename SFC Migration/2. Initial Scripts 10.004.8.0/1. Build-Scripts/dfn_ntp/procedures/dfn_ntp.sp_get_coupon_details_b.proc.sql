CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_coupon_details_b (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pcouponid             NUMBER DEFAULT NULL,
    pinstituteid          NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT t1001.t1001_name AS name,
       t1001.t1001_nin AS nin,
       t1001.t1001_iban AS iban,
       t1001.t1001_account_no AS account_no,
       t1001.t1001_holding_qty AS no_of_sukuk,
       t1001.t1001_coupon_amount AS coupon_amount,
       t1001.t1001_status_id_v01,
       status_list.v01_description AS status,
       t1001.t1001_coupon_id_m1001,
       t1001.t1001_id
  FROM     t1001_sukuk_payment_detail_b t1001
       INNER JOIN
           vw_status_list status_list
       ON t1001.t1001_status_id_v01 = status_list.v01_id
 WHERE t1001.t1001_coupon_id_m1001 = '
        || pcouponid;

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