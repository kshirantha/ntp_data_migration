CREATE OR REPLACE FORCE VIEW dfn_ntp.h07_user_sessions_history_emp
(
    u17_login_name,
    u17_full_name,
    u17_institution_id_m02,
    h07_session_id,
    h07_channel_id,
    h07_login_time,
    h07_logout_time,
    v29_description
)
AS
    SELECT u17.u17_login_name,
           u17.u17_full_name,
           u17.u17_institution_id_m02,
           h07.h07_session_id,
           h07.h07_channel_id,
           h07.h07_login_time AS h07_login_time,
           h07.h07_logout_time AS h07_logout_time,
           v29.v29_description
      FROM h07_user_sessions_all h07
           INNER JOIN u17_employee u17
               ON h07.h07_login_id = u17.u17_id
           INNER JOIN v29_order_channel v29
               ON h07.h07_channel_id = v29.v29_id
/