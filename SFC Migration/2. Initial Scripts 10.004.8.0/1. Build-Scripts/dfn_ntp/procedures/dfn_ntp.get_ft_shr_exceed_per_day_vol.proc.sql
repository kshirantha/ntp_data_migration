CREATE OR REPLACE PROCEDURE dfn_ntp.get_ft_shr_exceed_per_day_vol (
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
  FROM (SELECT order_table.symbol,
               order_table.exchange_volume,
               order_table.closing_price,
               order_table.ft_volume,
               order_table.ft_percentage,
               order_table.client_volume,
               order_table.client_percentage,
               order_table.order_date,
               u01.u01_id,
               u01.u01_display_name,
               u01.u01_customer_no,
               m02.m02_primary_institute_id_m02 as primary_institute_id
          FROM (SELECT ft_table.symbol,
                       ft_table.exchange_volume,
                       ROUND (ft_table.closing_price, 2) AS closing_price,
                       ft_table.cum_quantity AS ft_volume,
                       ft_table.ft_percentage,
                       client_table.cum_quantity AS client_volume,
                       client_table.t01_date AS order_date,
                       client_table.t01_customer_id_u01,
                       ROUND (
                             (  client_table.cum_quantity
                              / ft_table.cum_quantity)
                           * 100,
                           2)
                           AS client_percentage
                  FROM (SELECT stock_table.symbol,
                               stock_table.volume AS exchange_volume,
                               stock_table.closing_price,
                               order_table.cum_quantity,
                               ROUND (
                                     (  order_table.cum_quantity
                                      / stock_table.volume)
                                   * 100,
                                   2)
                                   AS ft_percentage
                          FROM (SELECT t01.t01_symbol_code_m20,
                                       SUM (t01.t01_cum_quantity)
                                           AS cum_quantity
                                  FROM t01_order_all t01
                                 WHERE     t01.t01_exchange_code_m01 = '''
        || pexchangecode
        || '''
                                       AND t01.t01_status_id_v30 IN (''1'',
                                                                     ''2'',
                                                                     ''q'',
                                                                     ''r'',
                                                                     ''5'')
                                       AND t01.t01_date BETWEEN TO_DATE('''
        || pfromdate
        || ''')
                                        AND  TO_DATE('''
        || pfromdate
        || ''')
                                            + 0.99999
                                GROUP BY t01.t01_symbol_code_m20) order_table,
                               (SELECT esp.symbol,
                                       esp.volume,
                                       CASE
                                           WHEN esp.todaysclosed = 0
                                           THEN
                                               esp.previousclosed
                                           ELSE
                                               esp.todaysclosed
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
                                       esp.volume,
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
                                            + 0.99999 ) stock_table
                         WHERE     order_table.t01_symbol_code_m20 =
                                       stock_table.symbol
                               AND stock_table.volume > 0
                               AND (  order_table.cum_quantity
                                    / stock_table.volume) >= 0.25) ft_table,
                       (SELECT t01.t01_symbol_code_m20,
                               t01.t01_customer_id_u01,
                               SUM (t01.t01_cum_quantity) AS cum_quantity,
                               MAX (t01.t01_date) AS t01_date
                          FROM t01_order_all t01
                         WHERE     t01.t01_exchange_code_m01 = '''
        || pexchangecode
        || '''
                               AND t01.t01_status_id_v30 IN (''1'',
                                                             ''2'',
                                                             ''q'',
                                                             ''r'',
                                                             ''5'')
                               AND t01.t01_date BETWEEN TO_DATE('''
        || pfromdate
        || ''')
                                        AND  TO_DATE('''
        || pfromdate
        || ''')
                                            + 0.99999
                        GROUP BY t01.t01_symbol_code_m20,
                                 t01.t01_customer_id_u01) client_table
                 WHERE ft_table.symbol = client_table.t01_symbol_code_m20)
               order_table,
               u01_customer u01,
               m02_institute m02
         WHERE order_table.t01_customer_id_u01 = u01.u01_id
                AND u01.u01_institute_id_m02 = m02.m02_id)';


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
