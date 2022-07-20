DECLARE
    l_institute_bank_id   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m60_id), 0)
      INTO l_institute_bank_id
      FROM dfn_ntp.m60_institute_banks;

    DELETE FROM error_log
          WHERE mig_table = 'M60_INSTITUTE_BANKS';

    FOR i
        IN (SELECT m173.m173_id,
                   m02_map.new_institute_id,
                   m16_map.new_bank_id,
                   NVL (u17_created_map.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (m173.m173_created_date, SYSDATE) AS created_date,
                   u17_modified_map.new_employee_id AS modified_by_new_id,
                   m173.m173_modified_date AS modified_date,
                   NVL (m173.m173_is_default, 0) AS m173_is_default,
                   m60_map.new_institute_banks_id
              FROM mubasher_oms.m173_branch_banks@mubasher_db_link m173,
                   m02_institute_mappings m02_map,
                   m16_bank_mappings m16_map,
                   u17_employee_mappings u17_created_map,
                   u17_employee_mappings u17_modified_map,
                   m60_institute_banks_mappings m60_map
             WHERE     m173.m173_branch_id = m02_map.old_institute_id
                   AND m173.m173_created_by =
                           u17_created_map.old_employee_id(+)
                   AND m173.m173_modified_by =
                           u17_modified_map.old_employee_id(+)
                   AND m173.m173_bank_id = m16_map.old_bank_id(+)
                   AND m173.m173_id = m60_map.old_institute_banks_id(+))
    LOOP
        BEGIN
            IF i.new_institute_banks_id IS NULL
            THEN
                l_institute_bank_id := l_institute_bank_id + 1;

                INSERT
                  INTO dfn_ntp.m60_institute_banks (m60_id,
                                                    m60_institute_id_m02,
                                                    m60_bank_id_m16,
                                                    m60_created_by_id_u17,
                                                    m60_created_date,
                                                    m60_modified_by_id_u17,
                                                    m60_modified_date,
                                                    m60_is_default,
                                                    m60_custom_type)
                VALUES (l_institute_bank_id, -- m60_id
                        i.new_institute_id, -- m60_institute_id_m02
                        i.new_bank_id, -- m60_bank_id_m16
                        i.created_by_new_id, -- m60_created_by_id_u17
                        i.created_date, -- m60_created_date
                        i.modified_by_new_id, -- m60_modified_by_id_u17
                        i.modified_date, -- m60_modified_date
                        NVL (i.m173_is_default, 0), -- m60_is_default
                        '1'); -- m60_custom_type

                INSERT INTO m60_institute_banks_mappings
                     VALUES (i.m173_id, l_institute_bank_id);
            ELSE
                UPDATE dfn_ntp.m60_institute_banks
                   SET m60_institute_id_m02 = i.new_institute_id, -- m60_institute_id_m02
                       m60_bank_id_m16 = i.new_bank_id, -- m60_bank_id_m16
                       m60_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- m60_modified_by_id_u17
                       m60_modified_date = NVL (i.modified_date, SYSDATE), -- m60_modified_date
                       m60_is_default = NVL (i.m173_is_default, 0) -- m60_is_default
                 WHERE m60_id = i.new_institute_banks_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M60_INSTITUTE_BANKS',
                                i.m173_id,
                                CASE
                                    WHEN i.new_institute_banks_id IS NULL
                                    THEN
                                        l_institute_bank_id
                                    ELSE
                                        i.new_institute_banks_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_institute_banks_id IS NULL
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