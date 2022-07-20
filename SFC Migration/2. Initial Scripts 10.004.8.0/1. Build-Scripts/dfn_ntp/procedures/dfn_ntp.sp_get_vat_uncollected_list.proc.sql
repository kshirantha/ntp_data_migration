CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_vat_uncollected_list (
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
    l_qry :=
           '
SELECT u01.u01_external_ref_no,
       u06.u06_external_ref_no,
       t02.t02_create_date AS t02_date,
       u01.u01_full_name AS custname,
       CASE
           WHEN u01.u01_account_category_id_v01 = 0 THEN ''Individual''
           WHEN u01.u01_account_category_id_v01 = 1 THEN ''Joint Account''
           WHEN u01.u01_account_category_id_v01 = 2 THEN ''Corporate''
           ELSE ''Unknown''
       END
           AS acctype,
       NVL (SUM (t02.t02_exg_commission), 0) AS t02_exg_commission,
       NVL (SUM (t02.t02_cum_commission - t02.t02_exg_commission), 0)
           AS t02_broker_commission,
       NVL (SUM (t02.t02_exg_commission), 0) AS t02_commission,
       NVL (SUM (t02.t02_exchange_tax), 0) AS t02_act_exchange_vat,
       NVL (SUM (t02.t02_broker_tax), 0) AS t02_act_broker_vat,
       NVL (SUM (t02.t02_commission_adjst), 0) AS t02_commission_discount,
       NVL (SUM (t02.t02_amnt_in_stl_currency), 0) AS fee_amount,
       t02.t02_txn_currency,
       m05.m05_name AS nationalitycountry,
       u01.u01_tax_ref,
         NVL (SUM (t02.t02_exchange_tax), 0)
       + NVL (SUM (t02.t02_broker_tax), 0)
           AS tot_vat,
       CASE
           WHEN (t02.t02_order_no != 0 AND t02.t02_order_no IS NOT NULL)
           THEN
               t02.t02_order_no
           ELSE
               NULL
       END
           AS order_no,
       m97.m97_description_lang AS transaction_type,
       MAX(u01.u01_institute_id_m02) AS u01_institute_id_m02,
       MAX(u01_id) AS u01_id
  FROM u01_customer u01
       JOIN u06_cash_account u06 ON u01.u01_id = u06.u06_customer_id_u01
       JOIN t02_transaction_log_all t02 ON u06.u06_id = t02.t02_cash_acnt_id_u06
       JOIN m97_transaction_codes m97 ON t02.t02_txn_code = m97.m97_code
       LEFT OUTER JOIN m05_country m05 ON u01.u01_nationality_id_m05 = m05.m05_id
 WHERE u06.u06_vat_waive_off = 1
       AND t02.t02_create_date BETWEEN TO_DATE('''
        || pfromdate
        || ''')
                        AND TO_DATE('''
        || ptodate
        || ''') + 0.99999
GROUP BY u01.u01_external_ref_no,
         u06.u06_external_ref_no,
         t02.t02_create_date,
         u01.u01_full_name,
         u01.u01_account_category_id_v01,
         m97.m97_description_lang,
         t02.t02_txn_currency,
         m05.m05_name,
         u01.u01_tax_ref,
         t02.t02_order_no';

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