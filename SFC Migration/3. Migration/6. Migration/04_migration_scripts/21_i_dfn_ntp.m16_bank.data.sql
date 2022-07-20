DECLARE
    l_bank_id              NUMBER;
    l_default_country_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_default_country_id
      FROM migration_params
     WHERE code = 'DEFAULT_COUNTRY';

    SELECT NVL (MAX (m16_id), 0) INTO l_bank_id FROM dfn_ntp.m16_bank;

    DELETE FROM error_log
          WHERE mig_table = 'M16_BANK';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m36.m36_bank_id,
                   m36.m36_institution_id,
                   m36.m36_bank_name_1,
                   NVL (m36.m36_bank_name_2, m36.m36_bank_name_1)
                       AS m36_bank_name_2,
                   m36.m36_swift_code, -- [Discussed to Make Column Nullable at Broker Level]
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m36.m36_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m36.m36_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m36.m36_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m36.m36_address,
                   m36.m36_aba_routing_no,
                   m36.m36_external_reference,
                   m16_map.new_bank_id
              FROM mubasher_oms.m36_banks@mubasher_db_link m36,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m16_bank_mappings m16_map
             WHERE     m36.m36_status_id = map01.map01_oms_id
                   AND m36.m36_institution_id = m02_map.old_institute_id
                   AND m36.m36_created_by = u17_created.old_employee_id(+)
                   AND m36.m36_modified_by = u17_modified.old_employee_id(+)
                   AND m36.m36_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m36.m36_bank_id = m16_map.old_bank_id(+))
    LOOP
        BEGIN
            IF i.new_bank_id IS NULL
            THEN
                l_bank_id := l_bank_id + 1;

                INSERT INTO dfn_ntp.m16_bank (m16_id,
                                              m16_name,
                                              m16_name_lang,
                                              m16_swift_code,
                                              m16_bank_identifier,
                                              m16_created_by_id_u17,
                                              m16_created_date,
                                              m16_status_id_v01,
                                              m16_modified_by_id_u17,
                                              m16_modified_date,
                                              m16_status_changed_by_id_u17,
                                              m16_status_changed_date,
                                              m16_external_ref,
                                              m16_address,
                                              m16_aba_routing_no,
                                              m16_custom_type,
                                              m16_institute_id_m02,
                                              m16_country_id_m05)
                     VALUES (l_bank_id, -- m16_id
                             i.m36_bank_name_1, -- m16_name
                             i.m36_bank_name_2, -- m16_name_lang
                             i.m36_swift_code, -- m16_swift_code
                             NULL, -- m16_bank_identifier | Not Available
                             i.created_by_new_id, -- m16_created_by_id_u17
                             i.created_date, -- m16_created_date
                             i.map01_ntp_id, -- m16_status_id_v01
                             i.modifed_by_new_id, -- m16_modified_by_id_u17
                             i.modified_date, -- m16_modified_date
                             i.status_changed_by_new_id, -- m16_status_changed_by_id_u17
                             i.status_changed_date, -- m16_status_changed_date
                             i.m36_external_reference, -- m16_external_ref
                             i.m36_address, -- m16_address
                             i.m36_aba_routing_no, -- m16_aba_routing_no
                             '1', -- m16_custom_type
                             i.new_institute_id, -- m16_institute_id_m02
                             l_default_country_id -- m16_country_id_m05
                                                 );

                INSERT INTO m16_bank_mappings
                     VALUES (i.m36_bank_id, l_bank_id);
            ELSE
                UPDATE dfn_ntp.m16_bank
                   SET m16_name = i.m36_bank_name_1, -- m16_name
                       m16_name_lang = i.m36_bank_name_2, -- m16_name_lang
                       m16_swift_code = i.m36_swift_code, -- m16_swift_code
                       m16_status_id_v01 = i.map01_ntp_id, -- m16_status_id_v01
                       m16_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m16_modified_by_id_u17
                       m16_modified_date = NVL (i.modified_date, SYSDATE), -- m16_modified_date
                       m16_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m16_status_changed_by_id_u17
                       m16_status_changed_date = i.status_changed_date, -- m16_status_changed_date
                       m16_external_ref = i.m36_external_reference, -- m16_external_ref
                       m16_address = i.m36_address, -- m16_address
                       m16_aba_routing_no = i.m36_aba_routing_no, -- m16_aba_routing_no
                       m16_institute_id_m02 = i.new_institute_id -- m16_institute_id_m02
                 WHERE m16_id = i.new_bank_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M16_BANK',
                                i.m36_bank_id,
                                CASE
                                    WHEN i.new_bank_id IS NULL THEN l_bank_id
                                    ELSE i.new_bank_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_bank_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
