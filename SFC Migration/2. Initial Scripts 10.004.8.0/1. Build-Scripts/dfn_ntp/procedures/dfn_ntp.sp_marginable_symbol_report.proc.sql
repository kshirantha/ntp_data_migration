CREATE OR REPLACE PROCEDURE dfn_ntp.sp_marginable_symbol_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (10000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
        'SELECT m20.m20_symbol_code,
       m01.m01_exchange_code,
       m20.m20_long_description,
       m20.m20_instrument_type_code_v09,
       m77.m77_global_marginable_per,
       m78.m78_marginable_per,
       CASE WHEN m78.m78_mariginability = 1 THEN ''Yes'' ELSE ''No'' END
           AS marginabale_symbol,
       m77.m77_name,
       m77.m77_id,
       status_list.v01_description,
       m78_institution_id_m02
  FROM m78_symbol_marginability m78
       JOIN m77_symbol_marginability_grps m77
           ON m78.m78_sym_margin_group_m77 = m77.m77_id
       JOIN m20_symbol m20
           ON m78.m78_symbol_id_m20 = m20.m20_id
       JOIN m01_exchanges m01
           ON m20.m20_exchange_id_m01 = m01.m01_id
       LEFT JOIN u17_employee u17
           ON m78.m78_status_changed_by_id_u17 = u17.u17_id
        LEFT JOIN vw_status_list status_list
               ON m78.m78_status_id_v01 = status_list.v01_id';

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
