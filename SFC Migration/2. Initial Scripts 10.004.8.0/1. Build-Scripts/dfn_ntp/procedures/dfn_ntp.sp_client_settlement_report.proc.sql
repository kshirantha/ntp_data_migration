CREATE OR REPLACE PROCEDURE dfn_ntp.sp_client_settlement_report (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    psortby                  VARCHAR2 DEFAULT NULL,
    pfromrownumber           NUMBER DEFAULT NULL,
    ptorownumber             NUMBER DEFAULT NULL,
    psearchcriteria          VARCHAR2 DEFAULT NULL,
    pfromdate                DATE DEFAULT SYSDATE,
    ptodate                  DATE DEFAULT SYSDATE,
    pinstitute        IN     NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT t02.t02_customer_id_u01,
         t02.t02_create_date AS transaction_date,
         u01.u01_display_name AS customer_name,
         u01.u01_external_ref_no AS u01_external_ref_no,
         u01.u01_customer_no AS u01_customer_no,
         u06.u06_display_name,
         MAX (t02.t02_cash_settle_date) AS settlement_date,
         day,
         SUM (NVL (t02.buy_settle, 0)) AS buy_settle,
         SUM (NVL (t02.sell_settle, 0)) AS sell_settle,
         SUM (NVL (t02.t02_amnt_in_stl_currency, 0))
             AS net_settle,
            SUM (NVL (t02.t02_ord_value_adjst, 0))
             AS order_value,

          0 as   settled_amount,
          0 as pending_settle,
         MAX (t02.t02_settle_currency) as settle_currency,

         SUM (t02.t02_exg_commission) as exg_commission,
         SUM (broker_commission) as broker_commission,
         SUM (t02.t02_commission_adjst) as  net_commission,
         COUNT(t02.t02_order_no) as trades
    FROM     vw_client_settlement t02
         INNER JOIN
             u01_customer u01
         ON t02.t02_customer_id_u01 = u01.u01_id
         INNER JOIN u06_cash_account u06
         on t02.t02_cash_acnt_id_u06 = u06.u06_id
   WHERE t02.t02_create_date BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
         AND  TO_DATE ('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'' ) + .99999
GROUP BY t02.t02_customer_id_u01,
         t02.t02_create_date,
          day,
         u01.u01_display_name,
         u01.u01_external_ref_no,
         u01.u01_customer_no,
         u06.u06_display_name';

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              NULL,
                              NULL,
                              NULL);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/