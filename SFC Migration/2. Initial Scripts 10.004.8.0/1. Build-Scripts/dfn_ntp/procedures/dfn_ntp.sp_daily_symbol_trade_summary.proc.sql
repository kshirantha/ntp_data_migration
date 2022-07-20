CREATE OR REPLACE PROCEDURE dfn_ntp.sp_daily_symbol_trade_summary (
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
           'SELECT t02_trd_acnt_id_u07,
                 m20_symbol_code,
                 m20_short_description,
                 t02_side,
                 COUNT (DISTINCT t02_order_no) ordcount,
                 CASE
                     WHEN t02_side = 1 THEN ''Buy''
                     WHEN t02_side = 2 THEN ''Sell''
                 END
                     AS ord_side,
                 SUM (t02_ordqty) AS order_qty,
                 SUM (t02_cumord_value) AS order_value,
                 SUM (t02_broker_commission) AS broker_commission,
                 SUM (t02_exg_commission) AS exg_commission,
                 SUM (t02_broker_tax + t02_exchange_tax) AS cum_tax,
                 MAX (u01_first_name || '' '' || u01_last_name) AS cust_name,
                 MAX (u01_customer_no) AS u01_customer_no,
                 MAX (u07_exchange_account_no) AS u07_exchange_account_no
            FROM (SELECT t02_trd_acnt_id_u07,
                         m20_symbol_code,
                         m20_short_description,
                         t02_side,
                         t02_order_no,
                         t02_ordqty,
                         t02_cumord_value,
                         t02_broker_commission,
                         t02_exg_commission,
                         t02_broker_tax,
                         t02_exchange_tax,
                         u01_first_name,
                         u01_last_name,
                         u01_customer_no,
                         u07_exchange_account_no
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
        || ' ) GROUP BY t02_side,
                        m20_symbol_code,
                        m20_short_description,
                        t02_trd_acnt_id_u07
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