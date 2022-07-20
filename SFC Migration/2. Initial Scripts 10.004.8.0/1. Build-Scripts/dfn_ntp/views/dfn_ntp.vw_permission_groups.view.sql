CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_permission_groups
(
    m45_id,
    m45_group_name,
    m45_group_enabled,
    m45_created_date,
    m45_created_by_id_u17,
    m45_institute_id_m02,
    m45_modified_by_id_u17,
    m45_modified_date,
    m45_status_id_v01,
    m45_status_changed_by_id_u17,
    m45_status_changed_date,
    m45_editable,
    m45_is_root_inst_only
)
AS
    SELECT m45_id,
           m45_group_name,
           m45_group_enabled,
           m45_created_date,
           m45_created_by_id_u17,
           m45_institute_id_m02,
           m45_modified_by_id_u17,
           m45_modified_date,
           m45_status_id_v01,
           m45_status_changed_by_id_u17,
           m45_status_changed_date,
           m45_editable,
           m45_is_root_inst_only
      FROM m45_permission_groups;
/
