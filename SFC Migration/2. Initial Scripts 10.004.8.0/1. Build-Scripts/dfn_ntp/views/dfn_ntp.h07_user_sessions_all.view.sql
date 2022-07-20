CREATE OR REPLACE FORCE VIEW dfn_ntp.h07_user_sessions_all
(
    h07_session_id,
    h07_channel_id,
    h07_login_id,
    h07_auth_status,
    h07_login_time,
    h07_last_updated,
    h07_logout_time,
    h07_ip,
    h07_expiry_time,
    h07_entity_id,
    h07_entity_type,
    h07_institute_id_m02,
    h07_login_date,
    h07_last_upd_date
)
AS
    SELECT h07_session_id,
           h07_channel_id,
           h07_login_id,
           h07_auth_status,
           h07_login_time,
           h07_last_updated,
           h07_logout_time,
           h07_ip,
           h07_expiry_time,
           h07_entity_id,
           h07_entity_type,
           h07_institute_id_m02,
           h07_login_date,
           h07_last_upd_date
      FROM dfn_ntp.h07_user_sessions
    UNION ALL
    SELECT h07_session_id,
           h07_channel_id,
           h07_login_id,
           h07_auth_status,
           h07_login_time,
           h07_last_updated,
           h07_logout_time,
           h07_ip,
           h07_expiry_time,
           h07_entity_id,
           h07_entity_type,
           h07_institute_id_m02,
           h07_last_upd_date,
           h07_last_upd_date
      FROM dfn_arc.h07_user_sessions
/
