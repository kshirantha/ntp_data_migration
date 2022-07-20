CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_system_notification (
    p_view              OUT SYS_REFCURSOR,
    p_record_count   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT ROWNUM AS row_num, system_notifications.*
          FROM (  SELECT t77.t77_event_id_m148,
                         t77.t77_notify_type,
                         t77.t77_event_data,
                         t77.t77_created_date,
                         t77.t77_id,
                         t77.t77_status
                    FROM t77_system_notify_eventdata t77
                   WHERE t77.t77_notify_type = 1 AND t77.t77_status = 0
                ORDER BY t77_created_date DESC) system_notifications
         WHERE ROWNUM BETWEEN 1 AND p_record_count;

    FOR i IN (SELECT ROWNUM AS row_num, system_notifications.*
                FROM (  SELECT t77.t77_id
                          FROM t77_system_notify_eventdata t77
                         WHERE t77_notify_type = 1 AND t77.t77_status = 0
                      ORDER BY t77_created_date DESC) system_notifications
               WHERE ROWNUM BETWEEN 1 AND p_record_count)
    LOOP
        UPDATE t77_system_notify_eventdata t77
           SET t77.t77_status = 1
         WHERE t77.t77_id = i.t77_id;
    END LOOP;
END;
/