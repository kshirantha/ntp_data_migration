CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_issue_locations
(
    m14_id,
    m14_name,
    m14_name_lang,
    status,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    country,
    m14_country_id_m05,
    m14_status_id_v01,
    m14_institute_id_m02
)
AS
    SELECT m14.m14_id,
           m14.m14_name,
           m14.m14_name_lang,
           status_list.v01_description AS status,
           u17_created_by.u17_full_name AS created_by_name,
           u17_modified_by.u17_full_name AS modified_by_name,
           u17_status_changed.u17_full_name AS status_changed_by_name,
           m05.m05_name AS country,
           m14.m14_country_id_m05,
           m14.m14_status_id_v01,
           m14.m14_institute_id_m02
      FROM m14_issue_location m14
           JOIN u17_employee u17_created_by
               ON m14.m14_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m14.m14_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_status_changed
               ON m14.m14_status_changed_by_id_u17 =
                      u17_status_changed.u17_id
           LEFT JOIN m05_country m05 ON m14.m14_country_id_m05 = m05.m05_id
           LEFT JOIN vw_status_list status_list
               ON m14.m14_status_id_v01 = status_list.v01_id
/