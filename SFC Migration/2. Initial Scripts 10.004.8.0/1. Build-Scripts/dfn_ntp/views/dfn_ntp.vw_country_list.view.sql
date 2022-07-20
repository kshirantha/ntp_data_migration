CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_country_list
(
    m05_id,
    m05_code,
    m05_name,
    m05_name_lang,
    m05_access_level_id_v01,
    m05_created_by_id_u17,
    m05_created_date,
    m05_status_id_v01,
    m05_modified_by_id_u17,
    m05_modified_date,
    m05_status_changed_by_id_u17,
    m05_status_changed_date,
    m05_external_ref,
    accesslevel,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    status
)
AS
    ( (SELECT m05_id,
              m05_code,
              m05_name,
              m05_name_lang,
              m05_access_level_id_v01,
              m05_created_by_id_u17,
              m05_created_date,
              m05_status_id_v01,
              m05_modified_by_id_u17,
              m05_modified_date,
              m05_status_changed_by_id_u17,
              m05_status_changed_date,
              m05_external_ref,
              accesslevel.v01_description AS accesslevel,
              u17_created.u17_full_name AS created_by_name,
              u17_modified.u17_full_name AS modified_by_name,
              u17_status_changed.u17_full_name AS status_changed_by_name,
              status_list.v01_description AS status
         FROM m05_country m05,
              vw_status_list status_list,
              (SELECT *
                 FROM v01_system_master_data a
                WHERE v01_type = 1) accesslevel,
              u17_employee u17_created,
              u17_employee u17_modified,
              u17_employee u17_status_changed
        WHERE     m05_status_id_v01 = status_list.v01_id(+)
              AND m05_access_level_id_v01 = accesslevel.v01_id(+)
              AND m05.m05_created_by_id_u17 = u17_created.u17_id(+)
              AND m05.m05_modified_by_id_u17 = u17_modified.u17_id(+)
              AND m05.m05_status_changed_by_id_u17 =
                      u17_status_changed.u17_id(+)));
/
