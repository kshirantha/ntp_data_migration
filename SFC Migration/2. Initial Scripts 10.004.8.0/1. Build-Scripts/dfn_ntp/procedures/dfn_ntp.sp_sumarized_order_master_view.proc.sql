CREATE OR REPLACE PROCEDURE dfn_ntp.sp_sumarized_order_master_view (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pexchangeid           NUMBER DEFAULT NULL,
    pbrokerid             NUMBER DEFAULT NULL,
    pinstid               NUMBER)
IS
    l_qry           VARCHAR2 (15000);
    s1              VARCHAR2 (15000);
    s2              VARCHAR2 (15000);
    l_prim_instid   NUMBER;
BEGIN
    prows := 0;

    SELECT a.m02_primary_institute_id_m02
      INTO l_prim_instid
      FROM m02_institute a
     WHERE a.m02_id = pinstid;

    l_qry :=
           'SELECT inst_id,
         ord_placement_date,
         exchange,
         broker_id,
         MAX(broker) AS broker,
         order_placement_currency,
         symbol,
         SUM (buy) AS total_buy,
         ABS(SUM (buy_value)) AS total_buy_value,
         SUM (sell) AS total_sell,
         SUM (sell_value) AS total_sell_value,
         (SUM (buy) - SUM (sell)) AS net_qty,
         ABS(ABS(SUM (buy_value)) - SUM (sell_value)) AS gross_amt,
         SUM (commission) AS total_commission,
         SUM (charges) AS total_charges,
         ABS(SUM (net_amt)) AS net_amount
    FROM (SELECT t02_inst_id_m02 AS inst_id,
                 t02_create_date AS ord_placement_date,
                 t02_exchange_code_m01 AS exchange,
                 t02_exec_broker_id_m26 AS broker_id,
                 m26_name AS broker,
                 t02_txn_currency AS order_placement_currency,
                 t02_symbol_code_m20 AS symbol,
                 CASE
                     WHEN t02_txn_code IN (''STLBUY'', ''STKSUB'', ''REVSUB'')
                     THEN
                         t02_last_shares
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
                     WHEN t02_txn_code IN (''STLSEL'') THEN t02_last_shares
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
                 NVL (t02_amnt_in_txn_currency, 0) AS net_amt
            FROM t02_transact_log_cash_arc_all t02, m01_exchanges m01, m26_executing_broker m26
           WHERE     t02.t02_inst_id_m02 = '
        || pinstid
        || '     AND t02.t02_fail_management_status NOT IN (1, 2)
                 AND t02.t02_custodian_type_v01 = 0
                 AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'', ''STKSUB'', ''REVSUB'')
                 AND t02.t02_exec_broker_id_m26 = m26.m26_id (+)
                 AND t02.t02_exchange_id_m01 = m01.m01_id'
        || CASE
               WHEN pexchangeid != -1
               THEN
                   ' AND m01.m01_id = ' || pexchangeid || ''
               ELSE
                   ''
           END
        || CASE
               WHEN pbrokerid != -1
               THEN
                   ' AND t02.t02_exec_broker_id_m26 = ' || pbrokerid || ''
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
         symbol';

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
