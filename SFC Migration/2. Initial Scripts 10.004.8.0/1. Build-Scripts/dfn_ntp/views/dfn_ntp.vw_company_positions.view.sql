CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_company_positions
(
    m114_id,
    m114_description,
    m114_description_lang,
    m114_created_date,
    m114_modified_date,
    m114_status_id_v01,
    status_description,
    status_description_lang,
    m114_status_changed_date,
    m114_politically_exposed,
    politically_exposed_desc,
    m114_created_by_id_u17,
    m114_modified_by_id_u17,
    m114_status_changed_by_id_u17,
    m114_institute_id_m02,
    status_changed_by_full_name
)
AS
    SELECT m114_id,
           m114_description,
           m114_description_lang,
           m114_created_date,
           m114_modified_date,
           m114_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m114_status_changed_date,
           m114_politically_exposed,
           CASE WHEN m114_politically_exposed = 1 THEN 'Yes' ELSE 'No' END
               AS politically_exposed_desc,
           m114_created_by_id_u17,
           m114_modified_by_id_u17,
           m114_status_changed_by_id_u17,
           m114_institute_id_m02,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM m114_company_positions m114
           JOIN u17_employee u17_status_changed_by
               ON m114.m114_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           JOIN vw_status_list status_list
               ON m114.m114_status_id_v01 = status_list.v01_id
/