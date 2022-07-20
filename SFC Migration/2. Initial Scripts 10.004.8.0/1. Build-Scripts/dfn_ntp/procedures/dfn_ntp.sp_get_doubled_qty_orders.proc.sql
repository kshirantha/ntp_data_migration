CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_doubled_qty_orders (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    psortby           IN     VARCHAR2 DEFAULT NULL,
    pfromrownumber    IN     NUMBER,
    ptorownumber      IN     NUMBER,
    psearchcriteria   IN     VARCHAR2 DEFAULT NULL,
    pfromdate         IN     DATE,
    ptodate           IN     DATE,
    pexchangecode     IN     VARCHAR2)
IS
    l_qry             VARCHAR2 (15000);
    l_quantity        NUMBER := 0;
    l_cumordervalue   NUMBER := 15000;
    s1                VARCHAR2 (15000);
    s2                VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT DISTINCT order_date,
                                stock_code,
                                min_order_qty AS qty_before,
                                max_order_qty AS qty_after,
                                amendments,
                                m02.m02_primary_institute_id_m02 AS primary_institute_id,
                                ord_type,
                                customer_id,
                                u01.U01_DISPLAY_NAME,
                                u01.U01_CUSTOMER_NO
                FROM (SELECT TRUNC(T01_DATE)     AS order_date,
                             T01_SYMBOL_CODE_M20 AS stock_code,
                             order_count - 1     AS amendments,
                             CASE
                                 WHEN t01_side = 1 THEN ''Buy''
                                 WHEN t01_side = 2 THEN ''Sell''
                                 END
                                                 AS ord_type,
                             T01_ORD_NO,
                             T01_QUANTITY,
                             T01_CUSTOMER_ID_U01 AS customer_id,
                             MIN(T01_QUANTITY)
                                 OVER (PARTITION BY T01_ORD_NO)
                                                 AS min_order_qty,
                             MAX(T01_QUANTITY)
                                 OVER (PARTITION BY T01_ORD_NO)
                                                 AS max_order_qty
                      FROM (SELECT t01.T01_DATE,
                                   t01.T01_SYMBOL_CODE_M20,
                                   t01_side,
                                   t01.T01_CL_ORD_ID,
                                   t01.T01_QUANTITY,
                                   t01.T01_ORD_NO,
                                   T01_CUSTOMER_ID_U01,
                                   MIN(t01.T01_CL_ORD_ID)
                                       OVER (
                                           PARTITION BY t01.T01_ORD_NO
                                           )
                                       AS min_clordid,
                                   MAX(t01.T01_CL_ORD_ID)
                                       OVER (
                                           PARTITION BY t01.T01_ORD_NO
                                           )
                                       AS max_clordid,
                                   COUNT(t01.T01_ORD_NO)
                                         OVER (
                                             PARTITION BY t01.T01_ORD_NO
                                             )
                                       AS order_count
                            FROM t01_order_all t01
                            WHERE t01.T01_EXCHANGE_CODE_M01 = '''
        || pexchangecode
        || '''
                              AND t01.T01_DATE BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'')
                                                                        AND  TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'')
                                                                             + 0.99999
                      AND t01.T01_QUANTITY > '
        || l_quantity
        || '
                      AND t01.T01_ORD_VALUE >= '
        || l_cumordervalue
        || ') t01_all
              WHERE (t01_all.T01_CL_ORD_ID = t01_all.min_clordid
                  OR t01_all.T01_CL_ORD_ID = t01_all.max_clordid)
                AND order_count > 2) tt,
             U01_CUSTOMER u01, m02_institute m02
        WHERE customer_id = u01.U01_ID
                AND u01.u01_institute_id_m02 = m02.m02_id
                AND max_order_qty > min_order_qty';

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
