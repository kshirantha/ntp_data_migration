CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m133_gl_account_types
(
    m133_id,
    m133_description,
    m133_description_lang,
    m133_created_by_id_u17,
    m133_created_date,
    m133_modified_by_id_u17,
    m133_modified_date,
    m133_status_id_v01,
    m133_status_changed_by_id_u17,
    m133_status_changed_date,
    m133_institute_id_m02,
    status,
    status_lang,
    created_by_full_name,
    modified_by_full_name,
    status_changed_by_full_name
)
AS
    SELECT m133.m133_id,
           m133.m133_description,
           m133.m133_description_lang,
           m133.m133_created_by_id_u17,
           m133.m133_created_date,
           m133.m133_modified_by_id_u17,
           m133.m133_modified_date,
           m133.m133_status_id_v01,
           m133.m133_status_changed_by_id_u17,
           m133.m133_status_changed_date,
           m133.m133_institute_id_m02,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM m133_gl_account_types m133
           JOIN vw_status_list status_list
               ON m133.m133_status_id_v01 = status_list.v01_id
           JOIN u17_employee u17_created_by
               ON m133.m133_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m133.m133_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m133.m133_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id;
/
