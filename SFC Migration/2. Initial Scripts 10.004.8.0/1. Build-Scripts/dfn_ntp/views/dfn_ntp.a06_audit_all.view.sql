CREATE OR REPLACE FORCE VIEW dfn_ntp.a06_audit_all
(
    a06_id,
    a06_date,
    a06_user_id_u17,
    a06_activity_id_m82,
    a06_description,
    a06_reference_no,
    a06_channel_v29,
    a06_customer_id_u01,
    a06_login_id_u09,
    a06_user_login_id_u17,
    a06_ip,
    a06_connected_machine,
    a06_custom_type,
    a06_institute_id_m02
)
AS
    SELECT a06_id,
           a06_date,
           a06_user_id_u17,
           a06_activity_id_m82,
           a06_description,
           a06_reference_no,
           a06_channel_v29,
           a06_customer_id_u01,
           a06_login_id_u09,
           a06_user_login_id_u17,
           a06_ip,
           a06_connected_machine,
           a06_custom_type,
           a06_institute_id_m02
      FROM dfn_ntp.a06_audit
    UNION ALL
    SELECT a06_id,
           a06_date,
           a06_user_id_u17,
           a06_activity_id_m82,
           a06_description,
           a06_reference_no,
           a06_channel_v29,
           a06_customer_id_u01,
           a06_login_id_u09,
           a06_user_login_id_u17,
           a06_ip,
           a06_connected_machine,
           a06_custom_type,
           a06_institute_id_m02
      FROM dfn_arc.a06_audit
/
