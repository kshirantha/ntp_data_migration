CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_daily_status_summary (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT   m01.m01_exchange_code AS exchange_code, month_summary.h26_institution_id_m02,
         NVL (today_summary.turnover, 0) AS today_turnover,
         NVL (today_summary.h26_broker_comm, 0) AS today_broker_comm,
         NVL (today_summary.h26_total_comm, 0) AS today_total_comm,
         NVL (today_summary.h26_no_of_trades, 0) AS today_no_of_trades,
         NVL (today_summary.h26_no_of_orders, 0) AS today_no_of_orders,
         NVL (today_summary.h26_exg_turnover, 0) AS today_exg_turnover,
         NVL (today_summary.h26_exg_no_of_trades, 0) AS today_exg_no_of_trades,
         NVL (month_summary.turnover, 0) AS month_turnover,
         NVL (month_summary.h26_broker_comm, 0) AS month_broker_comm,
         NVL (month_summary.h26_total_comm, 0) AS month_total_comm,
         NVL (month_summary.h26_no_of_trades, 0) AS month_no_of_trades,
         NVL (month_summary.h26_no_of_orders, 0) AS month_no_of_orders,
         NVL (month_summary.h26_exg_turnover, 0) AS month_exg_turnover,
         NVL (month_summary.h26_exg_no_of_trades, 0) AS month_exg_no_of_trades
  FROM   m01_exchanges m01
  INNER JOIN   (SELECT   a.h26_exchange,h26_institution_id_m02,
                    SUM (a.h26_buy + a.h26_sell) AS turnover,
                    SUM (a.h26_broker_comm) AS h26_broker_comm,
                    SUM (a.h26_total_comm) AS h26_total_comm,
                    SUM (a.h26_no_of_trades) AS h26_no_of_trades,
                    SUM (a.h26_no_of_orders) AS h26_no_of_orders,
                                 SUM (a.h26_no_of_cust_traded)
                                     AS h26_no_of_cust_traded,
                                 SUM (a.h26_exg_turnover) AS h26_exg_turnover,
                                 SUM (a.h26_exg_no_of_trades)
                                     AS h26_exg_no_of_trades
                          FROM   h26_daily_status a
                         WHERE   a.h26_date >= TRUNC (TO_DATE ('''
        || pfromdate
        || ''', ''DD-MM-YYYY'' ), ''MM'' )
                      GROUP BY   a.h26_exchange, h26_institution_id_m02) month_summary
        ON m01.m01_exchange_code = month_summary.h26_exchange
           and m01_institute_id_m02 = month_summary.h26_institution_id_m02
        LEFT JOIN   (SELECT   a.h26_exchange,h26_institution_id_m02,
                   (a.h26_buy + a.h26_sell) AS turnover,
                   a.h26_broker_comm,
                   a.h26_total_comm,
                   a.h26_no_of_trades,
                   a.h26_no_of_orders,
                   a.h26_no_of_cust_traded,
                   a.h26_exg_turnover,
                   a.h26_exg_no_of_trades
            FROM   h26_daily_status a
            WHERE   a.h26_date = '''
        || TO_DATE (TO_CHAR (pfromdate, ' DD - MM - YYYY '), 'DD-MM-YYYY')
        || ''') today_summary
        ON m01.m01_exchange_code = today_summary.h26_exchange
        and m01_institute_id_m02 = today_summary.h26_institution_id_m02';

    s1 := fn_get_sp_data_query (psearchcriteria, l_qry, NULL, NULL, NULL);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/