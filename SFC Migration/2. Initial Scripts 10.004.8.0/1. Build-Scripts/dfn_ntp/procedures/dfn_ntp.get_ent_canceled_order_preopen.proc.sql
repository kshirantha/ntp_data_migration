CREATE OR REPLACE PROCEDURE dfn_ntp.get_ent_canceled_order_preopen (
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
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    l_qry :=
           'SELECT *
      FROM (SELECT customer_table.customer_id,
                   customer_table.customer_name,
                   customer_table.customer_no,
                   customer_table.primary_institute_id,
                   customer_table.symbol,
                   customer_table.order_type,
                   customer_table.t01_last_updated_date_time AS cancellation_time,
                   customer_table.order_quantity,
                   customer_table.order_price,
                   customer_table.t01_date AS order_date,
                   stock_table.closing_price,
                   ROUND (
                       (  (customer_table.order_price - stock_table.closing_price)
                        * 100
                        / stock_table.closing_price),
                       2)
                       AS changed_percentage
              FROM (SELECT t01.t01_symbol_code_m20 AS symbol,
                           t01.t01_customer_id_u01 AS customer_id,
                           u01.u01_display_name AS customer_name,
                           u01.u01_customer_no AS customer_no,
                           m02.m02_primary_institute_id_m02
                               AS primary_institute_id,
                           t01.t01_quantity AS order_quantity,
                           t01.t01_price AS order_price,
                           CASE
                               WHEN t01.t01_side = 1 THEN ''Buy''
                               WHEN t01.t01_side = 2 THEN ''Sell''
                           END
                               AS order_type,
                           t01.t01_date,
                           t01.t01_last_updated_date_time
                      FROM t01_order_all t01
                           JOIN m01_exchanges m01
                               ON t01.t01_exchange_code_m01 =
                                      m01.m01_exchange_code
                           JOIN u01_customer u01
                               ON     t01.t01_customer_id_u01 = u01.u01_id
                                  AND t01.t01_status_id_v30 = ''4''
                                  AND t01.t01_exchange_code_m01 = '''
        || pexchangecode
        || '''
                                  AND t01.t01_date BETWEEN TO_DATE('''
        || pfromdate
        || ''')
                                            AND  TO_DATE('''
        || pfromdate
        || ''')
                                                + 0.99999
                                 AND t01.t01_last_updated_date_time BETWEEN trunc(TO_DATE('''
        || pfromdate
        || ''')) + (60 * SUBSTR (m01.m01_pre_open, 0, 2) + SUBSTR (m01.m01_pre_open, 3, 2)) / 1440  AND TRUNC( TO_DATE('''
        || pfromdate
        || ''')) + (60 * SUBSTR (m01.m01_open, 0, 2) + SUBSTR (m01.m01_open, 3, 2)) / 1440

                            JOIN m02_institute m02
                               ON m02.m02_id = u01.u01_institute_id_m02)
                   customer_table INNER JOIN
                   (SELECT esp.symbol,
                           CASE
                               WHEN esp.todaysclosed = 0 THEN esp.previousclosed
                               ELSE esp.todaysclosed
                           END
                               AS closing_price
                      FROM vw_esp_market_price_today esp
                     WHERE     esp.exchangecode = '''
        || pexchangecode
        || '''
                           AND esp.transactiondate BETWEEN TO_DATE('''
        || pfromdate
        || ''')
                                            AND  TO_DATE('''
        || pfromdate
        || ''')
                                                + 0.99999
                    UNION
                    SELECT esp.symbol, esp.previousclosed AS closing_price
                      FROM vw_esp_market_price_history esp
                     WHERE     esp.exchangecode = '''
        || pexchangecode
        || '''
                           AND esp.transactiondate BETWEEN TO_DATE('''
        || pfromdate
        || ''')
                                            AND  TO_DATE('''
        || pfromdate
        || ''')
                                                + 0.99999)
                    stock_table
             ON customer_table.symbol = stock_table.symbol)';

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
