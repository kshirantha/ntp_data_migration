CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_top_customer_commission (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pexchangecode         VARCHAR2 DEFAULT NULL,
    pinstituteid          NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT *
FROM (SELECT u01.u01_customer_no,
             u01.u01_display_name,
             t02_exchange_code_m01,
             t02_commission_adjst,
             t02_broker_commission,
             t02_exg_commission,
             t02_amnt_in_txn_currency,
             t02_amnt_in_stl_currency,
             t02_discount,
             t02_commission_adjst + t02_discount AS default_commission,
             broker_vat,
             exchange_vat,
             T02_CUSTOMER_ID_U01,
             t02_ord_value_adjst FROM
             (SELECT T02_CUSTOMER_ID_U01,
             MAX (t02_exchange_code_m01)
                 AS t02_exchange_code_m01,
       SUM (
                       CASE
                           WHEN t02.t02_txn_currency != ''SAR''
                           THEN
                                 t02.t02_commission_adjst
                               * get_exchange_rate (t02.t02_inst_id_m02,
                                                    t02.t02_txn_currency,
                                                    ''SAR'')
                           ELSE
                               t02.t02_commission_adjst
                       END)
                       AS t02_commission_adjst,
                   SUM (
                       CASE
                           WHEN t02.t02_txn_currency != ''SAR''
                           THEN
                                 (  t02.t02_commission_adjst
                                  - t02.t02_exg_commission)
                               * get_exchange_rate (t02.t02_inst_id_m02,
                                                    t02.t02_txn_currency,
                                                    ''SAR'')
                           ELSE
                                 t02.t02_commission_adjst
                               - t02.t02_exg_commission
                       END)
                       AS t02_broker_commission,
             SUM (t02.t02_exg_commission)
                 AS t02_exg_commission,
             SUM (t02.t02_amnt_in_txn_currency)
                 AS t02_amnt_in_txn_currency,
             SUM (t02.t02_amnt_in_stl_currency)
                 AS t02_amnt_in_stl_currency,
             SUM (t02_discount)
                 AS t02_discount,
             SUM (t02_broker_tax)
                 AS broker_vat,
             SUM (t02_exchange_tax)
                 AS exchange_vat,
             SUM (t02_ord_value_adjst)
                 AS t02_ord_value_adjst
      FROM t02_transact_log_order_arc_all t02
      WHERE     t02_inst_id_m02 = '
        || pinstituteid
        || CASE
               WHEN pexchangecode IS NOT NULL OR pexchangecode <> ''
               THEN
                   ' AND t02_exchange_code_m01 = ''' || pexchangecode || ''''
               ELSE
                   ''
           END
        || ' AND t02.t02_create_date between TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') AND  TO_DATE('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') + 0.99999
      GROUP BY T02_CUSTOMER_ID_U01) x,
     u01_customer u01
 WHERE x.t02_customer_id_u01 = u01.u01_id
      ORDER BY t02_commission_adjst DESC)
WHERE ROWNUM <= 10';

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