CREATE OR REPLACE FORCE VIEW dfn_ntp.a04_approval_audit_log_all
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
    a04_custom_type,
    a04_institute_id_m02
)
AS
    SELECT a04_id,
           a04_table_row_id,
           a04_status_id_v01,
           a04_action_by_id_u17,
           a04_approval_master_id_a03,
           a04_table_id_m53,
           a04_created_by_id_u17,
           a04_created_date,
           a04_action_date,
           a04_custom_type,
           a04_institute_id_m02
      FROM dfn_ntp.a04_approval_audit_log
    UNION ALL
    SELECT a04_id,
           a04_table_row_id,
           a04_status_id_v01,
           a04_action_by_id_u17,
           a04_approval_master_id_a03,
           a04_table_id_m53,
           a04_created_by_id_u17,
           a04_created_date,
           a04_action_date,
           a04_custom_type,
           a04_institute_id_m02
      FROM dfn_arc.a04_approval_audit_log
/
