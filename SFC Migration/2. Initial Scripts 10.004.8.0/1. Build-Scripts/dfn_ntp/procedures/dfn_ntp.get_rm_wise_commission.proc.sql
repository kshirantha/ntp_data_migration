CREATE OR REPLACE PROCEDURE dfn_ntp.get_rm_wise_commission (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    puserfilter           VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT
         m10_code,
         m10_name,
         institute_id_m02,
         number_of_executions,
         ABS (t02_commission_buy - t02_exg_commission_buy)
             AS broker_commission_buy,
         ABS (t02_commission_sell - t02_exg_commission_sell)
             AS broker_commission_sell,
         ABS (t02_commission_buy - t02_exg_commission_buy)
         + ABS (t02_commission_sell - t02_exg_commission_sell)
             AS broker_commission,
         ABS (discount_commission_buy) AS discount_commission_buy,
         ABS (discount_commission_sell) AS discount_commission_sell,
         ABS (discount_commission_buy) + ABS (discount_commission_sell)
             AS discount_commission,
         ABS (t02_commission_buy + discount_commission_buy)
             AS gross_commission_buy,
         ABS (t02_commission_sell + discount_commission_sell)
             AS gross_commission_sell,
         ABS (t02_commission_buy + discount_commission_buy)
         + ABS (t02_commission_sell + discount_commission_sell)
             AS gross_commission,
         ABS (trade_value_buy) AS trade_value_buy,
         ABS (trade_value_sell) AS trade_value_sell,
         ABS (trade_value_buy) + ABS (trade_value_sell) AS trade_value,
         ABS(t02_broker_tax) AS t02_broker_tax,
       ABS (t02_exchange_tax) AS t02_exchange_tax,
         t02_txn_time
  FROM   (  SELECT   m10_code,
                     MAX (m10_name) AS m10_name,
                     MAX (u01_institute_id_m02) as institute_id_m02,
                     SUM (number_of_executions) AS number_of_executions,
                     SUM (t02_commission_buy) AS t02_commission_buy,
                     SUM (t02_commission_sell) AS t02_commission_sell,
                     SUM (t02_exg_commission_buy) AS t02_exg_commission_buy,
                     SUM (t02_exg_commission_sell) AS t02_exg_commission_sell,
                     SUM (discount_commission_buy) AS discount_commission_buy,
                     SUM (discount_commission_sell) AS discount_commission_sell,
                     SUM (t02_amount_buy) AS trade_value_buy,
                     SUM (t02_amount_sell) AS trade_value_sell,
                     SUM (t02_broker_tax) AS t02_broker_tax,
                     SUM (t02_exchange_tax) AS t02_exchange_tax,
                     TO_DATE ('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                              ''DD-MM-YYYY'')
                         AS t02_txn_time
              FROM   (  SELECT   SUM (t02.t02_commission_adjst) AS t02_commission_adjst,
                                 SUM (t02.t02_exg_commission)
                                     AS t02_exg_commission,
                                 SUM (t02.t02_discount)
                                     AS t02_discount,
                                 SUM (t02.t02_amnt_in_stl_currency) AS t02_amnt_in_stl_currency,
                                 COUNT (DISTINCT u01.u01_id)
                                     AS customer_count,
                                 SUM(CASE
                                         WHEN t02_txn_code IN (''STLBUY'')
                                         THEN
                                             t02_amnt_in_stl_currency
                                         ELSE
                                             0
                                     END)
                                     AS t02_amount_buy,
                                 SUM(CASE
                                         WHEN t02_txn_code IN (''STLSEL'')
                                         THEN
                                             t02_amnt_in_stl_currency
                                         ELSE
                                             0
                                     END)
                                     AS t02_amount_sell,
                                 SUM(CASE
                                         WHEN t02_txn_code = ''STLSEL''
                                         THEN
                                             t02_commission_adjst
                                         ELSE
                                             0
                                     END)
                                     AS t02_commission_sell,
                                 SUM(CASE
                                         WHEN t02_txn_code = ''STLBUY''
                                         THEN
                                             t02_commission_adjst
                                         ELSE
                                             0
                                     END)
                                     AS t02_commission_buy,
                                 SUM(CASE
                                         WHEN t02_txn_code = ''STLSEL''
                                         THEN
                                             t02_exg_commission
                                         ELSE
                                             0
                                     END)
                                     AS t02_exg_commission_sell,
                                 SUM(CASE
                                         WHEN t02_txn_code = ''STLBUY''
                                         THEN
                                             t02_exg_commission
                                         ELSE
                                             0
                                     END)
                                     AS t02_exg_commission_buy,
                                 SUM(CASE
                                         WHEN t02_txn_code = ''STLSEL''
                                         THEN
                                             t02_discount
                                         ELSE
                                             0
                                     END)
                                     AS discount_commission_sell,
                                 SUM(CASE
                                         WHEN t02_txn_code = ''STLBUY''
                                         THEN
                                             t02_discount
                                         ELSE
                                             0
                                     END)
                                     AS discount_commission_buy,
                                 COUNT (DISTINCT t02.t02_order_no)
                                     AS number_of_executions,
                                 m10.m10_code,
                                 MAX (m10.m10_name) AS m10_name,
                                 MAX (u01.u01_institute_id_m02) as u01_institute_id_m02,
                                 SUM (t02_broker_tax) AS t02_broker_tax,
                                 SUM (t02_exchange_tax) AS t02_exchange_tax
                          FROM   t02_transact_log_cash_arc_all t02
                           JOIN u06_cash_account u06 ON t02.t02_cash_acnt_id_u06 = u06.u06_id
                           JOIN u01_customer u01 ON u06.u06_customer_id_u01 = u01.u01_id
                           JOIN m10_relationship_manager m10 ON u01.u01_relationship_mngr_id_m10 = m10.m10_id
                         WHERE t02_txn_code IN
                                            (''STLBUY'',
                                             ''STLSEL'')
                               AND t02.t02_create_date BETWEEN TO_DATE (
                                                          '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                                          ''DD-MM-YYYY'')
                                                  AND  TO_DATE (
                                                           '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                                                           ''DD-MM-YYYY'')
                                                       + .99999
                      GROUP BY   m10_code) t02_new
          GROUP BY   m10_code)';

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    -- insert into temp (col_1) values (s1);

    OPEN p_view FOR s1;


    EXECUTE IMMEDIATE s2 INTO prows;
END;
/