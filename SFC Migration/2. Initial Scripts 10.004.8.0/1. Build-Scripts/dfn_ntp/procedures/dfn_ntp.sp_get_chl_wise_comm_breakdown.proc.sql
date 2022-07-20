CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_chl_wise_comm_breakdown (
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
           '  SELECT *
    FROM (  SELECT MAX (v29.v29_description) AS channel,
                   MAX (v09.v09_description) AS instrument_type,
                   region,
                   SUM (t02.t02_cum_commission) * MAX (exchange_rate)
                       AS commission,
                   SUM (t02.t02_broker_commission) * MAX (exchange_rate)
                       AS broker_commission,
                   SUM (t02.t02_exg_commission) * MAX (exchange_rate)
                       AS exg_commission,
                   SUM (t02.t02_cumord_value) * MAX (exchange_rate)
                       AS order_value,
                   COUNT (t02_order_no) AS no_of_trades
              FROM (SELECT t02_cum_commission,
                           t02_broker_commission,
                           t02_exg_commission,
                           t02_cumord_value,
                           t02_order_no,
                           t02_inst_id_m02,
                           t02_cash_settle_date,
                           t02_symbol_id_m20,
                           t02_exchange_id_m01,
                           t02_create_date,
                           get_exchange_rate (p_institute       => '
        || pinstitute
        || ',
                                    p_from_currency   => t02_txn_currency,
                                    p_to_currency     => '''
        || pcurrency
        || ''',
                                    p_rate_type       => ''R'',
                                    p_date            => t02_create_date)
                     AS exchange_rate
                      FROM dfn_ntp.t02_transact_log_order_arc_all) t02
                   JOIN t01_order t01
                       ON t02.t02_order_no = t01.t01_ord_no
                   JOIN v29_order_channel v29
                       ON t01.t01_ord_channel_id_v29 = v29.v29_id
                   JOIN m20_symbol m20
                       ON t02.t02_symbol_id_m20 = m20.m20_id
                   JOIN v09_instrument_types v09
                       ON m20.m20_instrument_type_code_v09 = v09.v09_code
                   JOIN (SELECT m01_id,
                                     m01_exchange_code,
                                     CASE
                                         WHEN m01_exchange_code IN
                                                  (''CASE'',
                                                   ''KSE'',
                                                   ''TDWL'',
                                                   ''ADSM'',
                                                   ''DFM'',
                                                   ''DIFX'')
                                         THEN
                                             ''GCC''
                                         WHEN m01_exchange_code IN (''LSE'', ''CSE'')
                                         THEN
                                             ''European Market''
                                         WHEN m01_exchange_code IN
                                                  (''NSDQ'', ''NYSE'', ''OPRA'')
                                         THEN
                                             ''US Market''
                                         ELSE
                                             ''Other Markets(Around the World)''
                                     END
                                         AS region
                                FROM m01_exchanges) m01
                       ON t02.t02_exchange_id_m01 = m01.m01_id
             WHERE   t02_inst_id_m02 = '
        || pinstitute
        || ' AND t02.t02_create_date BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') AND TO_DATE ('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'') + 0.99999
          GROUP BY region, v29_id, v09_id)
ORDER BY no_of_trades DESC';

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