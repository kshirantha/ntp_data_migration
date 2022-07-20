CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_permission_grp_entlmnt_list
(
    m46_id,
    m46_group_id_m45,
    m46_task_id_v04,
    m46_added_by_id_u17,
    added_by_name,
    m46_added_date,
    m46_l1_by_id_u17,
    m46_l1_date,
    m46_l2_by_id_u17,
    m46_l2_date,
    m46_status_id_v01,
    m46_status_changed_by_id_u17,
    status_changed_by_name,
    m46_status_changed_date,
    status_text,
    v04_id,
    u17_institution_id_m02
)
AS
    SELECT m46.m46_id,
           m46.m46_group_id_m45,
           m46.m46_task_id_v04,
           m46.m46_added_by_id_u17,
           u17_added.u17_full_name AS added_by_name,
           m46.m46_added_date,
           m46.m46_l1_by_id_u17,
           m46.m46_l1_date,
           m46.m46_l2_by_id_u17,
           m46.m46_l2_date,
           m46.m46_status_id_v01,
           m46.m46_status_changed_by_id_u17,
           u17_status_changed.u17_full_name AS status_changed_by_name,
           m46.m46_status_changed_date,
           status_list.v01_description AS status_text,
           v04.v04_id,
           u17_added.u17_institution_id_m02
      FROM m46_permission_grp_entlements m46,
           vw_status_list status_list,
           u17_employee u17_added,
           u17_employee u17_status_changed,
           v04_entitlements v04
     WHERE     m46.m46_status_id_v01 = status_list.v01_id(+)
           AND m46.m46_added_by_id_u17 = u17_added.u17_id(+)
           AND m46.m46_status_changed_by_id_u17 =
                   u17_status_changed.u17_id(+)
           AND m46.m46_task_id_v04 = v04.v04_id(+);
/
