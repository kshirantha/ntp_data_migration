CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_discounted_commission (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pinstitute            NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    l_qry :=
           'SELECT u01.u01_id,
               MAX (u01.u01_customer_no) AS u01_customer_no,
               u07.u07_exchange_account_no,
               t01.t01_exchange_code_m01,
               u07.u07_id,
               COUNT (t01.t01_cl_ord_id) AS no_of_orders,
               SUM (t01.t01_cum_commission) AS total_cum_commission,
               SUM (t01.t01_cum_discount) AS total_cum_discount,
               SUM (t01.t01_cum_commission) + SUM (t01.t01_cum_discount)
                   AS total_market_commission,
               t01.t01_settle_currency,
               MAX (t01.t01_institution_id_m02) AS t01_institution_id_m02
          FROM t01_order t01
               JOIN u07_trading_account u07
                   ON t01.t01_trading_acc_id_u07 = u07.u07_id
               JOIN u01_customer u01 ON u07.u07_customer_id_u01 = u01.u01_id
         WHERE     t01.t01_status_id_v30 IN (''2'',
                                             ''q'',
                                             ''r'',
                                             ''1'',
                                             ''5'')
               AND t01.t01_cum_quantity > 0

               AND t01.t01_date BETWEEN TO_DATE (
                   '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') AND  TO_DATE ( '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') + .99999
         GROUP BY u01.u01_id,
                 u07.u07_exchange_account_no,
                 t01.t01_exchange_code_m01,
                 u07.u07_id,
                 t01.t01_settle_currency';

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