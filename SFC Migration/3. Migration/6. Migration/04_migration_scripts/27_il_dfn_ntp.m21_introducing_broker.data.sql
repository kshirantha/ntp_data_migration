DECLARE
    l_introducing_brk_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m21_id), 0)
      INTO l_introducing_brk_id
      FROM dfn_ntp.m21_introducing_broker;

    DELETE FROM error_log
          WHERE mig_table = 'M21_INTRODUCING_BROKER';

    FOR i
        IN (SELECT m199.m199_id,
                   m199.m199_name,
                   m199.m199_office_telephone_1,
                   m199.m199_office_telephone_2,
                   m199.m199_fax,
                   m199.m199_email,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m199.m199_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m199.m199_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m199.m199_status_changed_date, SYSDATE)
                       status_changed_date,
                   m02_map.new_institute_id,
                   m21_map.new_introducing_brk_id
              FROM mubasher_oms.m199_introducing_broker@mubasher_db_link m199,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m21_introducing_brk_mappings m21_map
             WHERE     m199.m199_status_id = map01.map01_oms_id
                   AND m199.m199_created_by = u17_created.old_employee_id(+)
                   AND m199.m199_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m199.m199_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m199.m199_id = m21_map.old_introducing_brk_id(+)
                   AND m02_map.new_institute_id = m21_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_introducing_brk_id IS NULL
            THEN
                l_introducing_brk_id := l_introducing_brk_id + 1;

                INSERT
                  INTO dfn_ntp.m21_introducing_broker (
                           m21_id,
                           m21_name,
                           m21_name_lang,
                           m21_office_telephone,
                           m21_mobile,
                           m21_fax,
                           m21_email,
                           m21_additional_details,
                           m21_created_by_id_u17,
                           m21_created_date,
                           m21_modified_by_id_u17,
                           m21_modified_date,
                           m21_status_id_v01,
                           m21_status_changed_date,
                           m21_status_changed_by_id_u17,
                           m21_custom_type,
                           m21_institute_id_m02)
                VALUES (l_introducing_brk_id, -- m21_id
                        i.m199_name, -- m21_name
                        i.m199_name, -- m21_name_lang
                        i.m199_office_telephone_1, -- m21_office_telephone
                        i.m199_office_telephone_2, -- m21_mobile
                        i.m199_fax, -- m21_fax
                        i.m199_email, -- m21_email
                        NULL, -- m21_additional_details
                        i.created_by_new_id, -- m21_created_by_id_u17
                        i.created_date, -- m21_created_date
                        i.modifed_by_new_id, -- m21_modified_by_id_u17
                        i.modified_date, -- m21_modified_date
                        i.map01_ntp_id, -- m21_status_id_v01
                        i.status_changed_date, -- m21_status_changed_date
                        i.status_changed_by_new_id, -- m21_status_changed_by_id_u17
                        '1', -- m21_custom_type
                        i.new_institute_id -- m21_institute_id_m02
                                          );

                INSERT INTO m21_introducing_brk_mappings
                     VALUES (
                                i.m199_id,
                                l_introducing_brk_id,
                                i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m21_introducing_broker
                   SET m21_name = i.m199_name, -- m21_name
                       m21_name_lang = i.m199_name, -- m21_name_lang
                       m21_office_telephone = i.m199_office_telephone_1, -- m21_office_telephone
                       m21_mobile = i.m199_office_telephone_2, -- m21_mobile
                       m21_fax = i.m199_fax, -- m21_fax
                       m21_email = i.m199_email, -- m21_email
                       m21_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m21_modified_by_id_u17
                       m21_modified_date = NVL (i.modified_date, SYSDATE), -- m21_modified_date
                       m21_status_id_v01 = i.map01_ntp_id, -- m21_status_id_v01
                       m21_status_changed_date = i.status_changed_date, -- m21_status_changed_date
                       m21_status_changed_by_id_u17 =
                           i.status_changed_by_new_id -- m21_status_changed_by_id_u17
                 WHERE m21_id = i.new_introducing_brk_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M21_INTRODUCING_BROKER',
                                i.m199_id,
                                CASE
                                    WHEN i.new_introducing_brk_id IS NULL
                                    THEN
                                        l_introducing_brk_id
                                    ELSE
                                        i.new_introducing_brk_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_introducing_brk_id IS NULL
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
