DECLARE
    l_m114_company_position_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m114_id), 0)
      INTO l_m114_company_position_id
      FROM dfn_ntp.m114_company_positions;

    DELETE FROM error_log
          WHERE mig_table = 'M114_COMPANY_POSITIONS';

    FOR i
        IN (SELECT m156_id,
                   m02_map.new_institute_id,
                   m156_description,
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (m156_created_date, SYSDATE) AS created_date,
                   u17_modified_by.new_employee_id AS modified_by_new_id,
                   m156_modified_date AS modified_date,
                   NVL (u17_status_changed_by.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m156_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   map01.map01_ntp_id,
                   m114_map.new_cmpny_positions_id
              FROM mubasher_oms.m156_company_positions@mubasher_db_link m156,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_modified_by,
                   u17_employee_mappings u17_status_changed_by,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m114_cmpny_positions_mappings m114_map
             WHERE     m156.m156_status_id = map01.map01_oms_id
                   AND m156.m156_created_by =
                           u17_created_by.old_employee_id(+)
                   AND m156.m156_modified_by =
                           u17_modified_by.old_employee_id(+)
                   AND m156.m156_status_changed_by =
                           u17_status_changed_by.old_employee_id(+)
                   AND m156.m156_id = m114_map.old_cmpny_positions_id(+)
                   AND m02_map.old_institute_id =
                           m114_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_cmpny_positions_id IS NULL
            THEN
                l_m114_company_position_id := l_m114_company_position_id + 1;

                INSERT
                  INTO dfn_ntp.m114_company_positions (
                           m114_id,
                           m114_description,
                           m114_description_lang,
                           m114_politically_exposed,
                           m114_created_by_id_u17,
                           m114_created_date,
                           m114_modified_by_id_u17,
                           m114_modified_date,
                           m114_status_id_v01,
                           m114_status_changed_by_id_u17,
                           m114_status_changed_date,
                           m114_custom_type,
                           m114_institute_id_m02,
                           m114_external_ref)
                VALUES (l_m114_company_position_id, -- m114_id
                        i.m156_description, -- m114_description
                        i.m156_description, -- m114_description_lang
                        0, -- m114_politically_exposed | Not Available
                        i.created_by_new_id, -- m114_created_by_id_u17
                        i.created_date, -- m114_created_date
                        i.modified_by_new_id, -- m114_modified_by_id_u17
                        i.modified_date, -- m114_modified_date
                        i.map01_ntp_id, -- m114_status_id_v01
                        i.status_changed_by_new_id, -- m114_status_changed_by_id_u17
                        i.status_changed_date, -- m114_status_changed_date
                        '1', -- m114_custom_type
                        i.new_institute_id, -- m114_institute_id_m02
                        i.m156_id -- m114_external_ref
                                 );
            ELSE
                UPDATE dfn_ntp.m114_company_positions
                   SET m114_description = i.m156_description, -- m114_description
                       m114_description_lang = i.m156_description, -- m114_description_lang
                       m114_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- m114_modified_by_id_u17
                       m114_modified_date = NVL (i.modified_date, SYSDATE), -- m114_modified_date
                       m114_status_id_v01 = i.map01_ntp_id, -- m114_status_id_v01
                       m114_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m114_status_changed_by_id_u17
                       m114_status_changed_date = i.status_changed_date, -- m114_status_changed_date
                       m114_external_ref = i.m156_id -- m114_external_ref
                 WHERE m114_id = i.new_cmpny_positions_id;

                INSERT INTO m114_cmpny_positions_mappings
                     VALUES (
                                i.m156_id,
                                l_m114_company_position_id,
                                i.new_institute_id);
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M114_COMPANY_POSITIONS',
                                i.m156_id,
                                CASE
                                    WHEN i.new_cmpny_positions_id IS NULL
                                    THEN
                                        l_m114_company_position_id
                                    ELSE
                                        i.new_cmpny_positions_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cmpny_positions_id IS NULL
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
