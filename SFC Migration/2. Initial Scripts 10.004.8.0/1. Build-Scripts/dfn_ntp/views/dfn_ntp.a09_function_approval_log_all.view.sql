CREATE OR REPLACE FORCE VIEW dfn_ntp.a09_function_approval_log_all
(
    a09_id,
    a09_function_id_m88,
    a09_function_name_m88,
    a09_request_id,
    a09_status_id_v01,
    a09_action_by_id_u17,
    a09_action_date,
    a09_created_by_id_u17,
    a09_created_date,
    a09_narration,
    a09_reject_reason,
    a09_custom_type
)
AS
    SELECT a09_id,
           a09_function_id_m88,
           a09_function_name_m88,
           a09_request_id,
           a09_status_id_v01,
           a09_action_by_id_u17,
           a09_action_date,
           a09_created_by_id_u17,
           a09_created_date,
           a09_narration,
           a09_reject_reason,
           a09_custom_type
      FROM dfn_ntp.a09_function_approval_log
    UNION ALL
    SELECT a09_id,
           a09_function_id_m88,
           a09_function_name_m88,
           a09_request_id,
           a09_status_id_v01,
           a09_action_by_id_u17,
           a09_action_date,
           a09_created_by_id_u17,
           a09_created_date,
           a09_narration,
           a09_reject_reason,
           a09_custom_type
      FROM dfn_arc.a09_function_approval_log
/
