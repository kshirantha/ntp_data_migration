CREATE OR REPLACE FORCE VIEW dfn_ntp.a18_user_login_audit_all
(
    a18_channel_id_v29,
    a18_appsvr_id,
    a18_ip,
    a18_login_name,
    a18_password,
    a18_version,
    a18_login_time,
    a18_status_id_v01,
    a18_login_id,
    a18_narration,
    a18_failed_attempts,
    a18_password_b,
    a18_entity_type,
    a18_institute_id_m02,
    a18_login_date
)
AS
    SELECT a18_channel_id_v29,
           a18_appsvr_id,
           a18_ip,
           a18_login_name,
           a18_password,
           a18_version,
           a18_login_time,
           a18_status_id_v01,
           a18_login_id,
           a18_narration,
           a18_failed_attempts,
           a18_password_b,
           a18_entity_type,
           a18_institute_id_m02,
           a18_login_date
      FROM dfn_ntp.a18_user_login_audit
    UNION ALL
    SELECT a18_channel_id_v29,
           a18_appsvr_id,
           a18_ip,
           a18_login_name,
           a18_password,
           a18_version,
           a18_login_time,
           a18_status_id_v01,
           a18_login_id,
           a18_narration,
           a18_failed_attempts,
           a18_password_b,
           a18_entity_type,
           a18_institute_id_m02,
           a18_login_date
      FROM dfn_arc.a18_user_login_audit
/
