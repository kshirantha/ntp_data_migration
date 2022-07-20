DECLARE
    l_permission_grp_usrs_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m47_id), 0)
      INTO l_permission_grp_usrs_id
      FROM dfn_ntp.m47_permission_grp_users;

    DELETE FROM error_log
          WHERE mig_table = 'M47_PERMISSION_GRP_USERS';

    FOR i
        IN (SELECT m19.m19_id,
                   NVL (u17_user.new_employee_id, 0) AS new_user_id,
                   m45_map.new_permission_groups_id,
                   NVL (u17_granted.new_employee_id, 0) AS new_granted_by_id,
                   NVL (m19.m19_granted_date, SYSDATE) AS granted_date,
                   NVL (u17_l1.new_employee_id, 0) AS new_l1_by_id,
                   NVL (m19.m19_l1_date, SYSDATE) AS l1_date,
                   NVL (u17_l2.new_employee_id, 0) AS new_l2_by_id,
                   NVL (m19.m19_l2_date, SYSDATE) AS l2_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS new_status_changed_by_id,
                   NVL (m19.m19_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m47_map.new_permisn_grp_users_id
              FROM mubasher_oms.m19_system_users_groups@mubasher_db_link m19,
                   map01_approval_status_v01 map01,
                   m45_permission_groups_mappings m45_map,
                   u17_employee_mappings u17_user,
                   u17_employee_mappings u17_granted,
                   u17_employee_mappings u17_l1,
                   u17_employee_mappings u17_l2,
                   u17_employee_mappings u17_status_changed,
                   m47_permisn_grp_users_mappings m47_map
             WHERE     m19.m19_status_id = map01.map01_oms_id
                   AND m19.m19_group_id = m45_map.old_permission_groups_id
                   AND m19.m19_user_id = u17_user.old_employee_id
                   AND m19.m19_granted_by = u17_granted.old_employee_id(+)
                   AND m19.m19_l1_by = u17_l1.old_employee_id(+)
                   AND m19.m19_l2_by = u17_l2.old_employee_id(+)
                   AND m19.m19_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m19.m19_id = m47_map.old_permisn_grp_users_id(+))
    LOOP
        BEGIN
            IF i.new_permisn_grp_users_id IS NULL
            THEN
                l_permission_grp_usrs_id := l_permission_grp_usrs_id + 1;

                INSERT
                  INTO dfn_ntp.m47_permission_grp_users (
                           m47_id,
                           m47_user_id_u17,
                           m47_group_id_m45,
                           m47_granted_by_id_u17,
                           m47_granted_date,
                           m47_l1_by_id_u17,
                           m47_l1_date,
                           m47_l2_by_id_u17,
                           m47_l2_date,
                           m47_status_id_v01,
                           m47_status_changed_by_id_u17,
                           m47_status_changed_date,
                           m47_custom_type)
                VALUES (l_permission_grp_usrs_id, -- m47_id
                        i.new_user_id, -- m47_user_id_u17
                        i.new_permission_groups_id, -- m47_group_id_m45
                        i.new_granted_by_id, --m47_granted_by_id_u17
                        i.granted_date, -- m47_granted_date
                        i.new_l1_by_id, -- m47_l1_by_id_u17
                        i.l1_date, --m47_l1_date
                        i.new_l2_by_id, -- m47_l2_by_id_u17
                        i.l2_date, -- m47_l2_date
                        i.map01_ntp_id, -- m47_status_id_v01
                        i.new_status_changed_by_id, -- m47_status_changed_by_id_u17
                        i.status_changed_date, -- m47_status_changed_date
                        '1' -- m47_custom_type
                           );

                INSERT INTO m47_permisn_grp_users_mappings
                     VALUES (i.m19_id, l_permission_grp_usrs_id);
            ELSE
                UPDATE dfn_ntp.m47_permission_grp_users
                   SET m47_user_id_u17 = i.new_user_id, -- m47_user_id_u17
                       m47_group_id_m45 = i.new_permission_groups_id, -- m47_group_id_m45
                       m47_granted_by_id_u17 = i.new_granted_by_id, --m47_granted_by_id_u17
                       m47_granted_date = i.granted_date, -- m47_granted_date
                       m47_l1_by_id_u17 = i.new_l1_by_id, -- m47_l1_by_id_u17
                       m47_l1_date = i.l1_date, --m47_l1_date
                       m47_l2_by_id_u17 = i.new_l2_by_id, -- m47_l2_by_id_u17
                       m47_l2_date = i.l2_date, -- m47_l2_date
                       m47_status_id_v01 = i.map01_ntp_id, -- m47_status_id_v01
                       m47_status_changed_by_id_u17 =
                           i.new_status_changed_by_id, -- m47_status_changed_by_id_u17
                       m47_status_changed_date = i.status_changed_date -- m47_status_changed_date
                 WHERE m47_id = i.new_permisn_grp_users_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M47_PERMISSION_GRP_USERS',
                                i.m19_id,
                                CASE
                                    WHEN i.new_permisn_grp_users_id
                                             IS NULL
                                    THEN
                                        l_permission_grp_usrs_id
                                    ELSE
                                        i.new_permisn_grp_users_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_permisn_grp_users_id
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
