CREATE OR REPLACE PROCEDURE dfn_ntp.get_dealer_wise_commission (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pinstitute            NUMBER)
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

    l_qry :=
           'SELECT CASE WHEN t02_dealer_id_u17 IS NULL THEN 0 ELSE t02_dealer_id_u17 END
                         AS dealer_id,
                     CASE
                         WHEN t02_dealer_id_u17 IS NULL THEN ''Online User''
                         ELSE u17.u17_full_name
                     END
                         AS dealer_name,
                       ABS (total_turnover) AS total_turnover,
                               ABS (commission - exchange_commission)
                                   AS broker_commission,
                               ABS (exchange_commission)
                                   AS exchange_commission,
                               ABS (discounted_commission)
                                   AS discounted_commission,
                               ABS (commission + discounted_commission)
                                   AS gross_commission,
                               ABS (commission) AS charged_commission,
                               executed_orders AS executed_orders,
                               t02_inst_id_m02
                FROM (  SELECT t02_dealer_id_u17,
                                       COUNT (DISTINCT t02_order_no)
                                           AS executed_orders,
                                       SUM (t02_commission_adjst)
                                           AS commission,
                                       SUM (t02_exg_commission)
                                           AS exchange_commission,
                                       SUM (t02_discount)
                                           AS discounted_commission,
                                       SUM (ABS (t02_amnt_in_stl_currency))
                                           AS total_turnover,
                                       MAX (t02_inst_id_m02)
                                           AS t02_inst_id_m02
                                  FROM t02_transact_log_cash_arc_all
                         WHERE t02_inst_id_m02 = '
        || pinstitute
        || '
                         AND t02_txn_code IN (''STLBUY'', ''STLSEL'')
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
                    GROUP BY t02_dealer_id_u17) t
                     LEFT JOIN u17_employee u17
                         ON t.t02_dealer_id_u17 = u17.u17_id';

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