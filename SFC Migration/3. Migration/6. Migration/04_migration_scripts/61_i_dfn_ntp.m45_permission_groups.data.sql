DECLARE
    l_permission_group_id   NUMBER;
    l_sqlerrm               VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m45_id), 0)
      INTO l_permission_group_id
      FROM dfn_ntp.m45_permission_groups;

    DELETE FROM error_log
          WHERE mig_table = 'M45_PERMISSION_GROUPS';

    FOR i
        IN (SELECT m09.m09_id,
                   m09.m09_group_name,
                   m09.m09_group_enabled,
                   NVL (m09.m09_created_date, SYSDATE) AS created_date,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   m02_map.new_institute_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m09.m09_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m09.m09_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m09.m09_editable,
                   m09.m09_is_root_inst_only,
                   m45_map.new_permission_groups_id
              FROM mubasher_oms.m09_system_groups@mubasher_db_link m09,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m45_permission_groups_mappings m45_map
             WHERE     m09.m09_id > 0 -- Filtering Out Root Institution Administrator Group
                   AND m09.m09_status_id = map01.map01_oms_id
                   AND m09.m09_inst_id = m02_map.old_institute_id
                   AND m09.m09_created_by = u17_created.old_employee_id(+)
                   AND m09.m09_modified_by = u17_modified.old_employee_id(+)
                   AND m09.m09_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m09.m09_id = m45_map.old_permission_groups_id(+))
    LOOP
        BEGIN
            IF i.new_permission_groups_id IS NULL
            THEN
                l_permission_group_id := l_permission_group_id + 1;

                INSERT
                  INTO dfn_ntp.m45_permission_groups (
                           m45_id,
                           m45_group_name,
                           m45_group_enabled,
                           m45_created_date,
                           m45_created_by_id_u17,
                           m45_institute_id_m02,
                           m45_modified_by_id_u17,
                           m45_modified_date,
                           m45_status_id_v01,
                           m45_status_changed_by_id_u17,
                           m45_status_changed_date,
                           m45_editable,
                           m45_is_root_inst_only,
                           m45_custom_type)
                VALUES (l_permission_group_id, -- m45_id,
                        i.m09_group_name, -- m45_group_name
                        i.m09_group_enabled, -- m45_group_enabled
                        i.created_date, -- m45_created_date
                        i.created_by_new_id, -- m45_created_by_id_u17
                        i.new_institute_id, -- m45_institute_id_m02
                        i.modifed_by_new_id, -- m45_modified_by_id_u17
                        i.modified_date, -- m45_modified_date
                        i.map01_ntp_id, -- m45_status_id_v01
                        i.status_changed_by_new_id, -- m45_status_changed_by_id_u17
                        i.status_changed_date, -- m45_status_changed_date
                        i.m09_editable, -- m45_editable
                        i.m09_is_root_inst_only, -- m45_is_root_inst_only
                        '1' -- m45_custom_type
                           );

                INSERT INTO m45_permission_groups_mappings
                     VALUES (i.m09_id, l_permission_group_id);
            ELSE
                UPDATE dfn_ntp.m45_permission_groups
                   SET m45_group_name = i.m09_group_name, -- m45_group_name
                       m45_group_enabled = i.m09_group_enabled, -- m45_group_enabled
                       m45_institute_id_m02 = i.new_institute_id, -- m45_institute_id_m02
                       m45_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m45_modified_by_id_u17
                       m45_modified_date = NVL (i.modified_date, SYSDATE), -- m45_modified_date
                       m45_status_id_v01 = i.map01_ntp_id, -- m45_status_id_v01
                       m45_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m45_status_changed_by_id_u17
                       m45_status_changed_date = i.status_changed_date, -- m45_status_changed_date
                       m45_editable = i.m09_editable, -- m45_editable
                       m45_is_root_inst_only = i.m09_is_root_inst_only -- m45_is_root_inst_only
                 WHERE m45_id = i.new_permission_groups_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M45_PERMISSION_GROUPS',
                                i.m09_id,
                                CASE
                                    WHEN i.new_permission_groups_id IS NULL
                                    THEN
                                        l_permission_group_id
                                    ELSE
                                        i.new_permission_groups_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_permission_groups_id IS NULL
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
