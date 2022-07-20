CREATE OR REPLACE PROCEDURE dfn_ntp.get_can_ord_buy_sell_same_sym (
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
           'SELECT u01.u01_id AS customer_id,
           u01.u01_display_name AS customer_name,
           u01.u01_customer_no AS customer_no,
           m02.m02_primary_institute_id_m02 AS primary_institute_id,
           order_table.t01_last_updated_date_time AS cancellation_time,
           order_table.order_date,
           order_table.order_qty,
           order_table.t01_symbol_code_m20 AS symbol,
           order_table.exchange,
           CASE
               WHEN order_table.t01_side = 1 THEN ''Buy''
               WHEN order_table.t01_side = 2 THEN ''Sell''
           END as order_type
      FROM (SELECT t01.t01_customer_id_u01,
                   t01.t01_symbol_code_m20,
                   t01.t01_side,
                   MAX (t01.t01_last_updated_date_time)
                       AS t01_last_updated_date_time,
                   MAX (t01.t01_date) AS order_date,
                   MAX (t01.t01_exchange_code_m01) AS exchange,
                   SUM (t01.t01_quantity) AS order_qty
              FROM t01_order_all t01
                   JOIN
                   (SELECT DISTINCT t01_sell.*
                      FROM (SELECT buy_order.t01_customer_id_u01,
                                   buy_order.t01_symbol_code_m20,
                                   SUM (buy_order.t01_quantity) AS buy_qty,
                                   SUM (buy_order.t01_ord_value) AS buy_ord_value
                              FROM t01_order_all buy_order
                             WHERE     buy_order.t01_side = 1
                                   AND buy_order.t01_exchange_code_m01 = '''
        || pexchangecode
        || '''
                                   AND buy_order.t01_status_id_v30 IN (''4'')
                                   AND buy_order.t01_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                                            AND  TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                                                + 0.99999
                            GROUP BY buy_order.t01_customer_id_u01,
                                     buy_order.t01_symbol_code_m20) t01_buy
                           JOIN
                           (SELECT sell_order.t01_customer_id_u01,
                                   sell_order.t01_symbol_code_m20,
                                   SUM (sell_order.t01_quantity) AS sell_qty,
                                   SUM (sell_order.t01_ord_value)
                                       AS sell_ord_value
                              FROM t01_order_all sell_order
                             WHERE     sell_order.t01_side = 2
                                   AND sell_order.t01_exchange_code_m01 = '''
        || pexchangecode
        || '''
                                   AND sell_order.t01_status_id_v30 IN (''4'')
                                   AND sell_order.t01_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                                            AND  TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                                                + 0.99999
                            GROUP BY sell_order.t01_customer_id_u01,
                                     sell_order.t01_symbol_code_m20) t01_sell
                               ON     t01_buy.t01_customer_id_u01 =
                                          t01_sell.t01_customer_id_u01
                                  AND t01_buy.t01_symbol_code_m20 =
                                          t01_sell.t01_symbol_code_m20
                                  AND t01_buy.buy_qty > '
        || l_quantity
        || '
                                  AND t01_buy.buy_ord_value >= '
        || l_cumordervalue
        || '
                                  AND t01_sell.sell_qty > '
        || l_quantity
        || '
                                  AND t01_sell.sell_ord_value >= '
        || l_cumordervalue
        || ') buy_sell
                       ON     t01.t01_customer_id_u01 =
                                  buy_sell.t01_customer_id_u01
                          AND t01.t01_symbol_code_m20 =
                                  buy_sell.t01_symbol_code_m20
                          AND t01.t01_exchange_code_m01 = '''
        || pexchangecode
        || '''
                          AND t01.t01_status_id_v30 IN (''4'')
                          AND t01.t01_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                                            AND  TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                                                + 0.99999
            GROUP BY t01.t01_customer_id_u01,
                     t01.t01_symbol_code_m20,
                     t01.t01_side) order_table
           JOIN u01_customer u01 ON u01.u01_id = order_table.t01_customer_id_u01
           JOIN m02_institute m02 ON u01.u01_institute_id_m02 = m02.m02_id';


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
