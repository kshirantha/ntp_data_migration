CREATE OR REPLACE PROCEDURE dfn_ntp.sp_detailed_order_master (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    psortby                  VARCHAR2 DEFAULT NULL,
    pfromrownumber           NUMBER DEFAULT NULL,
    ptorownumber             NUMBER DEFAULT NULL,
    psearchcriteria          VARCHAR2 DEFAULT NULL,
    pfromdate                DATE DEFAULT SYSDATE,
    ptodate                  DATE DEFAULT SYSDATE,
    p_exchange_id            NUMBER DEFAULT NULL,
    p_broker_id              NUMBER DEFAULT NULL,
    p_inst_id         IN     NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;


    l_qry :=
           'SELECT inst_id,
         ord_placement_date,
         exchange,
         broker_id,
         MAX(broker) AS broker,
         MAX (u07_display_name) AS u07_display_name,
         MAX (u07_customer_no_u01) AS u07_customer_no_u01,
         MAX (u07_display_name_u01) AS u07_display_name_u01,
         MAX(u07_customer_id_u01) as u07_customer_id_u01,
         order_placement_currency,
         symbol,
         t02_trd_acnt_id_u07,
         ABS(SUM (buy)) AS total_buy,
         ABS(SUM (buy_value)) AS total_buy_value,
         ABS(SUM (sell)) AS total_sell,
         ABS(SUM (sell_value)) AS total_sell_value,
         (SUM (buy) - SUM (sell)) AS net_qty,
         (SUM (buy_value) - SUM (sell_value)) AS gross_amt,
         SUM (commission) AS total_commission,
         SUM (charges) AS total_charges,
         SUM (net_amt) AS net_amount
    FROM (SELECT t02_inst_id_m02 AS inst_id,
                 t02_trd_acnt_id_u07,
                 t02_create_date AS ord_placement_date,
                 t02_exchange_code_m01 AS exchange,
                 t02_exec_broker_id_m26 AS broker_id,
                 m26_name AS broker,
                 t02_txn_currency AS order_placement_currency,
                 t02_symbol_code_m20 AS symbol,
                 u07_customer_id_u01,
                 CASE
                     WHEN t02_txn_code IN (''STLBUY'', ''STKSUB'', ''REVSUB'')
                     THEN
                         t02_ordqty
                     ELSE
                         0
                 END
                     AS buy,
                 CASE
                     WHEN t02_txn_code IN (''STLBUY'', ''STKSUB'', ''REVSUB'')
                     THEN
                         t02_ord_value_adjst
                     ELSE
                         0
                 END
                     AS buy_value,
                 CASE
                     WHEN t02_txn_code IN (''STLSEL'') THEN t02_ordqty
                     ELSE 0
                 END
                     AS sell,
                 CASE
                     WHEN t02_txn_code IN (''STLSEL'') THEN t02_ord_value_adjst
                     ELSE 0
                 END
                     AS sell_value,
                 NVL (t02_commission_adjst, 0) AS commission,
                 (NVL (t02_broker_tax, 0) + NVL (t02_exchange_tax, 0))
                     AS charges,
                 NVL (t02_amnt_in_txn_currency, 0) AS net_amt,
                 u07.u07_display_name,
                 u07.u07_customer_no_u01,
                 u07.u07_display_name_u01
            FROM t02_transact_log_cash_arc_all t02, m01_exchanges m01, m26_executing_broker m26, u07_trading_account u07
           WHERE     t02.t02_inst_id_m02 = '
        || p_inst_id
        || '
                 AND t02.t02_fail_management_status NOT IN (1, 2)
                 AND t02.t02_custodian_type_v01 = 0
                   AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'', ''STKSUB'', ''REVSUB'')
                 AND t02.t02_exec_broker_id_m26 = m26.m26_id (+)
                 AND t02.t02_exchange_id_m01 = m01.m01_id
                   AND t02.t02_trd_acnt_id_u07 =u07.u07_id '
        || CASE
               WHEN p_exchange_id != -1
               THEN
                   ' AND m01.m01_id = ' || p_exchange_id || ''
               ELSE
                   ''
           END
        || CASE
               WHEN p_broker_id != -1
               THEN
                   ' AND t02.t02_exec_broker_id_m26 = ' || p_broker_id || ''
               ELSE
                   ''
           END
        || ' AND t02.t02_create_date BETWEEN TO_DATE (
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
                                                     + .99999) trades
GROUP BY inst_id,
         ord_placement_date,
         exchange,
         broker_id,
         order_placement_currency,
         symbol,
         t02_trd_acnt_id_u07';

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
