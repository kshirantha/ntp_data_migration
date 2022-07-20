CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_monthly_transactions (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    ptype          IN     NUMBER DEFAULT 1, --1- transaction date | 2 - settle date
    pcurrency      IN     VARCHAR2,
    pfromdate      IN     DATE DEFAULT SYSDATE,
    ptodate        IN     DATE DEFAULT SYSDATE,
    pinstituteid   IN     NUMBER)
IS
    l_qry   VARCHAR (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           '   SELECT MAX (t02.accesslevel) AS group_name,
         COUNT (t02.t02_order_no) AS txn_count,
         SUM (t02.t02_cumord_value) * MAX (exchange_rate) AS transaction_amout,
         SUM (t02_cum_commission) * MAX (exchange_rate) AS cum_commission,
         SUM (t02_exg_commission) * MAX (exchange_rate) AS exg_commission,
         SUM (t02_broker_commission) * MAX (exchange_rate) AS broker_commission
    FROM (SELECT t02_amnt_in_txn_currency,
                 t02_cumord_value,
                 t02_cum_commission,
                 t02_order_no,
                 t02_exg_commission,
                 t02_broker_commission,
                 t02_cash_settle_date,
                 m05.m05_name,
                 get_exchange_rate (p_institute       => '
        || pinstituteid
        || ',
                                    p_from_currency   => t02_txn_currency,
                                    p_to_currency     => '''
        || pcurrency
        || ''',
                                    p_rate_type       => ''R'',
                                    p_date            => t02_create_date)
                     AS exchange_rate,
                 accesslevel.v01_description AS accesslevel
            FROM t02_transact_log_order_arc_all
                 LEFT JOIN m01_exchanges m01
                     ON t02_exchange_code_m01 = m01.m01_exchange_code
                 LEFT JOIN m05_country m05
                     ON m01.m01_country_id_m05 = m05.m05_id
                 LEFT JOIN (SELECT *
                              FROM v01_system_master_data a
                             WHERE v01_type = 1) accesslevel
                     ON m05.m05_access_level_id_v01 = accesslevel.v01_id
           WHERE     t02_inst_id_m02 = '
        || pinstituteid
        || '
                 AND '
        || CASE
               WHEN ptype = 1
               THEN
                   ' t02_create_date '
               ELSE
                      ' t02_create_date BETWEEN TO_DATE ('''
                   || TO_CHAR (pfromdate - fn_get_max_txn_stl_date_diff,
                               'DD-MM-YYYY')
                   || ''',''DD-MM-YYYY'') AND  TO_DATE ('''
                   || TO_CHAR (ptodate, 'DD-MM-YYYY')
                   || ''',''DD-MM-YYYY'') + 0.99999 AND t02_cash_settle_date '
           END
        || ' BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'') AND  TO_DATE ('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'') + 0.99999) t02
        GROUP BY t02.accesslevel
        ORDER BY t02.accesslevel';

    s1 :=
        fn_get_sp_data_query (psearchcriteria   => NULL,
                              psortby           => NULL,
                              ptorownumber      => NULL,
                              pfromrownumber    => NULL,
                              l_qry             => l_qry);

    s2 := fn_get_sp_row_count_query (psearchcriteria => NULL, l_qry => l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
