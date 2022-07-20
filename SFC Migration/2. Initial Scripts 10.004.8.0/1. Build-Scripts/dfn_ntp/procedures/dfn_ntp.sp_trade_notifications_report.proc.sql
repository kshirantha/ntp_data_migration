CREATE OR REPLACE PROCEDURE dfn_ntp.sp_trade_notifications_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    ptradingacc           NUMBER DEFAULT NULL,
    psymbol               NUMBER DEFAULT NULL)
IS
    l_qry   VARCHAR2 (10000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT
       u01.U01_EXTERNAL_REF_NO,
       u01.u01_full_name,
       u01.u01_full_name_lang,
       u01_account_category_id_v01,
       u01.u01_institute_id_m02,
       m07.m07_location_code  AS m07_location_code,
       u02.u02_po_box,
       u02.u02_zip_code,
       u02.u02_address_line1,
       u02.u02_address_line1_lang,
       u02.u02_address_line2,
       u02.u02_address_line2_lang,
       m05.m05_name,
       m05.m05_name_lang,
       u06.u06_external_ref_no,
       v01.v01_description AS side,
       v01.v01_description_lang AS side_lang,
       m20.m20_short_description,
       m20.m20_short_description_lang,
       m20.m20_long_description,
       m20.m20_long_description_lang,
       v30.V30_DESCRIPTION,
       v30.V30_DESCRIPTION_LANG,
       m02.m02_vat_no,
       NVL (t02_prev.quntity, 0) AS quntity_prv,
       NVL (t02_prev.VALUE, 0) AS value_prv,
       ROUND(NVL (t02_prev.price, 0),2) AS price_prv,
       NVL (t02_tdy.quntity, 0) AS quntity_tdy,
       NVL (t02_tdy.VALUE, 0) AS value_tdy,
       ROUND(NVL (t02_tdy.price, 0),2) AS price_tdy,
       t01.t01_ord_no,
       t01.t01_cl_ord_id,
       t01.t01_exchange_code_m01,
       t01.t01_symbol_code_m20,
       t01.t01_trading_acntno_u07,
       t01.t01_cum_quantity,
       t01.t01_price,
       trunc(t01.t01_date_time) as t01_date_time,
       t01.t01_expiry_date,
       t01.t01_commission,
       t01.t01_ord_net_value,
       trunc(t01.t01_last_updated_date_time) as t01_last_updated_date_time,
       t01.t01_cum_broker_tax,
       t01.t01_cum_exchange_tax,
       trunc(t01.t01_cash_settle_date) as t01_cash_settle_date,
       t01.t01_cum_net_value,
       u07.u07_external_ref_no,
       t01.t01_orig_cl_ord_id,
       null as full_address
  FROM t01_order_all t01
       INNER JOIN u01_customer u01
           ON t01.t01_customer_id_u01 = u01.u01_id
       LEFT JOIN u02_customer_contact_info u02
           ON u01.u01_id = u02.u02_customer_id_u01 AND u02.u02_is_default = 1
       INNER JOIN m02_institute m02
           ON u01.u01_institute_id_m02 = m02.m02_id
       INNER JOIN v30_order_status v30
           ON t01.t01_status_id_v30 = v30.v30_status_id
       LEFT JOIN m07_location m07
           ON u01.u01_signup_location_id_m07 = m07.m07_id
       LEFT JOIN m05_country m05
           ON u02.u02_country_id_m05 = m05.m05_id
       LEFT JOIN m06_city m06
           ON u02.u02_city_id_m06 = m06.m06_id
       INNER JOIN u06_cash_account u06
           ON t01.t01_cash_acc_id_u06 = u06.u06_id
       INNER JOIN u07_trading_account u07
           ON u06.u06_id = u07.u07_cash_account_id_u06
       LEFT JOIN (SELECT *
                    FROM v01_system_master_data
                   WHERE v01_type = 15) v01
           ON t01.t01_side = v01.v01_id
       LEFT JOIN m20_symbol m20
           ON t01.t01_symbol_id_m20 = m20.m20_id
       LEFT JOIN (  SELECT t02.t02_order_no,
                           SUM (t02_last_shares) AS quntity,
                           SUM (t02_amnt_in_stl_currency) AS VALUE,
                           AVG (t02.t02_last_price) AS price
                      FROM t02_transaction_log t02
                     WHERE t02.t02_create_date < SYSDATE
                  GROUP BY t02.t02_order_no) t02_prev
           ON t01.t01_ord_no = t02_prev.t02_order_no
       LEFT JOIN (  SELECT t02.t02_order_no,
                           SUM (t02_last_shares) AS quntity,
                           SUM (t02_amnt_in_stl_currency) AS VALUE,
                           AVG (t02.t02_last_price) AS price
                      FROM t02_transaction_log t02
                     WHERE t02.t02_create_date  BETWEEN TO_DATE (
                                                                            '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                                                            ''DD-MM-YYYY''
                                                                        ) - fn_get_max_txn_stl_date_diff
                                                                    AND  TO_DATE (
                                                                             '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                                                                             ''DD-MM-YYYY''
                                                                         )
                                                                         + .99999
                  GROUP BY t02.t02_order_no) t02_tdy
           ON t01.t01_ord_no = t02_tdy.t02_order_no
       where v30_status_id IN (''2'', ''1'', ''4'', ''C'', ''q'', ''r'', ''5'')
             AND t01.t01_trading_acc_id_u07 = u07.u07_id
             AND t01.t01_last_updated_date_time BETWEEN TO_DATE (
                                                                            '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                                                            ''DD-MM-YYYY''
                                                                        )
                                                                    AND  TO_DATE (
                                                                             '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                                                                             ''DD-MM-YYYY''
                                                                         )
                                                                         + .99999'
        || CASE
               WHEN ptradingacc IS NULL THEN ' '
               WHEN TRIM (ptradingacc) = '' THEN ' '
               ELSE 'and t01.t01_trading_acc_id_u07 = ' || ptradingacc
           END
        || CASE
               WHEN psymbol IS NULL THEN ' '
               WHEN TRIM (psymbol) = '' THEN ' '
               ELSE 'and t01.t01_symbol_id_m20 = ' || psymbol
           END;

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
