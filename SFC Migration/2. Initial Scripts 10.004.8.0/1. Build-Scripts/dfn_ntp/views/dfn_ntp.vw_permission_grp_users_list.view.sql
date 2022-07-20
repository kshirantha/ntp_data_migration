CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_permission_grp_users_list
(
    m47_id,
    m47_user_id_u17,
    u17_full_name,
    m47_group_id_m45,
    m47_granted_by_id_u17,
    granted_by_name,
    m47_granted_date,
    m47_l1_by_id_u17,
    m47_l1_date,
    m47_l2_by_id_u17,
    m47_l2_date,
    m47_status_id_v01,
    m47_status_changed_by_id_u17,
    status_changed_by_name,
    m47_status_changed_date,
    status_text,
    m45_id,
    group_name,
    u17_institution_id_m02
)
AS
    SELECT m47.m47_id,
           m47.m47_user_id_u17,
           u17.u17_full_name,
           m47.m47_group_id_m45,
           m47.m47_granted_by_id_u17,
           u17_granted.u17_full_name AS granted_by_name,
           m47.m47_granted_date,
           m47.m47_l1_by_id_u17,
           m47.m47_l1_date,
           m47.m47_l2_by_id_u17,
           m47.m47_l2_date,
           m47.m47_status_id_v01,
           m47.m47_status_changed_by_id_u17,
           u17_status_changed.u17_full_name AS status_changed_by_name,
           m47.m47_status_changed_date,
           status_list.v01_description AS status_text,
           m45.m45_id,
           m45_group_name AS group_name,
           u17.u17_institution_id_m02
      FROM m47_permission_grp_users m47,
           vw_status_list status_list,
           u17_employee u17_granted,
           u17_employee u17_status_changed,
           u17_employee u17,
           m45_permission_groups m45
     WHERE     m47.m47_status_id_v01 = status_list.v01_id(+)
           AND m47.m47_granted_by_id_u17 = u17_granted.u17_id(+)
           AND m47.m47_status_changed_by_id_u17 =
                   u17_status_changed.u17_id(+)
           AND m47.m47_user_id_u17 = u17.u17_id(+)
           AND m47.m47_group_id_m45 = m45.m45_id;
/
