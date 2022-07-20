CREATE OR REPLACE PROCEDURE dfn_ntp.get_vat_by_customer (
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
BEGIN
    l_qry :=
           'SELECT
          u01.u01_id,
          u01.U01_EXTERNAL_REF_NO,
          u01.U01_FULL_NAME,
          m15.M15_NAME as id_type,
          u01.U01_DEFAULT_ID_TYPE_M15,
		  u01.u01_default_id_no,
          u01.U01_TAX_REF,
          u01.U01_INSTITUTE_ID_M02,
          NVL(vat.total_vat, 0)                                               AS total_vat,
          NVL(vat.ord_vat, 0)                                                 AS ord_vat,
          NVL(vat.stk_trns_vat, 0)                                            AS stk_trns_vat,
          NVL(vat.sub_vat, 0)                                                 AS sub_vat,
          NVL(vat.pledge_in_vat, 0)                                           AS pledge_in_vat,
          NVL(vat.pledge_out_vat, 0)                                          AS pledge_out_vat,
          NVL(vat.other_vat, 0)                                               AS other_vat,
          TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') AS from_date,
          TO_DATE('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')   AS TO_DATE,
          (NVL(exg_fee, 0) * 0.032)                                           AS cma_vat
        FROM U01_CUSTOMER u01,
          M15_IDENTITY_TYPE m15,
          (SELECT
             U06_CUSTOMER_ID_U01,
             SUM(total_vat)      AS total_vat,
             SUM(ord_vat)        AS ord_vat,
             SUM(stk_trns_vat)   AS stk_trns_vat,
             SUM(sub_vat)        AS sub_vat,
             SUM(pledge_in_vat)  AS pledge_in_vat,
             SUM(pledge_out_vat) AS pledge_out_vat,
             SUM(other_vat)      AS other_vat,
             SUM(exg_fee)        AS exg_fee
           FROM (SELECT
                   T02_CASH_ACNT_ID_U06,
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
                       (T02_BROKER_TAX + T02_EXCHANGE_TAX)
                   ELSE
                     0
                   END
                                                       AS other_vat,
                   (T02_BROKER_TAX + T02_EXCHANGE_TAX) AS total_vat,
                   CASE
                   WHEN T02_TXN_CODE IN (''STLBUY'', ''STLSEL'')
                     THEN
                       (T02_EXG_COMMISSION)
                   ELSE
                     0
                   END
                                                       AS exg_fee
                 FROM T02_TRANSACTION_LOG_CASH
                 WHERE T02_CASH_SETTLE_DATE BETWEEN

                       TO_DATE('''
        || TO_CHAR (pfromdate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '')
                       AND TO_DATE('''
        || TO_CHAR (ptodate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '') + 0.99999
                       AND
                       T02_CREATE_DATE BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '') -
                                             10
                       AND TO_DATE('''
        || TO_CHAR (ptodate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '') + 0.99999) t02,
             U06_CASH_ACCOUNT u06
           WHERE t02.T02_CASH_ACNT_ID_U06 = u06.U06_ID
           GROUP BY u06.U06_CUSTOMER_ID_U01) vat
        WHERE u01.U01_DEFAULT_ID_TYPE_M15 = m15.m15_id
              AND u01.U01_ID = vat.U06_CUSTOMER_ID_U01';

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
           'SELECT t2.* FROM (SELECT t1.*, ROWNUM rnum FROM (SELECT t3.* '
        || CASE
               WHEN psortby IS NOT NULL
               THEN
                   ', ROW_NUMBER() OVER(ORDER BY ' || psortby || ') runm'
               ELSE
                   ''
           END
        || ' FROM ('
        || l_qry
        || ') t3'
        || CASE
               WHEN psearchcriteria IS NOT NULL
               THEN
                   ' WHERE ' || psearchcriteria
               ELSE
                   ''
           END
        || ') t1 WHERE ROWNUM <= '
        || ptorownumber
        || ') t2 WHERE RNUM >= '
        || pfromrownumber;
END;
/
/
