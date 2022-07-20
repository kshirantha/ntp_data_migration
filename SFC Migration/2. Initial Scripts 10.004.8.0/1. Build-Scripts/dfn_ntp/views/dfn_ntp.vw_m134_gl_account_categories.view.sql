CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m134_gl_account_categories
(
    m134_id,
    m134_description,
    m134_description_lang,
    m134_account_type_id_m133,
    m134_institute_id_m02,
    m134_created_by_id_u17,
    m134_created_date,
    m134_modified_by_id_u17,
    m134_modified_date,
    m134_status_id_v01,
    m134_status_changed_by_id_u17,
    m134_status_changed_date,
    account_types_desc,
    account_types_desc_lang,
    status,
    status_lang,
    created_by_full_name,
    modified_by_full_name,
    status_changed_by_full_name
)
AS
    SELECT m134.m134_id,
           m134.m134_description,
           m134.m134_description_lang,
           m134.m134_account_type_id_m133,
           m134.m134_institute_id_m02,
           m134.m134_created_by_id_u17,
           m134.m134_created_date,
           m134.m134_modified_by_id_u17,
           m134.m134_modified_date,
           m134.m134_status_id_v01,
           m134.m134_status_changed_by_id_u17,
           m134.m134_status_changed_date,
           m133.m133_description AS account_types_desc,
           m133.m133_description_lang AS account_types_desc_lang,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM m134_gl_account_categories m134
           JOIN m133_gl_account_types m133
               ON m134.m134_account_type_id_m133 = m133.m133_id
           JOIN vw_status_list status_list
               ON m134.m134_status_id_v01 = status_list.v01_id
           JOIN u17_employee u17_created_by
               ON m134.m134_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m134.m134_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m134.m134_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id;
/
