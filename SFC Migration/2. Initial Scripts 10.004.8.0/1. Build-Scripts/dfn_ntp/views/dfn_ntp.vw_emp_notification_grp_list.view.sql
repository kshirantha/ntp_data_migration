CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_emp_notification_grp_list
(
    u29_id,
    u29_employee_id_u17,
    u29_notification_group_id_m52,
    u29_assigned_by_id_u17,
    assigned_by_name,
    u29_assigned_date,
    u29_status_id_v01,
    status,
    u29_status_changed_by_id_u17,
    status_changed_by_name,
    u29_status_changed_date,
    m52_name,
    m52_id
)
AS
    SELECT u29.u29_id,
           u29.u29_employee_id_u17,
           u29.u29_notification_group_id_m52,
           u29.u29_assigned_by_id_u17,
           u17_assigned.u17_full_name AS assigned_by_name,
           u29.u29_assigned_date,
           u29.u29_status_id_v01,
           status_list.v01_description AS status,
           u29.u29_status_changed_by_id_u17,
           u17_status_changed.u17_full_name AS status_changed_by_name,
           u29.u29_status_changed_date,
           m52.m52_name,
           m52.m52_id
      FROM u29_emp_notification_groups u29,
           vw_status_list status_list,
           u17_employee u17_assigned,
           u17_employee u17_status_changed,
           m52_notification_group m52
     WHERE     u29.u29_status_id_v01 = status_list.v01_id(+)
           AND u29.u29_assigned_by_id_u17 = u17_assigned.u17_id(+)
           AND u29.u29_status_changed_by_id_u17 =
                   u17_status_changed.u17_id(+)
           AND u29.u29_notification_group_id_m52 = m52.m52_id(+);
/
