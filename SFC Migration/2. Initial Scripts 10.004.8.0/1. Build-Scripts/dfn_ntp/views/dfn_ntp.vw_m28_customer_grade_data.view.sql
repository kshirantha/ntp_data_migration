CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m28_customer_grade_data
(
    m28_id,
    m28_from_value,
    m28_to_value,
    m28_grade_label,
    m28_institution_id_m02,
    m28_version,
    m28_created_by_id_u17,
    m28_created_date,
    m28_modified_by_id_u17,
    m28_modified_date,
    m28_status_id_v01,
    m28_status_changed_by_id_u17,
    m28_status_changed_date,
    status_description,
    status_description_lang,
    status_changed_by_full_name
)
AS
    SELECT m28_id,
           m28_from_value,
           m28_to_value,
           m28_grade_label,
           m28_institution_id_m02,
           m28_version,
           m28_created_by_id_u17,
           m28_created_date,
           m28_modified_by_id_u17,
           m28_modified_date,
           m28_status_id_v01,
           m28_status_changed_by_id_u17,
           m28_status_changed_date,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM m28_customer_grade_data m28
           JOIN u17_employee u17_status_changed_by
               ON m28.m28_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           JOIN vw_status_list status_list
               ON m28.m28_status_id_v01 = status_list.v01_id;
/
