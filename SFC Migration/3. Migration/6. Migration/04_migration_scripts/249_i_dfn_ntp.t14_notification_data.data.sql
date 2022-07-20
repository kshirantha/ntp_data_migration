DECLARE
    l_notification_data_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t14_t13_id), 0)
      INTO l_notification_data_id
      FROM dfn_ntp.t14_notification_data;

    DELETE FROM error_log
          WHERE mig_table = 'T14_NOTIFICATION_DATA';

    FOR i
        IN (SELECT tmp10.tmp10_id,
                   tmp10.tmp10_attached_file_name,
                   tmp10.tmp10_attached_file_data,
                   t14_map.new_notification_data_id
              FROM mubasher_oms.tmp10_cust_notifications@mubasher_db_link tmp10,
                   t13_notifications_mappings t13_map,
                   t14_notification_data_mappings t14_map
             WHERE     tmp10.tmp10_id = t13_map.old_notification_id
                   AND t13_map.old_notification_table =
                           'TMP10_CUST_NOTIFICATIONS'
                   AND tmp10.tmp10_id = t14_map.old_notification_data_id(+))
    LOOP
        BEGIN
            IF i.new_notification_data_id IS NULL
            THEN
                l_notification_data_id := l_notification_data_id + 1;

                INSERT
                  INTO dfn_ntp.t14_notification_data (t14_t13_id,
                                                      t14_attachment_name,
                                                      t14_attachment_data,
                                                      t14_custom_type)
                VALUES (l_notification_data_id, -- t14_t13_id
                        i.tmp10_attached_file_name, -- t14_attachment_name
                        i.tmp10_attached_file_data, -- t14_attachment_data
                        '1' -- t14_custom_type
                           );

                INSERT
                  INTO t14_notification_data_mappings (
                           old_notification_data_id,
                           new_notification_data_id)
                VALUES (i.tmp10_id, l_notification_data_id);
            ELSE
                UPDATE dfn_ntp.t14_notification_data
                   SET t14_attachment_name = i.tmp10_attached_file_name, -- t14_attachment_name
                       t14_attachment_data = i.tmp10_attached_file_data -- t14_attachment_data
                 WHERE t14_t13_id = i.new_notification_data_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T14_NOTIFICATION_DATA',
                                i.tmp10_id,
                                CASE
                                    WHEN i.new_notification_data_id IS NULL
                                    THEN
                                        l_notification_data_id
                                    ELSE
                                        i.new_notification_data_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_notification_data_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
