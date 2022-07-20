CREATE OR REPLACE PROCEDURE dfn_ntp.get_ib_wise_commission (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    puserfilter           VARCHAR2 DEFAULT NULL)
IS
    l_qry                    VARCHAR2 (15000);
    s1                       VARCHAR2 (15000);
    s2                       VARCHAR2 (15000);
    l_maximum_gtd_validity   NUMBER (10);
BEGIN
    prows := 0;

    SELECT NVL (MAX (v00_value), 90)
      INTO l_maximum_gtd_validity
      FROM v00_sys_config
     WHERE v00_key = 'MAXIMUM_GTD_VALIDITY';

    l_qry :=
           'SELECT u01_ib_id_m21 AS ib_id,
                               MAX (m21.m21_name) AS ib_name,
                               ABS (SUM (t02_commission_adjst) - SUM (t02_exg_commission))
                                   AS broker_commission,
                               ABS (SUM (t02_commission_adjst) + SUM (t02_discount)) AS gross_commission,
                               ABS (SUM (t02_commission_adjst)) AS charged_commission,
                               ABS (SUM (t02_ib_commission)) AS ib_commission,
                               ABS (SUM (t02_exg_commission)) AS exchange_commission,
                               ABS (SUM (t02_discount)) AS discounted_commission,
                               SUM (ABS (t02_amnt_in_stl_currency)) AS total_turnover,
                               COUNT (DISTINCT t02_order_no) AS executed_orders,
                               t02_inst_id_m02
                         FROM t02_transact_log_cash_arc_all t
                          JOIN u01_customer u01 ON t.t02_customer_id_u01 = u01.u01_id
                          JOIN m21_introducing_broker m21 ON u01.u01_ib_id_m21 = m21.m21_id
                         WHERE t02_txn_code IN (''STLBUY'', ''STLSEL'')
                         AND t02_create_date BETWEEN TO_DATE (
                                                                      '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                                                      ''DD-MM-YYYY'')
                                                              AND  TO_DATE (
                                                                       '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                                                                       ''DD-MM-YYYY'')
                                                                   + .99999
                      GROUP BY u01.u01_ib_id_m21, t02_inst_id_m02';

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