CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_settle_tax_collection (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    psortby                  VARCHAR2 DEFAULT NULL,
    pfromrownumber           NUMBER DEFAULT NULL,
    ptorownumber             NUMBER DEFAULT NULL,
    psearchcriteria          VARCHAR2 DEFAULT NULL,
    pfromdate                DATE DEFAULT SYSDATE,
    ptodate                  DATE DEFAULT SYSDATE,
    pexchangeid       IN     VARCHAR2)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT u01.u01_external_ref_no,
       u01.u01_id,
       u01.u01_customer_no,
       t02.t02_cash_settle_date AS t02_cash_settle_date,
       u01.u01_full_name AS custname,
       NVL (SUM (t02.t02_exg_commission), 0) AS t02_exg_commission,
       NVL (SUM (t02.t02_commission_adjst - t02.t02_exg_commission), 0)
           AS t02_broker_commission,
       NVL (SUM (t02.t02_commission_adjst), 0) AS t02_commission_adjst,
       NVL (SUM (t02.t02_act_exchange_tax - t02.t02_exchange_tax), 0)
           AS uncollected_exchange_vat,
       NVL (SUM (t02.t02_act_broker_tax - t02.t02_broker_tax), 0)
           AS uncollected_broker_vat,
       NVL (
           SUM (
                 t02.t02_act_exchange_tax
               - t02.t02_exchange_tax
               + t02.t02_act_broker_tax
               - t02.t02_broker_tax),
           0)
           AS uncollected_total_vat,
       NVL (u06.u06_customer_id_u01, 0) AS u06_customer_id_u01,
       m97.m97_description AS m97_description,
       t02_txn_currency,
       TO_DATE('''
        || pfromdate
        || ''') AS from_date,
          TO_DATE('''
        || ptodate
        || ''')   AS to_date
  FROM u01_customer u01,
       m97_transaction_codes m97,
       t02_transaction_log t02,
       u06_cash_account u06,
       m01_exchanges m01
 WHERE     u01.u01_id = u06.u06_customer_id_u01
       AND u06.u06_id = t02.t02_cash_acnt_id_u06
       AND t02.t02_txn_code = m97.m97_code
       AND  t02.t02_exchange_code_m01 = m01.m01_exchange_code'
        || CASE
               WHEN pexchangeid != -1
               THEN
                   ' AND m01.m01_id = ' || pexchangeid || ''
               ELSE
                   ''
           END
        || '
                           AND t02.t02_txn_code NOT IN (''INDCH'') AND t02.t02_cash_settle_date BETWEEN TO_DATE('''
        || pfromdate
        || ''')
                        AND TO_DATE('''
        || ptodate
        || ''') + 0.99999
GROUP BY u01.u01_external_ref_no,
         u01.u01_id,
         u01.u01_customer_no,
         t02_cash_settle_date,
         u01.u01_full_name,
         u06.u06_customer_id_u01,
         m97.m97_description,
         t02_txn_currency';
    prows := 0;

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    DBMS_OUTPUT.put_line (l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/