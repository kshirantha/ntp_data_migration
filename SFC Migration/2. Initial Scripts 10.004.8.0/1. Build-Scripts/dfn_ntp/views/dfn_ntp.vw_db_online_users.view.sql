CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_db_online_users
(
    institute,
    channel,
    usercount
)
AS
      SELECT u46.u17_institution_id_m02 AS institute,
             v29.v29_description AS channel,
             COUNT (*) AS usercount
        FROM     u46_user_sessions_all u46
             LEFT JOIN
                 v29_order_channel v29
             ON u46.u46_channel_id_v29 = v29.v29_id
    GROUP BY u46.u17_institution_id_m02, v29.v29_description
/

DROP VIEW dfn_ntp.vw_db_online_users
/