CREATE OR REPLACE PROCEDURE dfn_ntp.sp_trdacc_total_comm_vat (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pu07id                NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT SUM (t02.t02_cum_commission) AS t02_total_commission,
                   SUM (t02.t02_cumord_value) AS t02_total_cumord_value,
                   SUM (t02.t02_cumord_netvalue) AS total_cumord_netvalue,
                   SUM (t02.t02_broker_tax + t02.t02_exchange_tax)
                       AS t02_total_vat
              FROM t02_transaction_log_order_all t02
                   JOIN u07_trading_account u07
                       ON t02.t02_trd_acnt_id_u07 = u07.u07_id
             WHERE     u07.u07_id = '
        || pu07id
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