CREATE OR REPLACE PROCEDURE dfn_ntp.get_order_in_buy_sell_same_sym (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    psortby           IN     VARCHAR2 DEFAULT NULL,
    pfromrownumber    IN     NUMBER,
    ptorownumber      IN     NUMBER,
    psearchcriteria   IN     VARCHAR2 DEFAULT NULL,
    pfromdate         IN     DATE,
    ptodate           IN     DATE,
    puserfilter       IN     VARCHAR2 DEFAULT NULL,
    pexchangecode     IN     VARCHAR2)
IS
    l_quantity        NUMBER := 0;
    l_cumordervalue   NUMBER := 15000;
    l_qry             VARCHAR2 (15000);
    s1                VARCHAR2 (15000);
    s2                VARCHAR2 (15000);
BEGIN
    prows := 0;

    l_qry :=
           'SELECT order_table.t01_date AS order_date,
           u01.u01_id AS customer_id,
           u01.u01_display_name AS customer_name,
           u01.u01_customer_no AS customer_no,
           m02.m02_primary_institute_id_m02 AS primary_institute_id,
           order_table.t01_symbol_code_m20 AS symbol,
           order_table.t01_exchange_code_m01 AS exchange,
           CASE
               WHEN order_table.t01_side = 1 THEN ''Buy''
               WHEN order_table.t01_side = 2 THEN ''Sell''
           END
               AS order_type,
           order_table.latest_order_qty AS max_order_qty,
           order_table.initial_order_qty AS order_qty,
           order_table.latest_order_qty - order_table.initial_order_qty
               AS increased_order_qty
      FROM u01_customer u01
           INNER JOIN
           (SELECT t01_original.t01_cl_ord_id AS initial_cl_ord_id,
                   t01_original.t01_quantity AS initial_order_qty,
                   t01_original.t01_symbol_code_m20,
                   t01_original.t01_exchange_code_m01,
                   t01_original.t01_date,
                   t01_original.t01_side,
                   t01_original.t01_customer_id_u01,
                   t01_latest.t01_cl_ord_id AS latest_cl_ord_id,
                   t01_latest.t01_quantity AS latest_order_qty
              FROM t01_order_all t01_original,
                   (SELECT t01.t01_ord_no,
                           t01.t01_cl_ord_id,
                           t01.t01_quantity,
                           t01.t01_symbol_code_m20
                      FROM t01_order_all t01,
                           (SELECT buy_order.t01_customer_id_u01,
                                   buy_order.t01_symbol_code_m20,
                                   TRUNC (buy_order.t01_date)
                              FROM t01_order_all buy_order
                             WHERE     buy_order.t01_side = 1
                                   AND buy_order.t01_exchange_code_m01 = '''
        || pexchangecode
        || '''
                                   AND buy_order.t01_quantity > '
        || l_quantity
        || '
                                   AND buy_order.t01_cum_ord_value >= '
        || l_cumordervalue
        || '
                                   AND buy_order.t01_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
                                            AND  TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
                                                + 0.99999
                            INTERSECT
                            SELECT sell_order.t01_customer_id_u01,
                                   sell_order.t01_symbol_code_m20,
                                   TRUNC (sell_order.t01_date)
                              FROM t01_order_all sell_order
                             WHERE     sell_order.t01_side = 2
                                   AND sell_order.t01_exchange_code_m01 = '''
        || pexchangecode
        || '''
                                   AND sell_order.t01_quantity > '
        || l_quantity
        || '
                                   AND sell_order.t01_cum_ord_value >= '
        || l_cumordervalue
        || '
                                   AND sell_order.t01_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
                                            AND  TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
                                                + 0.99999)
                             bs
                     WHERE     t01.t01_exchange_code_m01 = '''
        || pexchangecode
        || '''
                           AND t01.t01_status_id_v30 IN (''1'',
                                                         ''2'',
                                                         ''O'',
                                                         ''5'',
                                                         ''9'',
                                                         ''C'',
                                                         ''q'',
                                                         ''r'',
                                                         ''M'',
                                                         ''0'',
                                                         ''4'')

                           AND t01.t01_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
                                            AND  TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
                                                + 0.99999
                           AND t01.t01_quantity > '
        || l_quantity
        || '
                           AND t01.t01_cum_ord_value >= '
        || l_cumordervalue
        || '
                           AND t01.t01_symbol_code_m20 = bs.t01_symbol_code_m20
                           AND t01.t01_customer_id_u01 = bs.t01_customer_id_u01)
                   t01_latest
             WHERE     t01_original.t01_cl_ord_id = t01_latest.t01_ord_no)
           order_table
               ON u01.u01_id = order_table.t01_customer_id_u01
           INNER JOIN m02_institute m02 ON u01.u01_institute_id_m02 = m02.m02_id';


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
