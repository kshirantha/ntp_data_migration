
CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_uploaded_customer (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    psortby                  VARCHAR2 DEFAULT NULL,
    pfromrownumber           NUMBER DEFAULT NULL,
    ptorownumber             NUMBER DEFAULT NULL,
    psearchcriteria          VARCHAR2 DEFAULT NULL,
    pfromdate                DATE DEFAULT SYSDATE,
    ptodate                  DATE DEFAULT SYSDATE,
    p_template_name          VARCHAR2,
    p_batch_id        IN     NUMBER)
IS
    l_qry   VARCHAR2 (10000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    -- l_qry := 'SELECT * FROM e_tmpl_6_' || p_template_name;
    l_qry :=
           'SELECT t84_member AS MEMBER,
                       t84_account AS account,
                       t84_reference AS reference,
                       t84_identification_number identification_number,
                       t84_registry_ident AS registry_ident,
                       t84_birth_date AS birth_date,
                       t84_title AS title,
                       t84_long_name AS long_name,
                       t84_guardian_ident_number AS guardian_ident_number,
                       t84_guardian AS guardian,
                       t84_address_line_one AS address_line_one,
                       t84_address_line_two AS address_line_two,
                       t84_address_line_three AS address_line_three,
                       t84_postal_code AS postal_code,
                       t84_city AS city,
                       t84_tax_collection_point AS tax_collection_point,
                       t84_country_code AS country_code,
                       t84_guard_address_line_one AS guard_address_line_one,
                       t84_postal_code2 AS postal_code2,
                       t84_city2 AS city2,
                       t84_tax_collection_point2 AS tax_collection_point2,
                       t84_country_code2 AS country_code2,
                       t84_phone_number_one AS phone_number_one,
                       t84_swift_code AS swift_code,
                       t84_bank_account AS bank_account,
                       t84_individual_id_one AS individual_id_one,
                       t84_individual_id_two AS individual_id_two,
                       t84_individual_id_three AS individual_id_three,
                       t84_corporate_id_one AS corporate_id_one,
                       t84_corporate_id_two AS corporate_id_two,
                       t84_citizenship AS citizenship,
                       t84_gender AS gender,
                       t84_change_date AS change_date,
                       t84_primary_institute_id_m02 AS primary_institute_id_m02,
                       t84_batch_id_t80 AS batch_id_t80
                  FROM t84_customer_f
                 WHERE t84_batch_id_t80 = '
        || p_batch_id;

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
