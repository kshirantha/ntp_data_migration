CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m33_nationality_category
(
    m33_id,
    m33_description,
    m33_created_date,
    m33_modified_date,
    m33_status_id_v01,
    status_description,
    status_description_lang,
    m33_status_changed_date,
    m33_created_by_id_u17,
    m33_modified_by_id_u17,
    m33_status_changed_by_id_u17,
    status_changed_by_full_name
)
AS
    SELECT m33_id,
           m33_description,
           m33_created_date,
           m33_modified_date,
           m33_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m33_status_changed_date,
           m33_created_by_id_u17,
           m33_modified_by_id_u17,
           m33_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM m33_nationality_category m33
           JOIN u17_employee u17_status_changed_by
               ON m33.m33_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           JOIN vw_status_list status_list
               ON m33.m33_status_id_v01 = status_list.v01_id;
/
