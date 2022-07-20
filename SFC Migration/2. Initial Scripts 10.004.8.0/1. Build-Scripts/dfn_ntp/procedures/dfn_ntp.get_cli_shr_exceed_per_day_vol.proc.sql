CREATE OR REPLACE PROCEDURE dfn_ntp.get_cli_shr_exceed_per_day_vol (
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
               customer_table.order_date,
               customer_table.customer_volume,
               stock_table.tdwl_volume,
               stock_table.closing_price,
               ROUND (
                   (  (  customer_table.customer_volume
                       / stock_table.tdwl_volume)
                    * 100),
                   2)
                   AS client_percentage
          FROM (SELECT t01.t01_symbol_code_m20 AS symbol,
                       t01.t01_customer_id_u01 AS customer_id,
                       MAX (t01.t01_date) AS order_date,
                       MAX (u01.u01_display_name) AS customer_name,
                       MAX (u01.u01_customer_no) AS customer_no,
                       MAX (t01.t01_cum_quantity) AS customer_volume,
                       MAX (m02.m02_primary_institute_id_m02)
                           AS primary_institute_id
                  FROM t01_order t01
                       JOIN u01_customer u01
                           ON     t01.t01_customer_id_u01 = u01.u01_id
                              AND t01.t01_status_id_v30 IN (''1'',
                                                            ''2'',
                                                            ''q'',
                                                            ''r'')
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
                        JOIN m02_institute m02
                           ON m02.m02_id = u01.u01_institute_id_m02
                GROUP BY t01.t01_symbol_code_m20, t01.t01_customer_id_u01)
               customer_table,
               (SELECT esp.symbol,
                       esp.volume AS tdwl_volume,
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
                SELECT esp.symbol,
                       esp.volume AS tdwl_volume,
                       esp.previousclosed AS closing_price
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
         WHERE     customer_table.symbol = stock_table.symbol
               AND stock_table.tdwl_volume > 0
               AND (customer_table.customer_volume / stock_table.tdwl_volume ) >= 0.10
                                              )';


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