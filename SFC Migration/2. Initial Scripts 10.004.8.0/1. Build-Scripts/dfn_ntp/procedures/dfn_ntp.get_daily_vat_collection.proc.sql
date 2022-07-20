CREATE OR REPLACE PROCEDURE dfn_ntp.get_daily_vat_collection (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE,
    ptodate               DATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT
T02_CASH_SETTLE_DATE,
SUM(total_vat)      AS total_vat,
SUM(ord_vat)        AS ord_vat,
SUM(stk_trns_vat)   AS stk_trns_vat,
SUM(sub_vat)        AS sub_vat,
SUM(pledge_in_vat)  AS pledge_in_vat,
SUM(pledge_out_vat) AS pledge_out_vat,
SUM(other_vat)      AS other_vat,
t02_inst_id_m02
FROM (SELECT
T02_CASH_SETTLE_DATE,
CASE
WHEN T02_TXN_CODE IN (''STLBUY'', ''STLSEL'')
THEN
 (T02_BROKER_TAX + T02_EXCHANGE_TAX)
ELSE
0
END
                                 AS ord_vat,
CASE
WHEN T02_TXN_CODE IN (''STPFEE'')
THEN
 (T02_BROKER_TAX + T02_EXCHANGE_TAX)
ELSE
0
END
                                 AS stk_trns_vat,
CASE
WHEN T02_TXN_CODE IN (''SUBFEE'')
THEN
 (T02_BROKER_TAX + T02_EXCHANGE_TAX)
ELSE
0
END
                                 AS sub_vat,
CASE
WHEN T02_TXN_CODE IN (''PLGIN'')
THEN
 (T02_BROKER_TAX + T02_EXCHANGE_TAX)
ELSE
0
END
                                 AS pledge_in_vat,
CASE
WHEN T02_TXN_CODE IN (''PLGOUT'')
THEN
 (T02_BROKER_TAX + T02_EXCHANGE_TAX)
ELSE
0
END
                                 AS pledge_out_vat,
CASE
WHEN T02_TXN_CODE NOT IN
  (''STLBUY'',
   ''STLSEL'',
   ''STPFEE'',
   ''SUBFEE'',
   ''PLGIN'',
   ''PLGOUT'')
THEN
  NVL((T02_BROKER_TAX + T02_EXCHANGE_TAX),0)
ELSE
0
END
                                 AS other_vat,
NVL((T02_BROKER_TAX + T02_EXCHANGE_TAX),0)  AS total_vat,
T02_INST_ID_M02
FROM T02_TRANSACTION_LOG_CASH
WHERE T02_CASH_SETTLE_DATE BETWEEN TO_DATE(
'''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
''DD-MM-YYYY'')
 AND TO_DATE(
         '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
         ''DD-MM-YYYY'')
     + 0.99999
 AND T02_CREATE_DATE BETWEEN TO_DATE(
                                 '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                 ''DD-MM-YYYY'')
                             - 10
 AND TO_DATE(
         '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
         ''DD-MM-YYYY'')
     + 0.99999)
GROUP BY T02_CASH_SETTLE_DATE, T02_INST_ID_M02';

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