CREATE OR REPLACE PROCEDURE dfn_ntp.sp_db_online_users (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    p_institution_id   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
          SELECT v29.v29_description AS channel, COUNT (*) AS usercount
            FROM     u46_user_sessions_all u46
                 LEFT JOIN
                     v29_order_channel v29
                 ON u46.u46_channel_id_v29 = v29.v29_id
           WHERE u46.u17_institution_id_m02 = p_institution_id
        GROUP BY v29.v29_description;
END;
/
