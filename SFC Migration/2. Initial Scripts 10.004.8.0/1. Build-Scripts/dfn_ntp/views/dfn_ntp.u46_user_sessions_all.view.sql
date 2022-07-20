CREATE OR REPLACE FORCE VIEW dfn_ntp.u46_user_sessions_all
(
    u46_login_time,
    u17_login_name,
    u17_full_name,
    channel,
    u46_last_updated,
    u46_session_id,
    u17_institution_id_m02,
    u46_channel_id_v29
)
AS
    SELECT u46.u46_login_time,
           u17.u17_login_name,
           u17.u17_full_name,
           v29.v29_description AS channel,
           u46.u46_last_updated,
           u46.u46_session_id,
           u17.u17_institution_id_m02,
           u46.u46_channel_id_v29
      FROM u46_user_sessions u46, u17_employee u17, v29_order_channel v29
     WHERE     u46.u46_entity_id = u17.u17_id
           AND u46.u46_channel_id_v29 = v29.v29_id
           AND u46_entity_type = 2
/