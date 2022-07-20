CREATE OR REPLACE PROCEDURE dfn_ntp.sp_dealer_activity_statistics (
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
    l_qry                    VARCHAR2 (10000);
    s1                       VARCHAR2 (15000);
    s2                       VARCHAR2 (15000);
    l_maximum_gtd_validity   NUMBER (10);
BEGIN
    SELECT NVL (MAX (v00_value), 90)
      INTO l_maximum_gtd_validity
      FROM v00_sys_config
     WHERE v00_key = 'MAXIMUM_GTD_VALIDITY';

    l_qry :=
           'SELECT   m07.m07_location_code AS location_code,
                     m07.m07_name AS location,
                     u17.u17_id AS dealer_id,
                     u17.u17_employee_no AS dealer_no,
                     u17_full_name AS user_name,
                     t01a.buy_cnt,
                     t01a.sell_cnt,
                     t01a.modified_orders,
                     t01a.cancelled_orders,
                     NVL (t01a.t01_commission, 0) AS commission,
                     t01a.ord_cnt,
                     u17.u17_institution_id_m02

              FROM   (  SELECT   t01_dealer_id_u17,
                                 COUNT ( * ) AS ord_cnt,
                                 SUM (CASE WHEN t01_side = 1 THEN 1 ELSE 0 END)
                                     AS buy_cnt,
                                 SUM (CASE WHEN t01_side = 2 THEN 1 ELSE 0 END)
                                     AS sell_cnt,
                                 SUM(CASE
                                         WHEN t01_status_id_v30 = ''f'' THEN 1
                                         ELSE 0
                                     END)
                                     AS modified_orders,
                                 SUM(CASE
                                         WHEN t01_status_id_v30 = ''4'' THEN 1
                                         ELSE 0
                                     END)
                                     AS cancelled_orders,
                                 SUM(CASE
                                        WHEN t01_status_id_v30 IN
                                            (''2'', ''1'', ''4'', ''C'', ''q'', ''r'')
                                            AND t01_cum_quantity > 0
                                        THEN
                                            t01_commission
                                        ELSE
                                            0
                                    END)
                                    AS t01_commission
                          FROM   t01_order_all
                          WHERE t01_institution_id_m02 = '
        || pinstitute
        || '
                         AND t01_dealer_id_u17 IS NOT NULL
                         AND t01_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate - l_maximum_gtd_validity, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
                                                      AND  TO_DATE('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')+.99999
                      AND t01_last_updated_date_time BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
                                                      AND  TO_DATE('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')+.99999
                      GROUP BY   t01_dealer_id_u17) t01a
            JOIN u17_employee u17
                ON t01a.t01_dealer_id_u17 = u17.u17_id
            LEFT JOIN m07_location m07
                ON u17.u17_location_id_m07 = m07.m07_id';

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
