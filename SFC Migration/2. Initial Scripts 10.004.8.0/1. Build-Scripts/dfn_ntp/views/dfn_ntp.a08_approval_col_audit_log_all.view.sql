CREATE OR REPLACE FORCE VIEW dfn_ntp.a08_approval_col_audit_log_all
(
    a08_id,
    a08_approval_audit_id_a07,
    a08_table_id_m53,
    a08_table_row_id,
    a08_status_id_v01,
    a08_action_by_id_u17,
    a08_action_date,
    a08_created_by_id_u17,
    a08_created_date,
    a08_custom_type,
    a08_institute_id_m02
)
AS
    SELECT a08_id,
           a08_approval_audit_id_a07,
           a08_table_id_m53,
           a08_table_row_id,
           a08_status_id_v01,
           a08_action_by_id_u17,
           a08_action_date,
           a08_created_by_id_u17,
           a08_created_date,
           a08_custom_type,
           a08_institute_id_m02
      FROM dfn_ntp.a08_approval_column_audit_log
    UNION ALL
    SELECT a08_id,
           a08_approval_audit_id_a07,
           a08_table_id_m53,
           a08_table_row_id,
           a08_status_id_v01,
           a08_action_by_id_u17,
           a08_action_date,
           a08_created_by_id_u17,
           a08_created_date,
           a08_custom_type,
           a08_institute_id_m02
      FROM dfn_arc.a08_approval_column_audit_log
/
