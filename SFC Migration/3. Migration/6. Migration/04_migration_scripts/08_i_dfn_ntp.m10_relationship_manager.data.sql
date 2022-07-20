DECLARE
    l_rm_id         NUMBER;
    l_location_id   NUMBER;
    l_sqlerrm       VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m10_id), 0)
      INTO l_rm_id
      FROM dfn_ntp.m10_relationship_manager;

    SELECT MIN (new_location_id)
      INTO l_location_id
      FROM m07_location_mappings;

    DELETE FROM error_log
          WHERE mig_table = 'M10_RELATIONSHIP_MANAGER';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m254.m254_id,
                   m254.m254_branch_id,
                   m254.m254_name,
                   m254.m254_name_arabic,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m254.m254_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m254.m254_modified_date AS modified_date,
                   NVL (u17_modified.new_employee_id,
                        NVL (u17_created.new_employee_id, 0))
                       AS status_changed_by_new_id,
                   NVL (m254.m254_modified_date,
                        NVL (m254.m254_created_date, SYSDATE))
                       AS status_changed_date,
                   m254.m254_code,
                   m254.m254_telephone,
                   m254.m254_fax,
                   m10_map.new_rm_id
              FROM mubasher_oms.m254_relationship_managers@mubasher_db_link m254,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m10_rm_mappings m10_map
             WHERE     m254.m254_status = map01.map01_oms_id
                   AND m254.m254_branch_id = m02_map.old_institute_id
                   AND m254.m254_created_by = u17_created.old_employee_id(+)
                   AND m254.m254_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m254.m254_id = m10_map.old_rm_id(+))
    LOOP
        BEGIN
            IF i.new_rm_id IS NULL
            THEN
                l_rm_id := l_rm_id + 1;

                INSERT
                  INTO dfn_ntp.m10_relationship_manager (
                           m10_id,
                           m10_institute_id_m02,
                           m10_name,
                           m10_name_lang,
                           m10_created_by_id_u17,
                           m10_created_date,
                           m10_status_id_v01,
                           m10_modified_by_id_u17,
                           m10_modified_date,
                           m10_status_changed_by_id_u17,
                           m10_status_changed_date,
                           m10_external_ref,
                           m10_code,
                           m10_location_id_m07,
                           m10_telephone,
                           m10_fax,
                           m10_custom_type,
                           m10_incentive_group_id_m162)
                VALUES (l_rm_id, -- m10_id
                        i.new_institute_id, -- m10_institute_id_m02
                        i.m254_name, -- m10_name
                        i.m254_name_arabic, -- m10_name_lang
                        i.created_by_new_id, -- m10_created_by_id_u17
                        i.created_date, -- m10_created_date
                        i.map01_ntp_id, -- m10_status_id_v01
                        i.modifed_by_new_id, -- m10_modified_by_id_u17
                        i.modified_date, -- m10_modified_date
                        i.status_changed_by_new_id, -- m10_status_changed_by_id_u17
                        i.status_changed_date, -- m10_status_changed_date
                        i.m254_id, -- m10_external_ref
                        i.m254_code, -- m10_code
                        l_location_id, -- m10_location_id_m07
                        i.m254_telephone, -- m10_telephone
                        i.m254_fax, -- m10_fax
                        '1', -- m10_custom_type
                        NULL -- m10_incentive_group_id_m162
                            );

                INSERT INTO m10_rm_mappings
                     VALUES (i.m254_id, l_rm_id);
            ELSE
                UPDATE dfn_ntp.m10_relationship_manager
                   SET m10_institute_id_m02 = i.new_institute_id, -- m10_institute_id_m02
                       m10_name = i.m254_name, -- m10_name
                       m10_name_lang = i.m254_name_arabic, -- m10_name_lang
                       m10_status_id_v01 = i.map01_ntp_id, -- m10_status_id_v01
                       m10_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m10_modified_by_id_u17
                       m10_modified_date = NVL (i.modified_date, SYSDATE), -- m10_modified_date
                       m10_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m10_status_changed_by_id_u17
                       m10_status_changed_date = i.status_changed_date, -- m10_status_changed_date
                       m10_external_ref = i.m254_id, -- m10_external_ref
                       m10_code = i.m254_code, -- m10_code
                       m10_telephone = i.m254_telephone, -- m10_telephone
                       m10_fax = i.m254_fax -- m10_fax
                 WHERE m10_id = i.new_rm_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M10_RELATIONSHIP_MANAGER',
                                i.m254_id,
                                CASE
                                    WHEN i.new_rm_id IS NULL THEN l_rm_id
                                    ELSE i.new_rm_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_rm_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
