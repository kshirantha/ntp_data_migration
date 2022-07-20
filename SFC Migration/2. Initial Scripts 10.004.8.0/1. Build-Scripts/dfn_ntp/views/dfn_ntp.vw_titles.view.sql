CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_titles
(
    m130_id,
    m130_description,
    m130_description_lang,
    m130_status_id_v01,
    m130_status_changed_date,
    m130_created_by_id_u17,
    m130_created_date,
    m130_modified_by_id_u17,
    m130_modified_date,
    m130_status_changed_by_id_u17,
    status,
    status_lang,
    status_changed_by_full_name,
    modified_by_full_name,
    created_by_full_name
)
AS
    SELECT m130.m130_id,
           m130.m130_description,
           m130.m130_description_lang,
           m130.m130_status_id_v01,
           m130.m130_status_changed_date,
           m130.m130_created_by_id_u17,
           m130.m130_created_date,
           m130.m130_modified_by_id_u17,
           m130.m130_modified_date,
           m130.m130_status_changed_by_id_u17,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u17_created_by.u17_full_name AS created_by_full_name
      FROM m130_titles m130
           LEFT JOIN vw_status_list status_list
               ON m130.m130_status_id_v01 = status_list.v01_id
           JOIN u17_employee u17_created_by
               ON m130.m130_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m130.m130_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON m130.m130_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id;
/
