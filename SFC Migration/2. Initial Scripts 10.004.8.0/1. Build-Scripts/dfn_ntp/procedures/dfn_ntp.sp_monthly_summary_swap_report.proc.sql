CREATE OR REPLACE PROCEDURE dfn_ntp.sp_monthly_summary_swap_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT * FROM (SELECT settlementdate,
         months,
         COUNT (buyqty) AS buytransactions,
         SUM (buyqty) AS buyqty,
         ABS (SUM (buyamount)) AS buyamt,
         NVL (ABS (SUM (buyamount)) * SUM (buyqty), 0) AS totalvaluebuy,
         COUNT (sellqty) AS selltransactions,
         NVL (SUM (sellqty), 0) AS sellqty,
         NVL (SUM (sellamount), 0) AS sellamt,
         NVL (ROUND (SUM (sellamount) * SUM (sellqty), 2), 0) AS totalvaluesell,
         t02_inst_id_m02
    FROM (SELECT a.t02_cash_settle_date AS settlementdate,
                 TO_CHAR (a.t02_cash_settle_date, ''MON'') AS months,
                 CASE WHEN a.t02_txn_code = ''STLBUY'' THEN a.t02_ordqty END
                     AS buyqty,
                 CASE
                     WHEN a.t02_txn_code = ''STLBUY'' -- t05_code
                     THEN
                         a.t02_cumord_netsettle
                 END
                     AS buyamount,
                 CASE WHEN a.t02_txn_code = ''STLSEL'' THEN a.t02_ordqty END
                     AS sellqty,
                 CASE
                     WHEN a.t02_txn_code = ''STLSEL''
                     THEN
                         a.t02_cumord_netsettle
                 END
                     AS sellamount,
                 a.t02_inst_id_m02
            FROM t02_transaction_log_cash a
           WHERE     a.t02_txn_code IN (''STLBUY'', ''STLSEL'')
                 AND a.t02_cash_settle_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'MM/DD/YYYY')
        || ''',
                                      ''MM/DD/YYYY'')
                                                      AND   TO_DATE ('''
        || TO_CHAR (ptodate, 'MM/DD/YYYY')
        || ''',
                                        ''MM/DD/YYYY'')
                                                          + 0.99999)
GROUP BY settlementdate, months, t02_inst_id_m02
ORDER BY settlementdate)';

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