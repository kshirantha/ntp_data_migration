CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_total_commiss_by_dealer (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    psortby           IN     VARCHAR2 DEFAULT NULL,
    pfromrownumber    IN     NUMBER DEFAULT NULL,
    ptorownumber      IN     NUMBER DEFAULT NULL,
    psearchcriteria   IN     VARCHAR2 DEFAULT NULL,
    pfromdate         IN     DATE DEFAULT SYSDATE,
    ptodate           IN     DATE DEFAULT SYSDATE,
    pcurrency         IN     VARCHAR DEFAULT 'SAR',
    pinstitute        IN     NUMBER DEFAULT 1)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT * FROM (SELECT t02.t02_customer_id_u01,
         MAX (u01.u01_display_name) AS display_name,
         MAX (u01.u01_display_name_lang) AS display_name_lang,
         MAX (u01.u01_customer_no) AS customer_no,
         MAX (v29.v29_description) AS channel,
         MAX (u17.u17_full_name) AS dealer_name,
         SUM (t02.t02_cum_commission) * MAX (exchange_rate) AS commission,
         SUM (t02.t02_broker_commission)* MAX (exchange_rate)  AS broker_commission,
         SUM (t02.t02_exg_commission)* MAX (exchange_rate)  AS exg_commission,
         SUM (t02.t02_cumord_value)* MAX (exchange_rate)  AS order_value,
         COUNT(t02_order_no) AS no_of_trades
    FROM (SELECT t02_customer_id_u01,
                t02_cum_commission,
                t02_broker_commission,
                t02_exg_commission,
                t02_cumord_value,
                t02_order_no,
                t02_inst_id_m02,
                t02_exchange_code_m01,
                t02_exchange_id_m01,
                t02_cash_settle_date,
                t02_trade_process_stat_id_v01,
                 get_exchange_rate (p_institute       => '
        || pinstitute
        || ',
                                    p_from_currency   => t02_txn_currency,
                                    p_to_currency     => '''
        || pcurrency
        || ''',
                                    p_rate_type       => ''R'',
                                    p_date            => t02_cash_settle_date)
                     AS exchange_rate
    FROM dfn_ntp.t02_transact_log_order_arc_all) t02
         JOIN u01_customer u01
             ON t02.t02_customer_id_u01 = u01.u01_id
         JOIN t01_order t01
             ON t02.t02_order_no = t01.t01_ord_no
         JOIN v29_order_channel v29
             ON t01.t01_ord_channel_id_v29 = v29.v29_id
         LEFT JOIN m01_exchanges m01
             ON     t02.t02_exchange_id_m01 = m01.m01_id
         LEFT JOIN u17_employee u17
             ON t01.t01_dealer_id_u17 = u17.u17_id
   WHERE t02.t02_trade_process_stat_id_v01 = 25 AND m01.m01_is_local <> 1
         AND t02_inst_id_m02 = '
        || pinstitute
        || ' AND t02.t02_cash_settle_date BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') AND TO_DATE ('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'') + 0.99999
GROUP BY t02_customer_id_u01,
         v29_id,
         t01_dealer_id_u17)
ORDER BY no_of_trades desc';

    DBMS_OUTPUT.put_line (l_qry);

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
