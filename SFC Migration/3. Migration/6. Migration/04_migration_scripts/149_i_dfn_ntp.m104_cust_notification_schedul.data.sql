DECLARE
    l_cust_noti_schedule_id   NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m104_id), 0)
      INTO l_cust_noti_schedule_id
      FROM dfn_ntp.m104_cust_notification_schedul;

    DELETE FROM error_log
          WHERE mig_table = 'M104_CUST_NOTIFICATION_SCHEDUL';

    FOR i
        IN (SELECT m141.m141_id,
                   u01_map.new_customer_id,
                   map14.map14_ntp_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m141_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by_new_id,
                   m141_created_date AS modified_date,
                   m104_map.new_cust_notify_sche_id
              FROM mubasher_oms.m141_cust_notification_schedul@mubasher_db_link m141,
                   u01_customer_mappings u01_map,
                   map14_notify_subitem_schd_m103 map14,
                   dfn_ntp.m103_notify_subitem_schedule m103,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m104_cust_notify_sche_mappings m104_map
             WHERE     m141.m141_customer_id = u01_map.old_customer_id
                   AND m141.m141_notification_item = map14.map14_oms_id
                   AND map14.map14_ntp_id = m103.m103_id
                   AND m141.m141_created_by = u17_created.old_employee_id(+)
                   AND m141.m141_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m141.m141_id =
                           m104_map.old_cust_notify_sche_id(+))
    LOOP
        BEGIN
            IF i.new_cust_notify_sche_id IS NULL
            THEN
                l_cust_noti_schedule_id := l_cust_noti_schedule_id + 1;

                INSERT
                  INTO dfn_ntp.m104_cust_notification_schedul (
                           m104_id,
                           m104_customer_id_u01,
                           m104_subitem_shedule_id_m103,
                           m104_created_by_id_u17,
                           m104_created_date,
                           m104_modified_by_id_u17,
                           m104_modified_date,
                           m104_is_live,
                           m104_custom_type)
                VALUES (l_cust_noti_schedule_id, --m104_id
                        i.new_customer_id, -- m104_customer_id_u01
                        i.map14_ntp_id, -- m104_subitem_shedule_id_m103
                        i.created_by_new_id, -- m104_created_by_id_u17
                        i.created_date, -- m104_created_date
                        i.modified_by_new_id, -- m104_modified_by_id_u17
                        i.modified_date, -- m104_modified_date
                        1, -- m104_is_live
                        1 -- m104_custom_type
                         );

                INSERT INTO m104_cust_notify_sche_mappings
                     VALUES (i.m141_id, l_cust_noti_schedule_id);
            ELSE
                UPDATE dfn_ntp.m104_cust_notification_schedul
                   SET m104_customer_id_u01 = i.new_customer_id, -- m104_customer_id_u01
                       m104_subitem_shedule_id_m103 = i.map14_ntp_id, -- m104_subitem_shedule_id_m103
                       m104_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- m104_modified_by_id_u17
                       m104_modified_date = NVL (i.modified_date, SYSDATE) -- m104_modified_date
                 WHERE m104_id = i.new_cust_notify_sche_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M104_CUST_NOTIFICATION_SCHEDUL',
                                i.m141_id,
                                CASE
                                    WHEN i.new_cust_notify_sche_id
                                             IS NULL
                                    THEN
                                        l_cust_noti_schedule_id
                                    ELSE
                                        i.new_cust_notify_sche_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_notify_sche_id
                                             IS NULL
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
