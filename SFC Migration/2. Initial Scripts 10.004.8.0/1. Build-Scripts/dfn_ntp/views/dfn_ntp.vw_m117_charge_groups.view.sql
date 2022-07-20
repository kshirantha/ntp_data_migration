CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m117_charge_groups
(
    m117_id,
    m117_name,
    m117_description,
    m117_created_date,
    m117_created_by_id_u17,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    m117_modified_date,
    m117_modified_by_id_u17,
    m117_status_id_v01,
    m117_status_changed_date,
    status,
    m117_is_default,
   m117_institute_id_m02,
   is_default )
AS
    SELECT m117.m117_id,
           m117.m117_name,
           m117.m117_description,
           m117.m117_created_date,
           m117.m117_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_name,
           u17_modified_by.u17_full_name AS modified_by_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_name,
           m117.m117_modified_date,
           m117.m117_modified_by_id_u17,
           m117.m117_status_id_v01,
           m117_status_changed_date,
           status_list.v01_description AS status,
           m117_is_default,
            m117_institute_id_m02,
           CASE m117_is_default WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS is_default
      FROM m117_charge_groups m117
           JOIN u17_employee u17_created_by
               ON m117.m117_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m117.m117_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON m117.m117_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m117.m117_status_id_v01 = status_list.v01_id;
/
