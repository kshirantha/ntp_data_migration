CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_lst_mnt_price_chg_ords (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    pfromdate         IN     DATE,
    ptodate           IN     DATE,
    psortby           IN     VARCHAR2 DEFAULT NULL,
    pfromrownumber    IN     NUMBER,
    ptorownumber      IN     NUMBER,
    psearchcriteria   IN     VARCHAR2 DEFAULT NULL,
    pexchangecode     IN     VARCHAR2)
IS
    l_quantity               NUMBER := 0;
    l_cumordervalue          NUMBER := 15000;
    l_qry                    VARCHAR2 (15000);
    s1                       VARCHAR2 (15000);
    s2                       VARCHAR2 (15000);
    l_maximum_gtd_validity   NUMBER (10);
BEGIN
    SELECT NVL (MAX (v00_value), 90)
      INTO l_maximum_gtd_validity
      FROM v00_sys_config
     WHERE v00_key = 'MAXIMUM_GTD_VALIDITY';

    prows := 0;
    l_qry :=
           'select * from ( SELECT   u01.U01_ID AS customer_id,    m02.m02_primary_institute_id_m02 AS primary_institute_id,
                           ord_details.T01_LAST_UPDATED_DATE_TIME AS order_date,
                           ord_details.T01_ORD_NO AS order_no,
                           ord_details.T01_TRADING_ACC_ID_U07 AS portfolio_no,
                           ord_details.T01_CUM_QUANTITY AS order_qty,
                           ord_details.T01_LAST_PRICE AS price,
                           ord_details.T01_SYMBOL_CODE_M20 AS symbol,
                           ord_details.open AS ltp,
                           CASE
                               WHEN ord_details.t01_side = 1 THEN ''Buy''
                               WHEN ord_details.t01_side = 2 THEN ''Sell''
                           END
                               AS ord_side,
                           ROUND ( (ord_details.T01_LAST_PRICE - ord_details.open) * 100 / ord_details.T01_LAST_PRICE, 2) AS pct_change, ord_details.T01_CUSTOMER_ID_U01,
                           u01.U01_DISPLAY_NAME AS customer_name,
                           ROUND (ord_details.T01_LAST_PRICE * ord_details.T01_CUM_QUANTITY)
                               AS order_value, u01.u01_customer_no
                    FROM   U01_CUSTOMER u01, m02_institute m02,
                           (SELECT   *
                              FROM   DFN_PRICE.esp_intraday_ohlc ohlc,
                                     (SELECT   *
                                        FROM   t01_order_all b
                                        JOIN m01_exchanges m01
                                        ON b.t01_exchange_code_m01 =
                                            m01.m01_exchange_code
                                       WHERE   b.T01_QUANTITY > '
        || l_quantity
        || '
                                               AND b.T01_CUM_ORD_VALUE >= '
        || l_cumordervalue
        || '
                                               AND b.T01_EXCHANGE_CODE_M01 =
                                                   '''
        || pexchangecode
        || '''
                                               AND b.T01_LAST_UPDATED_DATE_TIME BETWEEN TO_DATE (TO_CHAR (TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY''), ''DD/MM/YYYY'') || '' '' || m01.m01_close, ''DD/MM/YYYY HH24MI'') - 1 / (24 * 60)
                                               AND TO_DATE (TO_CHAR (TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY''), ''DD/MM/YYYY'') || '' '' || m01.m01_close, ''DD/MM/YYYY HH24MI'')
                                               AND ( (b.T01_STATUS_ID_V30 IN
                                                              (''1'',
                                                               ''2'',
                                                               ''q'',
                                                               ''r''))
                                                    OR (b.T01_STATUS_ID_V30 IN
                                                                (''5'',
                                                                 ''4'',
                                                                 ''C'',
                                                                 ''8'',
                                                                 ''9'')
                                                        AND b.T01_CUM_QUANTITY >
                                                               0))
                                               AND b.t01_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate - l_maximum_gtd_validity, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'')
                                                                        AND  TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'')
                                                                             + 0.99999
                                             AND b.T01_LAST_UPDATED_DATE_TIME BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'')
                                                                        AND  TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'')
                                                                             + 0.99999
                                             AND b.T01_LAST_PRICE <>
                                                    b.t01_price)
                                   t01
                           WHERE       ohlc.symbol = t01.T01_SYMBOL_CODE_M20
                                   AND ohlc.trade_min > t01.T01_LAST_UPDATED_DATE_TIME
                                   AND ohlc.close = t01.T01_LAST_PRICE
                                   AND ABS ( (t01.T01_LAST_PRICE - ohlc.open)
                                            / t01.T01_LAST_PRICE) >= 0.01)
                         ord_details
                 WHERE   ord_details.T01_CUSTOMER_ID_U01 = u01.U01_ID AND u01.u01_institute_id_m02 = m02.m02_id)';

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber
                             );
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/