CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_a08_aprl_column_audit_log
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
    a08_institute_id_m02,
    status_description,
    status_changed_by_full_name,
    current_value,
    new_value,
    column_description
)
AS
    SELECT a08.a08_id,
           a08.a08_approval_audit_id_a07,
           a08.a08_table_id_m53,
           a08.a08_table_row_id,
           a08.a08_status_id_v01,
           a08.a08_action_by_id_u17,
           a08.a08_action_date,
           a08.a08_created_by_id_u17,
           a08.a08_created_date,
           a08.a08_institute_id_m02,
           status_list.v01_description AS status_description,
           statusby.u17_full_name AS status_changed_by_full_name,
           a07.a07_current_value AS current_value,
           a07.a07_new_value AS new_value,
           a07.a07_column_description_m83 AS column_description
      FROM a08_approval_col_audit_log_all a08
           LEFT JOIN vw_status_list status_list
               ON a08.a08_status_id_v01 = status_list.v01_id
           LEFT JOIN u17_employee statusby
               ON a08.a08_action_by_id_u17 = statusby.u17_id
           LEFT JOIN a07_approval_column_audit_all a07
               ON a08.a08_approval_audit_id_a07 = a07.a07_id
/
