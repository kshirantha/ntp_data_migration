CREATE OR REPLACE PROCEDURE dfn_ntp.sp_customer_wise_order_master (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    psortby                   VARCHAR2 DEFAULT NULL,
    pfromrownumber            NUMBER DEFAULT NULL,
    ptorownumber              NUMBER DEFAULT NULL,
    psearchcriteria           VARCHAR2 DEFAULT NULL,
    pfromdate                 DATE DEFAULT SYSDATE,
    ptodate                   DATE DEFAULT SYSDATE,
    p_exchange_id             NUMBER DEFAULT NULL,
    p_broker_id               NUMBER DEFAULT NULL,
    p_inst_id          IN     NUMBER,
    p_trading_acc_id   IN     NUMBER,
    p_symbol           IN     VARCHAR2)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    l_qry :=
           'SELECT t02_inst_id_m02 AS inst_id,
               t02_trd_acnt_id_u07,
               t02_create_date AS ord_placement_date,
               t02_txn_currency AS order_placement_currency,
               t02_symbol_code_m20 AS symbol,
               t02_exchange_code_m01 AS exchange,
               t02_exec_broker_id_m26 AS broker_id,
               m26_broker.m26_name AS broker,
               t02.t02_custodian_id_m26 AS custodian_id,
               m26_custodian.m26_name AS custodian,
               u07.u07_customer_id_u01,
               u07.u07_display_name,
               u07.u07_customer_no_u01,
               u07.u07_display_name_u01,
               t02_cliordid_t01,
               t02_order_exec_id,
               CASE
                   WHEN t02.t02_side = 1 THEN ''BUY''
                   WHEN t02.t02_side = 2 THEN ''SELL''
                   ELSE ''SUB''
               END
                   AS side,
               t02.t02_last_shares as qty,
               t02.t02_last_price as price ,
               ABS(t02_ord_value_adjst) as gross_amt,
               t02.t02_commission_adjst AS commission,
               (NVL (t02_broker_tax, 0) + NVL (t02_exchange_tax, 0)) AS charges,
               NVL (ABS(t02_amnt_in_txn_currency), 0) AS net_amount,
               t02.t02_cash_settle_date  as cash_settle_date,
               t02.t02_holding_settle_date as holding_settle_date,
               t02.t02_trade_confirm_no as trade_confirm_no ,
               t02.t02_txn_entry_status as txn_entry_status,
               u17.u17_full_name as dealer,
               t01.t01_trade_process_stat_id_v01 as trade_process_status_id,
               m01.m01_trade_processing as is_trade_processing_enabled
          FROM t02_transact_log_cash_arc_all t02
               INNER JOIN m01_exchanges m01
                   ON     t02.t02_exchange_id_m01 = m01.m01_id
               INNER JOIN m26_executing_broker m26_broker
                   ON t02.t02_custodian_id_m26 = m26_broker.m26_id
               INNER JOIN m26_executing_broker m26_custodian
                   ON t02.t02_exec_broker_id_m26 = m26_custodian.m26_id
               INNER JOIN u07_trading_account u07
                   ON t02.t02_trd_acnt_id_u07 = u07.u07_id
               INNER JOIN t01_order_all t01
                   ON t02.t02_cliordid_t01 = t01.t01_cl_ord_id
               LEFT OUTER JOIN u17_employee u17
                   ON t01.t01_dealer_id_u17 = u17.u17_id
                   WHERE     t02.t02_inst_id_m02 = '
        || p_inst_id
        || ' and t02.t02_trd_acnt_id_u07 = '
        || p_trading_acc_id
        || ' and t02_symbol_code_m20 = '''
        || p_symbol
        || '''
                         AND t02.t02_fail_management_status NOT IN (1, 2)

                           AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'', ''STKSUB'', ''REVSUB'')
                         '
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
                                                     + .99999';

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
