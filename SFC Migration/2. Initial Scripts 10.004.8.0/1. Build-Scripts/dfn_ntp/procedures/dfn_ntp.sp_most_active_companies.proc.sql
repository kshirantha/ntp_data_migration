CREATE OR REPLACE PROCEDURE dfn_ntp.sp_most_active_companies (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    psortby                   VARCHAR2 DEFAULT NULL,
    pfromrownumber            NUMBER DEFAULT NULL,
    ptorownumber              NUMBER DEFAULT NULL,
    psearchcriteria           VARCHAR2 DEFAULT NULL,
    pexchange                 VARCHAR2,
    pfromdate                 DATE DEFAULT SYSDATE,
    pcompanycount             NUMBER,
    pprimaryinstitution       NUMBER)
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    IF TRUNC (pfromdate) = TRUNC (SYSDATE)
    THEN
        l_qry :=
               'SELECT   *
                  FROM   (SELECT   1 AS category,
                         ''Most Active by Value'' AS description,
                         TRUNC (SYSDATE) AS tdate,
                         m20_symbol_code,
                         m20_short_description,
                         m20_short_description_lang,
                         institute_id_m02,
                         market_value,
                         brokarage_value,
                         CASE
                             WHEN market_value <> 0
                             THEN
                                 ROUND ( (brokarage_value * 100) / market_value, 8)
                             ELSE
                                 0
                         END
                             AS brokarage_percentage,
                         market_trades,
                         brokarage_trade_count,
                         CASE
                             WHEN market_trades <> 0
                             THEN
                                 ROUND (brokarage_trade_count * 100 / market_trades)
                             ELSE
                                 0
                         END
                             AS brokarage_trade_percentage,
                         ROW_NUMBER () OVER (ORDER BY market_value DESC) AS rownumber
                  FROM   (SELECT   m20.m20_symbol_code,
                                   m20.m20_short_description,
                                   m20.m20_short_description_lang,
                                   m20.m20_institute_id_m02 as institute_id_m02,
                                   NVL (esp.volume, 0) * NVL (esp.lasttradedprice, 0) * 2 AS market_value,
                                   NVL (t02.brokarage_value, 0) AS brokarage_value,
                                   NVL (esp.nooftrades, 0) * 2 AS market_trades,
                                   NVL (t02.brokarage_trade_count, 0) AS brokarage_trade_count
                            FROM   vw_esp_market_price_today esp
                                 JOIN   m20_symbol m20 ON esp.exchangecode = m20.m20_exchange_code_m01
                                   AND esp.symbol = m20.m20_symbol_code AND m20.m20_institute_id_m02 = '
            || pprimaryinstitution
            || '
                                   LEFT JOIN (SELECT   t02_inst_id_m02, t02.t02_symbol_code_m20 AS symbol,
                                               SUM (ABS (t02.t02_amnt_in_stl_currency)) AS brokarage_value,
                                               COUNT (t02.t02_order_no) AS brokarage_trade_count
                                        FROM   t02_transact_log_cash_arc_all t02
                                       WHERE   t02.t02_inst_id_m02 = '
            || pprimaryinstitution
            || '
                                               AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'')
                                               AND t02.t02_txn_time BETWEEN TRUNC (SYSDATE)
                                                                AND  TRUNC (SYSDATE) + 0.99999
                                               AND t02.t02_exchange_code_m01 = '''
            || pexchange
            || '''
                                    GROUP BY   t02.t02_symbol_code_m20, t02_inst_id_m02) t02 ON esp.symbol = t02.symbol
                                    AND esp.exchangecode = '''
            || pexchange
            || '''
                                    AND t02_inst_id_m02 = m20.m20_institute_id_m02)
                UNION ALL
                SELECT   2 AS category,
                         ''Most Active by Trades'' AS description,
                         TRUNC (SYSDATE) AS tdate,
                         m20_symbol_code,
                         m20_short_description,
                         m20_short_description_lang,
                         institute_id_m02,
                         market_value,
                         brokarage_value,
                         CASE
                             WHEN market_value <> 0
                             THEN
                                 ROUND ( (brokarage_value * 100) / market_value, 8)
                             ELSE
                                 0
                         END
                             AS brokarage_percentage,
                         market_trades,
                         brokarage_trade_count,
                         CASE
                             WHEN market_trades <> 0
                             THEN
                                 ROUND (brokarage_trade_count * 100 / market_trades)
                             ELSE
                                 0
                         END
                             AS brokarage_trade_percentage,
                         ROW_NUMBER () OVER (ORDER BY market_trades DESC) AS rownumber
                  FROM   (SELECT   m20.m20_symbol_code,
                                   m20.m20_short_description,
                                   m20.m20_short_description_lang,
                                   m20.m20_institute_id_m02 as institute_id_m02,
                                   NVL (esp.volume, 0) * NVL (esp.lasttradedprice, 0) * 2 AS market_value,
                                   NVL (t02.brokarage_value, 0) AS brokarage_value,
                                   NVL (esp.nooftrades, 0) * 2 AS market_trades,
                                   NVL (t02.brokarage_trade_count, 0) AS brokarage_trade_count
                            FROM   vw_esp_market_price_today esp
                                 JOIN   m20_symbol m20 ON esp.exchangecode = m20.m20_exchange_code_m01
                                   AND esp.symbol = m20.m20_symbol_code AND m20.m20_institute_id_m02 = '
            || pprimaryinstitution
            || '
                                   LEFT JOIN (SELECT  t02_inst_id_m02, t02.t02_symbol_code_m20 AS symbol,
                                               SUM (ABS (t02.t02_amnt_in_stl_currency)) AS brokarage_value,
                                               COUNT (t02.t02_order_no) AS brokarage_trade_count
                                        FROM   t02_transact_log_cash_arc_all t02
                                       WHERE   t02.t02_inst_id_m02 = '
            || pprimaryinstitution
            || '
                                               AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'')
                                               AND t02.t02_txn_time BETWEEN TRUNC (SYSDATE)
                                                                AND  TRUNC (SYSDATE) + 0.99999
                                               AND t02.t02_exchange_code_m01 = '''
            || pexchange
            || '''
                                    GROUP BY   t02.t02_symbol_code_m20,t02_inst_id_m02) t02 ON esp.symbol = t02.symbol
                                    AND esp.exchangecode = '''
            || pexchange
            || '''
                                      AND t02_inst_id_m02 = m20.m20_institute_id_m02))
                 WHERE   rownumber <= '
            || pcompanycount;
    ELSE
        l_qry :=
               'SELECT   *
                  FROM   (SELECT   1 AS category,
                         ''Most Active by Value'' AS description,
                         TRUNC(TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''',''DD-MM-YYYY'')) AS tdate,
                         m20_symbol_code,
                         m20_short_description,
                         m20_short_description_lang,
                         institute_id_m02,
                         market_value,
                         brokarage_value,
                         CASE
                             WHEN market_value <> 0
                             THEN
                                 ROUND ( (brokarage_value * 100) / market_value, 8)
                             ELSE
                                 0
                         END
                             AS brokarage_percentage,
                         market_trades,
                         brokarage_trade_count,
                         CASE
                             WHEN market_trades <> 0
                             THEN
                                 ROUND (brokarage_trade_count * 100 / market_trades)
                             ELSE
                                 0
                         END
                             AS brokarage_trade_percentage,
                         ROW_NUMBER () OVER (ORDER BY market_value DESC) AS rownumber
                  FROM   (SELECT   m20.m20_symbol_code,
                                   m20.m20_short_description,
                                   m20.m20_short_description_lang,
                                   m20.m20_institute_id_m02 as institute_id_m02,
                                   NVL (esp.volume, 0) * NVL (esp.market_price, 0) * 2 AS market_value,
                                   NVL (t02.brokarage_value, 0) AS brokarage_value,
                                   NVL (esp.nooftrades, 0) * 2 AS market_trades,
                                   NVL (t02.brokarage_trade_count, 0) AS brokarage_trade_count
                            FROM  (SELECT * FROM vw_esp_market_price_history
                           WHERE   transactiondate
                           BETWEEN TRUNC(TO_DATE ( '''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''',''DD-MM-YYYY''))
                           AND  TRUNC(TO_DATE ( '''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'')) + 0.99999) esp
                          LEFT JOIN  m20_symbol m20 ON esp.exchangecode = m20.m20_exchange_code_m01
                          AND esp.symbol = m20.m20_symbol_code AND m20.m20_institute_id_m02 = '
            || pprimaryinstitution
            || '
                           LEFT JOIN (SELECT   t02_inst_id_m02,t02.t02_symbol_code_m20 AS symbol,
                                               SUM (ABS (t02.t02_amnt_in_stl_currency)) AS brokarage_value,
                                               COUNT (t02.t02_order_no) AS brokarage_trade_count
                                        FROM   t02_transact_log_cash_arc_all t02
                                       WHERE   t02.t02_inst_id_m02 = '
            || pprimaryinstitution
            || '
                                               AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'')
                                       AND t02.t02_txn_time
                                       BETWEEN TRUNC(TO_DATE ( '''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''',''DD-MM-YYYY''))
                                       AND  TRUNC(TO_DATE ( '''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''',''DD-MM-YYYY'')) + 0.99999
                                       AND t02_exchange_code_m01 = '''
            || pexchange
            || '''

                                    GROUP BY  t02.t02_symbol_code_m20,t02_inst_id_m02) t02 ON esp.symbol = t02.symbol AND esp.exchangecode = '''
            || pexchange
            || '''
                                    And t02_inst_id_m02 = m20.m20_institute_id_m02)
                UNION ALL
                SELECT   2 AS category,
                         ''Most Active by Trades'' AS description,
                         TRUNC(TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''',''DD-MM-YYYY'')) AS tdate,
                         m20_symbol_code,
                         m20_short_description,
                         m20_short_description_lang,
                         institute_id_m02,
                         market_value,
                         brokarage_value,
                         CASE
                             WHEN market_value <> 0
                             THEN
                                 ROUND ( (brokarage_value * 100) / market_value, 8)
                             ELSE
                                 0
                         END
                             AS brokarage_percentage,
                         market_trades,
                         brokarage_trade_count,
                         CASE
                             WHEN market_trades <> 0
                             THEN
                                 ROUND (brokarage_trade_count * 100 / market_trades)
                             ELSE
                                 0
                         END
                             AS brokarage_trade_percentage,
                         ROW_NUMBER () OVER (ORDER BY market_trades DESC) AS rownumber
                  FROM   (SELECT   m20.m20_symbol_code,
                                   m20.m20_short_description,
                                   m20.m20_short_description_lang,
                                   m20.m20_institute_id_m02 as institute_id_m02,
                                   NVL (esp.volume, 0) * NVL (esp.market_price, 0) * 2
                                       AS market_value,
                                   NVL (t02.brokarage_value, 0) AS brokarage_value,
                                   NVL (esp.nooftrades, 0) * 2 AS market_trades,
                                   NVL (t02.brokarage_trade_count, 0)
                                       AS brokarage_trade_count
                            FROM   (SELECT * FROM   vw_esp_market_price_history
                           WHERE   transactiondate
                           BETWEEN TRUNC(TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY''))
                           AND  TRUNC(TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''',''DD-MM-YYYY''))+ 0.99999) esp
                          LEFT JOIN  m20_symbol m20 ON esp.exchangecode = m20.m20_exchange_code_m01
                          AND esp.symbol = m20.m20_symbol_code AND m20.m20_institute_id_m02 = '
            || pprimaryinstitution
            || '
                           LEFT JOIN  (  SELECT  t02_inst_id_m02, t02.t02_symbol_code_m20 AS symbol,
                                               SUM (ABS (t02.t02_amnt_in_stl_currency)) AS brokarage_value,
                                               COUNT (t02.t02_order_no) AS brokarage_trade_count
                                        FROM   t02_transact_log_cash_arc_all t02
                                       WHERE   t02.t02_inst_id_m02 = '
            || pprimaryinstitution
            || '
                                               AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'')
                                               AND t02.t02_txn_time
                                               BETWEEN TRUNC(TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''',''DD-MM-YYYY''))
                                               AND  TRUNC(TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'')) + 0.99999
                                               AND t02_exchange_code_m01 = '''
            || pexchange
            || '''

                                    GROUP BY   t02.t02_symbol_code_m20,t02_inst_id_m02) t02   ON esp.symbol = t02.symbol AND esp.exchangecode = '''
            || pexchange
            || '''
                                     AND t02_inst_id_m02 = m20.m20_institute_id_m02))
                 WHERE   rownumber <= '
            || pcompanycount;
    END IF;

    DBMS_OUTPUT.put_line (l_qry);

    IF (pfromrownumber IS NOT NULL)
    THEN
        IF (pfromrownumber = 1)
        THEN
            EXECUTE IMMEDIATE
                   'SELECT COUNT ( * ) FROM ('
                || l_qry
                || ')'
                || CASE
                       WHEN psearchcriteria IS NOT NULL
                       THEN
                           ' WHERE ' || psearchcriteria
                       ELSE
                           ''
                   END
                INTO prows;
        ELSE
            prows := -2;
        END IF;


        OPEN p_view FOR
               'SELECT t2.* FROM (SELECT t1.*, ROWNUM rn FROM (SELECT * FROM ('
            || l_qry
            || CASE
                   WHEN psearchcriteria IS NOT NULL
                   THEN
                       ') WHERE ' || psearchcriteria
                   ELSE
                       ') '
               END
            || ') t1 WHERE ROWNUM <= '
            || ptorownumber
            || ') t2 WHERE rn >= '
            || pfromrownumber;
    ELSE
        OPEN p_view FOR
               'SELECT * FROM ('
            || l_qry
            || CASE
                   WHEN psearchcriteria IS NOT NULL
                   THEN
                       ') WHERE ' || psearchcriteria
                   ELSE
                       ')'
               END;
    END IF;
END;
/
