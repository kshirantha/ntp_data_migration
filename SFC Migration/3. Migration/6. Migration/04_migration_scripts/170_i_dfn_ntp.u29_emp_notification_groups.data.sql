DECLARE
    l_employee_notification_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u29_id), 0)
      INTO l_employee_notification_id
      FROM dfn_ntp.u29_emp_notification_groups;

    DELETE FROM error_log
          WHERE mig_table = 'U29_EMP_NOTIFICATION_GROUPS';

    FOR i
        IN (SELECT m152.m152_id,
                   u17_map.new_employee_id,
                   m52_map.new_notification_grp_id,
                   NVL (u17_granted_by.new_employee_id, 0)
                       AS new_granted_by_id,
                   NVL (m152.m152_granted_date, SYSDATE) AS new_granted_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed_by.new_employee_id, 0)
                       status_changed_new_id,
                   NVL (m152.m152_status_changed_date, SYSDATE)
                       AS status_changed_new_date,
                   u29_map.new_emp_notifi_groups_id
              FROM mubasher_oms.m152_emp_notification_groups@mubasher_db_link m152,
                   map01_approval_status_v01 map01,
                   m52_notification_grp_mappings m52_map,
                   u17_employee_mappings u17_map,
                   u17_employee_mappings u17_granted_by,
                   u17_employee_mappings u17_status_changed_by,
                   u29_emp_notifi_groups_mappings u29_map
             WHERE     m152.m152_status_id = map01.map01_oms_id
                   AND m152.m152_notification_group =
                           m52_map.old_notification_grp_id
                   AND m152.m152_employee = u17_map.old_employee_id
                   AND m152.m152_granted_by =
                           u17_granted_by.old_employee_id(+)
                   AND m152.m152_status_changed_by =
                           u17_status_changed_by.old_employee_id(+)
                   AND m152.m152_id = u29_map.old_emp_notifi_groups_id(+))
    LOOP
        BEGIN
            IF i.new_emp_notifi_groups_id IS NULL
            THEN
                l_employee_notification_id := l_employee_notification_id + 1;

                INSERT
                  INTO dfn_ntp.u29_emp_notification_groups (
                           u29_id,
                           u29_employee_id_u17,
                           u29_notification_group_id_m52,
                           u29_assigned_by_id_u17,
                           u29_assigned_date,
                           u29_status_id_v01,
                           u29_status_changed_by_id_u17,
                           u29_status_changed_date,
                           u29_custom_type)
                VALUES (l_employee_notification_id, -- u29_id
                        i.new_employee_id, -- u29_employee_id_u17
                        i.new_notification_grp_id, -- u29_notification_group_id_m52
                        i.new_granted_by_id, -- u29_assigned_by_id_u17
                        i.new_granted_date, -- u29_assigned_date
                        i.map01_ntp_id, -- u29_status_id_v01
                        i.status_changed_new_id, -- u29_status_changed_by_id_u17
                        i.status_changed_new_date, -- u29_status_changed_date
                        '1' -- u29_custom_type
                           );

                INSERT INTO u29_emp_notifi_groups_mappings
                     VALUES (i.m152_id, l_employee_notification_id);
            ELSE
                UPDATE dfn_ntp.u29_emp_notification_groups
                   SET u29_employee_id_u17 = i.new_employee_id, -- u29_employee_id_u17
                       u29_notification_group_id_m52 =
                           i.new_notification_grp_id, -- u29_notification_group_id_m52
                       u29_assigned_by_id_u17 = i.new_granted_by_id, -- u29_assigned_by_id_u17
                       u29_assigned_date = i.new_granted_date, -- u29_assigned_date
                       u29_status_id_v01 = i.map01_ntp_id, -- u29_status_id_v01
                       u29_status_changed_by_id_u17 = i.status_changed_new_id, -- u29_status_changed_by_id_u17
                       u29_status_changed_date = i.status_changed_new_date -- u29_status_changed_date
                 WHERE u29_id = i.new_emp_notifi_groups_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U29_EMP_NOTIFICATION_GROUPS',
                                i.m152_id,
                                CASE
                                    WHEN i.new_emp_notifi_groups_id IS NULL
                                    THEN
                                        l_employee_notification_id
                                    ELSE
                                        i.new_emp_notifi_groups_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_emp_notifi_groups_id IS NULL
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
