CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_top_cust_traded_vol (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pexchangecode         VARCHAR2 DEFAULT NULL,
    pinstituteid          NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'select * from (
SELECT u06_customer_no_u01,
MAX(u06_customer_Id_u01) AS u06_customer_Id_u01,
       u06_display_name_u01,
       t02_exchange_code_m01,
       SUM (t02_amnt_in_txn_currency) AS t02_amnt_in_txn_currency,
       SUM (t02_amnt_in_stl_currency) AS t02_amnt_in_stl_currency,
       SUM (T02_HOLDING_NET_ADJST) AS T02_HOLDING_NET_ADJST
FROM (SELECT t02_cash_acnt_id_u06,
             MAX (t02_exchange_code_m01)
                 AS t02_exchange_code_m01,
             SUM (t02.t02_amnt_in_txn_currency)
                 AS t02_amnt_in_txn_currency,
             SUM (t02.t02_amnt_in_stl_currency)
                 AS t02_amnt_in_stl_currency,
             SUM (t02.T02_HOLDING_NET_ADJST)
                 AS T02_HOLDING_NET_ADJST
      FROM t02_transact_log_order_arc_all t02
      WHERE     t02_inst_id_m02 = '
        || pinstituteid
        || CASE
               WHEN pexchangecode IS NOT NULL OR pexchangecode <> ''
               THEN
                   ' AND t02_exchange_code_m01 = ''' || pexchangecode || ''''
               ELSE
                   ''
           END
        || ' AND t02.t02_create_date between TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')

          AND  TO_DATE('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')

      GROUP BY t02_cash_acnt_id_u06) x,
     u06_cash_account u06
WHERE x.t02_cash_acnt_id_u06 = u06.u06_id
GROUP BY u06_customer_no_u01, u06_display_name_u01, t02_exchange_code_m01
 ORDER BY T02_HOLDING_NET_ADJST DESC
)
where rownum <= 10
';

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
