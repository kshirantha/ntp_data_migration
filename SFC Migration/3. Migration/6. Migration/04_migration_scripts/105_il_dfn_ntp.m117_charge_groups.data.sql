DECLARE
    l_charge_groups_id   NUMBER;
    l_sqlerrm            VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m117_id), 0)
      INTO l_charge_groups_id
      FROM dfn_ntp.m117_charge_groups;

    DELETE FROM error_log
          WHERE mig_table = 'M117_CHARGE_GROUPS';

    FOR i
        IN (SELECT m280.m280_id,
                   m280.m280_name,
                   m280.m280_description,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m280.m280_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by_new_id,
                   m280.m280_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   m280.m280_default,
                   m02_map.new_institute_id,
                   m117_map.new_charge_groups_id
              FROM mubasher_oms.m280_charges_groups@mubasher_db_link m280,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m117_charge_groups_mappings m117_map
             WHERE     m280.m280_status_id = map01.map01_oms_id
                   AND m280.m280_created_by = u17_created.old_employee_id(+)
                   AND m280.m280_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m280.m280_id = m117_map.old_charge_groups_id(+)
                   AND m02_map.old_institute_id =
                           m117_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_charge_groups_id IS NULL
            THEN
                l_charge_groups_id := l_charge_groups_id + 1;

                INSERT
                  INTO dfn_ntp.m117_charge_groups (
                           m117_id,
                           m117_name,
                           m117_description,
                           m117_created_date,
                           m117_created_by_id_u17,
                           m117_status_changed_by_id_u17,
                           m117_status_changed_date,
                           m117_modified_date,
                           m117_modified_by_id_u17,
                           m117_status_id_v01,
                           m117_is_default,
                           m117_custom_type,
                           m117_institute_id_m02)
                VALUES (l_charge_groups_id, -- m117_id,
                        i.m280_name, -- m117_name
                        i.m280_description, -- m117_description
                        i.created_date, -- m117_created_date
                        i.created_by_new_id, -- m117_created_by_id_u17
                        NVL (i.modified_by_new_id, 0), -- m117_status_changed_by_id_u17
                        NVL (i.modified_date, SYSDATE), -- m117_status_changed_date
                        i.modified_date, -- m117_modified_date
                        i.modified_by_new_id, -- m117_modified_by_id_u17
                        i.map01_ntp_id, -- m117_status_id_v01
                        i.m280_default, -- m117_is_default
                        '1', -- m117_custom_type
                        i.new_institute_id -- m117_institute_id_m02
                                          );

                INSERT INTO m117_charge_groups_mappings
                     VALUES (
                                i.m280_id,
                                l_charge_groups_id,
                                i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m117_charge_groups
                   SET m117_name = i.m280_name, -- m117_name
                       m117_description = i.m280_description, -- m117_description
                       m117_status_changed_by_id_u17 =
                           NVL (i.modified_by_new_id, 0), -- m117_status_changed_by_id_u17
                       m117_status_changed_date =
                           NVL (i.modified_date, SYSDATE), -- m117_status_changed_date
                       m117_modified_date = NVL (i.modified_date, SYSDATE), -- m117_modified_date
                       m117_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- m117_modified_by_id_u17
                       m117_status_id_v01 = i.map01_ntp_id, -- m117_status_id_v01
                       m117_is_default = i.m280_default -- m117_is_default
                 WHERE m117_id = i.new_charge_groups_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M117_CHARGE_GROUPS',
                                i.m280_id,
                                CASE
                                    WHEN i.new_charge_groups_id IS NULL
                                    THEN
                                        l_charge_groups_id
                                    ELSE
                                        i.new_charge_groups_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_charge_groups_id IS NULL
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
