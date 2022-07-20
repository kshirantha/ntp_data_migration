CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_om_questionnaire (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    productid         IN     VARCHAR2 DEFAULT NULL,
    pintituteid       IN     NUMBER,
    psortby                  VARCHAR2 DEFAULT NULL,
    pfromrownumber           NUMBER DEFAULT NULL,
    ptorownumber             NUMBER DEFAULT NULL,
    psearchcriteria          VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT
            a.m183_id,
            a.m183_product_id_m73,
            a.margin_product,
            a.m183_description,
            a.m183_description_lang,
            a.m183_status_id_v01,
            a.status,
            a.m183_created_by_id_u17,
            a.created_by_full_name,
            a.m183_created_date,
            a.m183_status_changed_by_id_u17,
            a.status_changed_by_full_name,
            a.m183_status_changed_date,
            a.m183_modified_by_id_u17,
            a.modified_by_full_name,
            a.m183_modified_date,
            a.m183_institute_id_m02
        FROM vw_om_questionnaire a
        WHERE a.m183_product_id_m73='
        || productid
        || ' AND a.m183_institute_id_m02 = '
        || pintituteid;

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              psortby          => NULL,
                              ptorownumber     => NULL,
                              pfromrownumber   => NULL,
                              l_qry            => l_qry);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
