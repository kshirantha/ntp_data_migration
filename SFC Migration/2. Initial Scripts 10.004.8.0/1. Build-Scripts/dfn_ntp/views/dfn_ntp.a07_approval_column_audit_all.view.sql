CREATE OR REPLACE FORCE VIEW dfn_ntp.a07_approval_column_audit_all
(
    a07_id,
    a07_table,
    a07_table_row_id,
    a07_status_id_v01,
    a07_next_status_id_v01,
    a07_current_approval_level,
    a07_no_of_approval,
    a07_is_approval_completed,
    a07_table_id_m53,
    a07_table_description,
    a07_column_description_m83,
    a07_column_name_m83,
    a07_current_value,
    a07_new_value,
    a07_last_updated_date,
    a07_last_update_by_id_u17,
    a07_class,
    a07_line_id_a03,
    a07_created_date,
    a07_created_by_id_u17,
    a07_comment,
    a07_action_on_approval,
    a07_use_a03_ready_to_save,
    a07_ready_to_save_value,
    a07_custom_type,
    a07_institute_id_m02,
    a07_dependant_no,
    a07_is_sensitive_data,
    a07_entitlement_id_v04
)
AS
    SELECT a07_id,
           a07_table,
           a07_table_row_id,
           a07_status_id_v01,
           a07_next_status_id_v01,
           a07_current_approval_level,
           a07_no_of_approval,
           a07_is_approval_completed,
           a07_table_id_m53,
           a07_table_description,
           a07_column_description_m83,
           a07_column_name_m83,
           a07_current_value,
           a07_new_value,
           a07_last_updated_date,
           a07_last_update_by_id_u17,
           a07_class,
           a07_line_id_a03,
           a07_created_date,
           a07_created_by_id_u17,
           a07_comment,
           a07_action_on_approval,
           a07_use_a03_ready_to_save,
           a07_ready_to_save_value,
           a07_custom_type,
           a07_institute_id_m02,
           a07_dependant_no,
           a07_is_sensitive_data,
           a07_entitlement_id_v04
      FROM dfn_ntp.a07_approval_column_audit
    UNION ALL
    SELECT a07_id,
           a07_table,
           a07_table_row_id,
           a07_status_id_v01,
           a07_next_status_id_v01,
           a07_current_approval_level,
           a07_no_of_approval,
           a07_is_approval_completed,
           a07_table_id_m53,
           a07_table_description,
           a07_column_description_m83,
           a07_column_name_m83,
           a07_current_value,
           a07_new_value,
           a07_last_updated_date,
           a07_last_update_by_id_u17,
           a07_class,
           a07_line_id_a03,
           a07_created_date,
           a07_created_by_id_u17,
           a07_comment,
           a07_action_on_approval,
           a07_use_a03_ready_to_save,
           a07_ready_to_save_value,
           a07_custom_type,
           a07_institute_id_m02,
           a07_dependant_no,
           a07_is_sensitive_data,
           a07_entitlement_id_v04
      FROM dfn_arc.a07_approval_column_audit
/
