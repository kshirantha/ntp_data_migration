CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_trading_group
(
    m08_id,
    m08_institute_id_m02,
    m08_name,
    m08_name_lang,
    m08_additional_details,
    m08_created_by_id_u17,
    m08_created_date,
    m08_status_id_v01,
    m08_modified_by_id_u17,
    m08_modified_date,
    m08_status_changed_by_id_u17,
    m08_status_changed_date,
    m08_external_ref,
    m08_is_default,
    is_default,
    status,
    status_changed_by,
    created_by,
    modified_by
)
AS
    SELECT a.m08_id,
           a.m08_institute_id_m02,
           a.m08_name,
           a.m08_name_lang,
           a.m08_additional_details,
           a.m08_created_by_id_u17,
           a.m08_created_date,
           a.m08_status_id_v01,
           a.m08_modified_by_id_u17,
           a.m08_modified_date,
           a.m08_status_changed_by_id_u17,
           a.m08_status_changed_date,
           a.m08_external_ref,
           a.m08_is_default,
           CASE
               WHEN a.m08_is_default = 0 THEN 'No'
               WHEN a.m08_is_default = 1 THEN 'Yes'
           END
               AS is_default,
           status_list.v01_description AS status,
           u17_status_changed_by.u17_full_name AS status_changed_by,
           u17_created_by.u17_full_name AS created_by,
           u17_modified_by.u17_full_name AS modified_by
      FROM m08_trading_group a
           LEFT JOIN u17_employee u17_status_changed_by
               ON a.m08_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON a.m08_status_id_v01 = status_list.v01_id
           LEFT JOIN u17_employee u17_created_by
               ON a.m08_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON a.m08_modified_by_id_u17 = u17_modified_by.u17_id
/