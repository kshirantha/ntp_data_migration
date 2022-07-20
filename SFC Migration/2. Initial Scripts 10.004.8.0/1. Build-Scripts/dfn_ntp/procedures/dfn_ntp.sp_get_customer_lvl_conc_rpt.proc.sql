CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_customer_lvl_conc_rpt (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    pinstituteid      IN     NUMBER,
    pislocal          IN     NUMBER,
    ppctconcstock     IN     NUMBER,
    psortby                  VARCHAR2 DEFAULT NULL,
    pfromrownumber           NUMBER DEFAULT NULL,
    ptorownumber             NUMBER DEFAULT NULL,
    psearchcriteria          VARCHAR2 DEFAULT NULL)
IS
    l_qry      VARCHAR2 (15000);
    l_where    VARCHAR2 (2000);
    l_where2   VARCHAR2 (2000);
    s1         VARCHAR2 (15000);
    s2         VARCHAR2 (15000);
BEGIN
    IF (pislocal = 0)
    THEN
        l_where :=
            ' AND a.u07_exchange_code_m01 <> ''TDWL'' ' || psearchcriteria;
    ELSE
        l_where := ' AND a.u07_exchange_code_m01 = ''TDWL''';
    END IF;

    l_where2 := ' AND a.pct_conc_stock >= ' || ppctconcstock;

    l_qry :=
           '
        SELECT a.u06_external_ref_no,
           a.u07_exchange_account_no,
           a.u07_exchange_code_m01,
           a.customer_name,
           a.m73_name,
           a.u23_margin_expiry_date,
           a.u23_margin_percentage,
           a.u23_max_margin_limit,
           a.limit_utilization,
           a.portfolio_value,
           a.m20_symbol_code,
           a.m20_short_description,
           a.symbol_market_value,
           a.m78_marginable_per,
           a.marginable_pv,
           a.pct_conc_stock,
           a.actual_cov_ratio_pct_totpf,
           a.actual_cov_ratio_pct_mpv,
           a.u01_id,
           a.u07_institute_id_m02
      FROM vw_customer_level_conc_rpt a
      WHERE a.u07_institute_id_m02 = '
        || pinstituteid
        || l_where
        || l_where2;

    s1 :=
        fn_get_sp_data_query (psearchcriteria   => psearchcriteria,
                              psortby           => psortby,
                              ptorownumber      => ptorownumber,
                              pfromrownumber    => pfromrownumber,
                              l_qry             => l_qry);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
