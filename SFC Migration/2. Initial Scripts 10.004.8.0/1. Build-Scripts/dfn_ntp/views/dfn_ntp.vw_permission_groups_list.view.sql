CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_permission_groups_list
(
    m45_id,
    m45_group_name,
    m45_group_enabled,
    group_enabled,
    m45_created_date,
    m45_created_by_id_u17,
    created_by_name,
    m45_institute_id_m02,
    m45_modified_by_id_u17,
    modified_by_name,
    m45_modified_date,
    m45_status_id_v01,
    m45_status_changed_by_id_u17,
    status_changed_by_name,
    m45_status_changed_date,
    m45_editable,
    editable,
    m45_is_root_inst_only,
    status
)
AS
    SELECT m45.m45_id,
           m45.m45_group_name,
           m45.m45_group_enabled,
           CASE WHEN m45.m45_group_enabled = 1 THEN 'Yes' ELSE 'No' END
               AS group_enabled,
           m45.m45_created_date,
           m45.m45_created_by_id_u17,
           u17_created.u17_full_name AS created_by_name,
           m45.m45_institute_id_m02,
           m45.m45_modified_by_id_u17,
           u17_modified.u17_full_name AS modified_by_name,
           m45.m45_modified_date,
           m45.m45_status_id_v01,
           m45.m45_status_changed_by_id_u17,
           u17_status_changed.u17_full_name AS status_changed_by_name,
           m45.m45_status_changed_date,
           m45.m45_editable,
           CASE WHEN m45.m45_editable = 1 THEN 'Yes' ELSE 'No' END
               AS editable,
           m45.m45_is_root_inst_only,
           status_list.v01_description AS status
      FROM m45_permission_groups m45,
           vw_status_list status_list,
           u17_employee u17_created,
           u17_employee u17_modified,
           u17_employee u17_status_changed
     WHERE     m45.m45_status_id_v01 = status_list.v01_id(+)
           AND m45.m45_created_by_id_u17 = u17_created.u17_id(+)
           AND m45.m45_modified_by_id_u17 = u17_modified.u17_id(+)
           AND m45.m45_status_changed_by_id_u17 =
                   u17_status_changed.u17_id(+);
/
