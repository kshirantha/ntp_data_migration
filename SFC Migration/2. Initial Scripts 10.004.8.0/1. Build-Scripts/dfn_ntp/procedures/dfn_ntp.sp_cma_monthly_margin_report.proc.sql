CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cma_monthly_margin_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
        'SELECT u01.u01_account_category_id_v01,
                 CASE
                     WHEN u01_account_category_id_v01 = 1 THEN ''Retails (individuals)''
                     WHEN u01_account_category_id_v01 = 2 THEN ''Corporates''
                     WHEN u01_account_category_id_v01 = 3 THEN ''Both''
                 END
                     AS account_category,
                 SUM (marg.u23_max_margin_limit) AS margin_commitment,
                 SUM (marg.limit_utilization) AS outstanding_balance,
                 SUM (marg.marginable_pv) AS eligible_margin_collateral,
                 0 AS unsecured_exposure,
                 0 AS secured_exposure
            FROM     u01_customer u01
                 JOIN
                     vw_dc_rpt_margin_sum_master marg
                 ON marg.u01_id = u01.u01_id
        GROUP BY u01.u01_account_category_id_v01';

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
