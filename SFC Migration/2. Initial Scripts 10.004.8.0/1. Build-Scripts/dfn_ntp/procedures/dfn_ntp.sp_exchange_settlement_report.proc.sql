CREATE OR REPLACE PROCEDURE dfn_ntp.sp_exchange_settlement_report (
    p_view                 OUT SYS_REFCURSOR,
    prows                  OUT NUMBER,
    psortby                    VARCHAR2 DEFAULT NULL,
    pfromrownumber             NUMBER DEFAULT NULL,
    ptorownumber               NUMBER DEFAULT NULL,
    psearchcriteria            VARCHAR2 DEFAULT NULL,
    pfromdate                  DATE DEFAULT SYSDATE,
    ptodate                    DATE DEFAULT SYSDATE,
    pexchangeid                NUMBER DEFAULT NULL,
    pprimaryinstitute   IN     NUMBER,
    ptype                      VARCHAR2 DEFAULT 'tradedate' -- 1 tradedate, 0 settledate
                                                           )
IS
    l_qry                    VARCHAR2 (15000);
    s1                       VARCHAR2 (15000);
    s2                       VARCHAR2 (15000);
    l_maximum_gtd_validity   NUMBER (10);
BEGIN
    SELECT NVL (MAX (v00_value), 90)
      INTO l_maximum_gtd_validity
      FROM v00_sys_config
     WHERE v00_key = 'MAXIMUM_GTD_VALIDITY';

    prows := 0;

    IF (ptype = 'tradedate')
    THEN
        l_qry :=
               'SELECT trades.*, NVL (t12.subscribed_value, 0) AS subscribed_value
    FROM (SELECT t02.t02_inst_id_m02 AS inst_id,
                             t02.t02_exchange_code_m01 AS exchange_code,
                             TRUNC (t02.t02_create_date) AS trim_date,
                             TRUNC (MAX (t02.t02_cash_settle_date))
                                 AS settlment_date,
                             SUM (t02.t02_ord_value_adjst) AS net_order_value ,
                             SUM (
                                 (CASE
                                      WHEN t02.t02_txn_code IN (''STLBUY'', ''STKSUB'', ''REVSUB'') THEN t02.t02_ord_value_adjst
                                      ELSE 0
                                  END))
                                 AS buy_settle,
                             SUM (
                                 (CASE
                                      WHEN t02.t02_txn_code IN (''STLSEL'') THEN t02.t02_ord_value_adjst
                                      ELSE 0
                                  END))
                                 AS sel_settle,
                             SUM (t02.t02_commission_adjst) AS total_commission,
                             SUM (t02.t02_exg_commission) AS exchange_commission,
                             0 AS other_commission,
                             (SUM (t02.t02_commission_adjst) - SUM (t02.t02_exg_commission))
                                 AS broker_commission,
                             COUNT (t02.t02_order_no) AS no_of_trades,
                             t02.t02_settle_currency AS settle_currency,
                             SUM ( (CASE WHEN t02.t02_txn_code IN (''STLBUY'') THEN 1 ELSE 0 END))
                                 AS buy_trades,
                             SUM ( (CASE WHEN t02.t02_txn_code IN (''STLSEL'') THEN 1 ELSE 0 END))
                                 AS sel_trades,
                             SUM (ABS (t02.t02_ord_value_adjst)) AS turnover,
                             SUM (t02.t02_amnt_in_txn_currency) AS net_settle,
                             COUNT (DISTINCT t02.t02_order_no) AS no_of_orders,
                             SUM (t02.t02_amnt_in_txn_currency) - SUM (t02.t02_exg_commission)
                                 AS exchange_settlement,
                             SUM (t02.t02_discount) AS discount,
                            SUM (t02.t02_broker_tax) AS broker_vat,
                             SUM (t02.t02_exchange_tax) AS exchange_vat,
                           CASE WHEN  SUM (t02.t02_ord_value_adjst) > 0  THEN ''Receivable'' else ''Payable''
                          END AS payment_type,
                          TRUNC (t02.t02_create_date) AS filter_date,
                          TRUNC (t02.t02_create_date) AS trade_date
                        FROM t02_transact_log_cash_arc_all t02,
                            m01_exchanges m01
                       WHERE   t02.t02_fail_management_status NOT IN (1, 2)
                               AND t02.t02_custodian_type_v01 = 0
                               AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'', ''STKSUB'', ''REVSUB'')
                               AND t02.t02_inst_id_m02 = '
            || pprimaryinstitute
            || ' AND t02.t02_exchange_id_m01 = m01.m01_id '
            || CASE
                   WHEN pexchangeid != -1
                   THEN
                       ' AND m01.m01_id = ' || pexchangeid || ''
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
                                                                         + .99999
                    GROUP BY TRUNC(t02.t02_create_date),
                             t02.t02_exchange_code_m01,
                             t02.t02_inst_id_m02,
                             t02.t02_settle_currency )trades,
                   (  SELECT SUM (t12.t12_quantity * t12.t12_avgcost) AS subscribed_value,
                             t12.t12_transfer_date
                        FROM t12_share_transaction_all t12
                       WHERE t12.t12_txn_type = 13
                       AND t12.t12_timestamp BETWEEN TO_DATE (
                                                                            '''
            || TO_CHAR (pfromdate - l_maximum_gtd_validity, 'DD-MM-YYYY')
            || ''',
                                                                            ''DD-MM-YYYY''
                                                                        )
                                                                    AND  TO_DATE (
                                                                             '''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''',
                                                                             ''DD-MM-YYYY''
                                                                         )
                                                                         + .99999
                    GROUP BY t12.t12_transfer_date) t12
             WHERE trades.trade_date = t12.t12_transfer_date(+)';
    ELSIF (ptype = 'settledate')
    THEN
        l_qry :=
               'SELECT trades.*, NVL (t12.subscribed_value, 0) AS subscribed_value
  FROM (SELECT t02.t02_inst_id_m02 AS inst_id,
                             t02.t02_exchange_code_m01 AS exchange_code,
                             TRUNC (t02.t02_cash_settle_date) AS trim_date,
                             TRUNC (MAX (t02.t02_cash_settle_date))
                                 AS settlment_date,
                             SUM (t02.t02_ord_value_adjst) AS net_settle,
                             SUM (
                                 (CASE
                                      WHEN t02.t02_txn_code IN (''STLBUY'', ''STKSUB'', ''REVSUB'') THEN t02.t02_ord_value_adjst
                                      ELSE 0
                                  END))
                                 AS buy_settle,
                             SUM (
                                 (CASE
                                      WHEN t02.t02_txn_code IN (''STLSEL'') THEN t02.t02_ord_value_adjst
                                      ELSE 0
                                  END))
                                 AS sel_settle,
                             SUM (t02.t02_commission_adjst) AS total_commission,
                             SUM (t02.t02_exg_commission) AS exchange_commission,
                             0 AS other_commission,
                             (SUM (t02.t02_commission_adjst) - SUM (t02.t02_exg_commission))
                                 AS broker_commission,
                             COUNT (t02.t02_order_no) AS no_of_trades,
                             t02.t02_settle_currency AS settle_currency,
                             SUM ( (CASE WHEN t02.t02_txn_code IN (''STLBUY'') THEN 1 ELSE 0 END))
                                 AS buy_trades,
                             SUM ( (CASE WHEN t02.t02_txn_code IN (''STLSEL'') THEN 1 ELSE 0 END))
                                 AS sel_trades,
                             SUM (ABS (t02.t02_ord_value_adjst)) AS turnover,
                             SUM (t02.t02_amnt_in_txn_currency) AS net_order_value,
                             COUNT (DISTINCT t02.t02_order_no) AS no_of_orders,
                             SUM (t02.t02_amnt_in_txn_currency) - SUM (t02.t02_exg_commission)
                                 AS exchange_settlement,
                             SUM (t02.t02_discount) AS discount,
                           SUM (t02.t02_broker_tax) AS broker_vat,
                             SUM (t02.t02_exchange_tax) AS exchange_vat,
                             CASE WHEN   SUM (t02.t02_ord_value_adjst) > 0  THEN ''Receivable'' else ''Payable''
                          END AS payment_type,
                             TRUNC (t02.t02_cash_settle_date) AS filter_date,
                             TRUNC (MAX(t02.t02_create_date)) AS trade_date
                        FROM t02_transact_log_cash_arc_all t02,
                            m01_exchanges m01
                       WHERE    t02.t02_fail_management_status NOT IN (1, 2)
                                AND t02.t02_custodian_type_v01 = 0
                                AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'', ''STKSUB'', ''REVSUB'')
                                AND t02.t02_inst_id_m02 = '
            || pprimaryinstitute
            || ' AND t02.t02_exchange_id_m01 = m01.m01_id'
            || CASE
                   WHEN pexchangeid != -1
                   THEN
                       ' AND m01.m01_id = ' || pexchangeid || ''
                   ELSE
                       ''
               END
            || ' AND t02.t02_cash_settle_date BETWEEN TO_DATE (
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
                                                     + .99999
                    GROUP BY TRUNC (t02.t02_cash_settle_date),
                             t02.t02_exchange_code_m01,
                             t02.t02_inst_id_m02,
                             t02.t02_settle_currency)  trades,
               (  SELECT SUM (t12.t12_quantity * t12.t12_avgcost) AS subscribed_value,
                         t12.t12_transfer_date
                    FROM t12_share_transaction_all t12
                   WHERE t12.t12_txn_type = 13
                       AND t12.t12_timestamp BETWEEN TO_DATE (
                                                                            '''
            || TO_CHAR (pfromdate - l_maximum_gtd_validity, 'DD-MM-YYYY')
            || ''',
                                                                            ''DD-MM-YYYY''
                                                                        )
                                                                    AND  TO_DATE (
                                                                             '''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''',
                                                                             ''DD-MM-YYYY''
                                                                         )
                                                                         + .99999
                GROUP BY t12.t12_transfer_date) t12
         WHERE trades.settlment_date = t12.t12_transfer_date(+)';
    END IF;

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
