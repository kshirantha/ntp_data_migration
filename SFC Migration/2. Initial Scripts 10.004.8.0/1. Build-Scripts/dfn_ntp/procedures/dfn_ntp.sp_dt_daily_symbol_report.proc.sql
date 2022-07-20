CREATE OR REPLACE PROCEDURE dfn_ntp.sp_dt_daily_symbol_report (
    p_view              OUT SYS_REFCURSOR,
    prows               OUT NUMBER,
    psortby                 VARCHAR2 DEFAULT NULL,
    pfromrownumber          NUMBER DEFAULT NULL,
    ptorownumber            NUMBER DEFAULT NULL,
    psearchcriteria         VARCHAR2 DEFAULT NULL,
    pfromdate               DATE DEFAULT SYSDATE,
    ptodate                 DATE DEFAULT SYSDATE,
    ptradingaccountid       VARCHAR,
    pdecimals               NUMBER,
    psymbol                 VARCHAR2 DEFAULT NULL,
    pavgpricewithcomm       NUMBER DEFAULT 0)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT t02.t02_order_no,
                 t02.t02_create_date,
                 t02.t02_trd_acnt_id_u07,
                 t02.t02_exchange_code_m01,
                 m20.m20_symbol_code,
                 m20.m20_short_description,
                 u01_first_name,
                 u01_last_name,
                 u01_display_name,
                 u01_customer_no,
                 u07_display_name_u06 as u07_exchange_account_no,
                 CASE
                     WHEN t02.t02_side = 1 THEN ''Buy''
                     WHEN t02.t02_side = 2 THEN ''Sell''
                 END
                     AS ord_side,
                 t02.t02_side,
                 CASE
                     WHEN t02.t02_side = 1 THEN SUM (t02.t02_cum_qty)
                     WHEN t02.t02_side = 2 THEN 0
                 END
                     AS buy_qty,
                 CASE
                     WHEN t02.t02_side = 1 THEN 0
                     WHEN t02.t02_side = 2 THEN SUM (t02.t02_cum_qty)
                 END
                     AS sell_qty,
                 CASE
                     WHEN t02.t02_side = 1 THEN SUM (t02.t02_cumord_value)
                     WHEN t02.t02_side = 2 THEN 0
                 END
                     AS buy_ord_value,
                 CASE
                     WHEN t02.t02_side = 1 THEN 0
                     WHEN t02.t02_side = 2 THEN SUM (t02.t02_cumord_value)
                 END
                     AS sell_ord_value,
                 CASE
                     WHEN t02.t02_side = 1 THEN AVG (t02.t02_avgprice)
                     WHEN t02.t02_side = 2 THEN 0
                 END
                     AS buy_avg_price,
                 CASE
                     WHEN t02.t02_side = 1 THEN 0
                     WHEN t02.t02_side = 2 THEN AVG (t02.t02_avgprice)
                 END
                     AS sell_avg_price,
                 SUM (t02.t02_ordqty) AS order_qty,
                 SUM (t02.t02_cumord_value) AS order_value,
                 SUM (t02_broker_commission) AS broker_commission,
                 SUM (t02_exg_commission) AS exg_commission,
                 AVG (t02.t02_avgprice) AS avgprice,
                 (SUM (t02.t02_broker_tax) + SUM (t02.t02_exchange_tax))
                     AS cum_tax , '
        || pavgpricewithcomm
        || ' as commission_flag,
        CASE
                     WHEN t02.t02_side = 1 THEN  AVG (t02.t02_holding_avg_cost)
                     WHEN t02.t02_side = 2 THEN 0
                 END
                     AS buy_avg_cost,
                 CASE
                     WHEN t02.t02_side = 1 THEN 0
                     WHEN t02.t02_side = 2 THEN  AVG (t02.t02_holding_avg_cost)
                 END
                     AS sell_avg_cost,
                     AVG (t02.t02_holding_avg_cost) AS avgcost,
         t02.t02_cash_settle_date,
        ABS (SUM (t02.t02_amnt_in_stl_currency)) as order_net_value
            FROM dfn_ntp.t02_transaction_log_order_all t02
                 JOIN m20_symbol m20
                     ON t02.t02_symbol_id_m20 = m20.m20_id
                 JOIN dfn_ntp.u01_customer u01
                     ON t02.t02_customer_id_u01 = u01.u01_id
                 JOIN u07_trading_account u07
                     ON t02.t02_trd_acnt_id_u07 = u07.u07_id
           WHERE     t02_trd_acnt_id_u07 = '
        || ptradingaccountid
        || '
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
                                                                   + .99999 '
        || CASE
               WHEN psymbol IS NULL THEN ' '
               ELSE ' AND m20.m20_symbol_code = ''' || psymbol || ''' '
           END
        || 'GROUP BY t02_create_date,
                     t02_cash_settle_date,
                     t02_order_no,
                     t02_trd_acnt_id_u07,
                     t02_exchange_code_m01,
                     m20_symbol_code,
                     m20_short_description,
                     t02_side,
                     u01_first_name,
                     u01_last_name,
                     u01_display_name,
                     u01_customer_no,
                     u07_display_name_u06
            ORDER BY m20_symbol_code';

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
