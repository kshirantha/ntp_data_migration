CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_traded_symbol_list (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    pinstituteid      IN     NUMBER,
    pfromdate         IN     DATE,
    ptodate           IN     DATE,
    psortby                  VARCHAR2 DEFAULT NULL,
    pfromrownumber           NUMBER DEFAULT NULL,
    ptorownumber             NUMBER DEFAULT NULL,
    psearchcriteria          VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           '
            SELECT m20.m20_id,
                   m01.m01_exchange_code,
                   m20.m20_symbol_code,
                   status.v01_description AS status,
                   m20.m20_instrument_type_code_v09,
                   m20.m20_cusip_no,
                   m20.m20_isincode,
                   m20.m20_reuters_code,
                   m63.m63_sector_code,
                   m20.m20_currency_code_m03,
                   access_level.v01_description,
                   CASE
                       WHEN m20.m20_instrument_type_code_v09 != ''CS''
                       THEN
                           TO_DATE (m20e.m20_maturity_myear || m20e.m20_maturity_day,
                                    ''yyyymmdd'')
                   END
                       AS m20_maturity_date,
                   m20.m20_price_ratio,
                   m20.m20_market_code_m29,
                   CASE WHEN m20.m20_small_orders = 0 THEN ''No'' ELSE ''Yes'' END
                       AS small_orders,
                   m20.m20_small_order_value,
                   CASE WHEN m20.m20_sharia_complient = 0 THEN ''No'' ELSE ''Yes'' END
                       AS sharia_complient,
                   m20.m20_lasttradeprice,
                   m20.m20_today_closed,
                   m20.m20_previous_closed,
                   m20.m20_price_symbol_code_m20,
                   CASE
                       WHEN m20.m20_market_segment = 0 THEN ''Main Market''
                       ELSE ''Second Market''
                   END
                       AS market_segment
              FROM m20_symbol m20
                   JOIN
                   (SELECT t01.t01_symbol_id_m20
                      FROM vw_t01_order_list_base t01
                     WHERE     t01.t01_date_time BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'')
                            AND TO_DATE('''
        || TO_CHAR (ptodate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'') + 0.99999
                           AND t01.t01_side IN (1, 2)
                    GROUP BY t01.t01_symbol_id_m20)
                       ON m20.m20_id = t01_symbol_id_m20
                   LEFT JOIN vw_status_list status
                       ON m20.m20_status_id_v01 = status.v01_id
                   LEFT JOIN m01_exchanges m01
                       ON m20.m20_exchange_id_m01 = m01.m01_id
                   LEFT JOIN m63_sectors m63 ON m20.m20_sectors_id_m63 = m63.m63_id
                   LEFT JOIN vw_access_level access_level
                       ON m20.m20_access_level_id_v01 = access_level.v01_id
                   LEFT JOIN m20_symbol_extended m20e ON m20.m20_id = m20e.m20_id
             WHERE m20.m20_institute_id_m02 = '
        || pinstituteid;

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