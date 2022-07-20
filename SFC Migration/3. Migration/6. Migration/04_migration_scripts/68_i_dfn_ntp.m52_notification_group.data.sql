DECLARE
    l_notification_group_id   NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m52_id), 0)
      INTO l_notification_group_id
      FROM dfn_ntp.m52_notification_group;

    DELETE FROM error_log
          WHERE mig_table = 'M52_NOTIFICATION_GROUP';

    FOR i
        IN (SELECT m151.m151_id,
                   m02_map.new_institute_id,
                   m151_description,
                   m151.m151_comments,
                   map01.map01_ntp_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m151.m151_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m151.m151_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m151.m151_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m52_map.new_notification_grp_id
              FROM mubasher_oms.m151_notification_groups@mubasher_db_link m151,
                   u17_employee_mappings u17_created,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_modified,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_status_changed,
                   m52_notification_grp_mappings m52_map
             WHERE     m151.m151_status_id = map01.map01_oms_id
                   AND m151.m151_institute = m02_map.old_institute_id
                   AND m151.m151_created_by = u17_created.old_employee_id(+)
                   AND m151.m151_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m151.m151_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m151.m151_id = m52_map.old_notification_grp_id(+))
    LOOP
        BEGIN
            IF i.new_notification_grp_id IS NULL
            THEN
                l_notification_group_id := l_notification_group_id + 1;

                INSERT
                  INTO dfn_ntp.m52_notification_group (
                           m52_id,
                           m52_institute_id_m02,
                           m52_name,
                           m52_name_lang,
                           m52_description,
                           m52_created_by_id_u17,
                           m52_created_date,
                           m52_status_id_v01,
                           m52_modified_by_id_u17,
                           m52_modified_date,
                           m52_status_changed_by_id_u17,
                           m52_status_changed_date,
                           m52_custom_type)
                VALUES (l_notification_group_id, -- m52_id
                        i.new_institute_id, -- m52_institute_id_m02
                        i.m151_description, -- m52_name
                        i.m151_description, -- m52_name_lang
                        i.m151_comments, -- m52_description,
                        i.created_by_new_id, -- m52_created_by_id_u17
                        i.created_date, -- m52_created_date
                        i.map01_ntp_id, -- m52_status_id_v01
                        i.modifed_by_new_id, -- m52_modified_by_id_u17
                        i.modified_date, -- m52_modified_date
                        i.status_changed_by_new_id, -- m52_status_changed_by_id_u17
                        i.status_changed_date, -- m52_status_changed_date
                        1 --m52_custom_type
                         );

                INSERT INTO m52_notification_grp_mappings
                     VALUES (i.m151_id, l_notification_group_id);
            ELSE
                UPDATE dfn_ntp.m52_notification_group
                   SET m52_institute_id_m02 = i.new_institute_id, -- m52_institute_id_m02
                       m52_name = i.m151_description, -- m52_name
                       m52_name_lang = i.m151_description, -- m52_name_lang
                       m52_description = i.m151_comments, -- m52_description,
                       m52_status_id_v01 = i.map01_ntp_id, -- m52_status_id_v01
                       m52_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m52_modified_by_id_u17
                       m52_modified_date = NVL (i.modified_date, SYSDATE), -- m52_modified_date
                       m52_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m52_status_changed_by_id_u17
                       m52_status_changed_date = i.status_changed_date -- m52_status_changed_date
                 WHERE m52_id = i.new_notification_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M52_NOTIFICATION_GROUP',
                                i.m151_id,
                                CASE
                                    WHEN i.new_notification_grp_id IS NULL
                                    THEN
                                        l_notification_group_id
                                    ELSE
                                        i.new_notification_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_notification_grp_id IS NULL
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
