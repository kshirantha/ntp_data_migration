DECLARE
    l_permission_grp_entl_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m46_id), 0)
      INTO l_permission_grp_entl_id
      FROM dfn_ntp.m46_permission_grp_entlements;

    DELETE FROM error_log
          WHERE mig_table = 'M46_PERMISSION_GRP_ENTLEMENTS';

    FOR i
        IN (SELECT m46_old.*, m46_map.new_permisn_grp_entl_id
              FROM (  SELECT    TO_CHAR (MAX (m18.m18_id))
                             || '~'
                             || TO_CHAR (m45_map.new_permission_groups_id)
                             || '~'
                             || TO_CHAR (map04_ntp_id)
                                 AS m18_id, -- [Corrective Actions Discussed]
                             m45_map.new_permission_groups_id,
                             map04.map04_ntp_id,
                             MAX (NVL (u17_created.new_employee_id, 0))
                                 AS created_by_new_id,
                             MAX (NVL (m18.m18_added_date, SYSDATE))
                                 AS created_date,
                             MAX (NVL (u17_l1.new_employee_id, 0))
                                 AS l1_by_new_id,
                             MAX (NVL (m18.m18_l1_date, SYSDATE)) AS l1_date,
                             MAX (NVL (u17_l2.new_employee_id, 0))
                                 AS l2_by_new_id,
                             MAX (NVL (m18.m18_l2_date, SYSDATE)) AS l2_date,
                             MAX (map01.map01_ntp_id) AS map01_ntp_id,
                             MAX (NVL (u17_status_changed.new_employee_id, 0))
                                 AS status_changed_by_new_id,
                             MAX (NVL (m18.m18_status_changed_date, SYSDATE))
                                 AS status_changed_date
                        FROM mubasher_oms.m18_system_groups_tasks@mubasher_db_link m18,
                             map04_entitlements_v04 map04,
                             map01_approval_status_v01 map01,
                             u17_employee_mappings u17_created,
                             m45_permission_groups_mappings m45_map,
                             dfn_ntp.m45_permission_groups m45,
                             u17_employee_mappings u17_status_changed,
                             u17_employee_mappings u17_l1,
                             u17_employee_mappings u17_l2,
                             m02_institute_mappings m02_map
                       WHERE     m18.m18_task_id = map04.map04_oms_id(+)
                             AND m18.m18_status_id = map01.map01_oms_id
                             AND m18.m18_group_id =
                                     m45_map.old_permission_groups_id(+)
                             AND m45_map.new_permission_groups_id =
                                     m45.m45_id(+)
                             AND m45.m45_institute_id_m02 =
                                     m02_map.new_institute_id
                             AND m18.m18_added_by =
                                     u17_created.old_employee_id(+)
                             AND m18.m18_l1_by = u17_l1.old_employee_id(+)
                             AND m18.m18_l2_by = u17_l2.old_employee_id(+)
                             AND m18.m18_status_changed_by =
                                     u17_status_changed.old_employee_id(+)
                    GROUP BY new_permission_groups_id, map04.map04_ntp_id -- Same OLD ID to Many NTP IDs & Many OLD IDs to Same NTP IDs Possible
                                                                         ) m46_old,
                   m46_permisn_grp_entl_mappings m46_map
             WHERE     m46_old.m18_id = m46_map.old_permisn_grp_entl_id(+)
                   AND m46_old.map04_ntp_id = m46_map.new_entitlement_id(+))
    LOOP
        BEGIN
            IF i.new_permission_groups_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Permission Group Not Available',
                                         TRUE);
            END IF;

            IF i.map04_ntp_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Entitlement Not Available',
                                         TRUE);
            END IF;

            IF i.new_permisn_grp_entl_id IS NULL
            THEN
                l_permission_grp_entl_id := l_permission_grp_entl_id + 1;

                INSERT
                  INTO dfn_ntp.m46_permission_grp_entlements (
                           m46_id,
                           m46_group_id_m45,
                           m46_task_id_v04,
                           m46_added_by_id_u17,
                           m46_added_date,
                           m46_l1_by_id_u17,
                           m46_l1_date,
                           m46_l2_by_id_u17,
                           m46_l2_date,
                           m46_status_id_v01,
                           m46_status_changed_by_id_u17,
                           m46_status_changed_date,
                           m46_custom_type)
                VALUES (l_permission_grp_entl_id, -- m46_id
                        i.new_permission_groups_id, -- m46_group_id_m45
                        i.map04_ntp_id, -- m46_task_id_v04
                        i.created_by_new_id, -- m46_added_by_id_u17
                        i.created_date, -- m46_added_date
                        i.l1_by_new_id, -- m46_l1_by_id_u17
                        i.l1_date, -- m46_l1_date
                        i.l2_by_new_id, -- m46_l2_by_id_u17
                        i.l2_date, -- m46_l2_date
                        i.map01_ntp_id, -- m46_status_id_v01
                        i.status_changed_by_new_id, -- m46_status_changed_by_id_u17
                        i.status_changed_date, -- m46_status_changed_date
                        '1' -- m45_custom_type
                           );

                INSERT INTO m46_permisn_grp_entl_mappings
                     VALUES (
                                i.m18_id,
                                l_permission_grp_entl_id,
                                i.map04_ntp_id);
            ELSE
                UPDATE dfn_ntp.m46_permission_grp_entlements
                   SET m46_group_id_m45 = i.new_permission_groups_id, -- m46_group_id_m45
                       m46_task_id_v04 = i.map04_ntp_id, -- m46_task_id_v04
                       m46_l1_by_id_u17 = i.l1_by_new_id, -- m46_l1_by_id_u17
                       m46_l1_date = i.l1_date, -- m46_l1_date
                       m46_l2_by_id_u17 = i.l2_by_new_id, -- m46_l2_by_id_u17
                       m46_l2_date = i.l2_date, -- m46_l2_date
                       m46_status_id_v01 = i.map01_ntp_id, -- m46_status_id_v01
                       m46_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m46_status_changed_by_id_u17
                       m46_status_changed_date = i.status_changed_date -- m46_status_changed_date
                 WHERE m46_id = i.new_permisn_grp_entl_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M46_PERMISSION_GRP_ENTLEMENTS',
                                i.m18_id,
                                CASE
                                    WHEN i.new_permisn_grp_entl_id IS NULL
                                    THEN
                                        l_permission_grp_entl_id
                                    ELSE
                                        i.new_permisn_grp_entl_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_permisn_grp_entl_id IS NULL
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