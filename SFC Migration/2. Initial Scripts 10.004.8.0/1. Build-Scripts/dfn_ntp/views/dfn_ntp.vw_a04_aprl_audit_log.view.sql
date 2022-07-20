CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_a04_aprl_audit_log
(
    a04_id,
    a04_table_row_id,
    a04_status_id_v01,
    a04_action_by_id_u17,
    a04_approval_master_id_a03,
    a04_table_id_m53,
    a04_created_by_id_u17,
    a04_created_date,
    a04_action_date,
    a04_institute_id_m02,
    status_description,
    status_changed_by_full_name
)
AS
    SELECT a04.a04_id,
           a04.a04_table_row_id,
           a04.a04_status_id_v01,
           a04.a04_action_by_id_u17,
           a04.a04_approval_master_id_a03,
           a04.a04_table_id_m53,
           a04.a04_created_by_id_u17,
           a04.a04_created_date,
           a04.a04_action_date,
           a04.a04_institute_id_m02,
           status_list.v01_description AS status_description,
           u_17_status_changed_by.u17_full_name
               AS status_changed_by_full_name
      FROM a04_approval_audit_log_all a04
           LEFT JOIN vw_status_list status_list
               ON a04.a04_status_id_v01 = status_list.v01_id
           LEFT JOIN u17_employee u_17_status_changed_by
               ON a04.a04_action_by_id_u17 = u_17_status_changed_by.u17_id
/
