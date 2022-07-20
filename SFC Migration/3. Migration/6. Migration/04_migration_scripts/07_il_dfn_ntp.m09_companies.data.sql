DECLARE
    l_company_id   NUMBER;
    l_sqlerrm      VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m09_id), 0) INTO l_company_id FROM dfn_ntp.m09_companies;

    DELETE FROM error_log
          WHERE mig_table = 'M09_COMPANIES';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m157.m157_id,
                   m157.m157_description,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m157.m157_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m157.m157_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m157.m157_status_changed_date, SYSDATE)
                       status_changed_date,
                   m09_map.new_companies_id
              FROM mubasher_oms.m157_companies@mubasher_db_link m157,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m09_companies_mappings m09_map
             WHERE     m157.m157_status_id = map01.map01_oms_id
                   AND m157.m157_created_by = u17_created.old_employee_id(+)
                   AND m157.m157_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m157.m157_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m157.m157_id = m09_map.old_companies_id(+)
                   AND m02_map.new_institute_id = m09_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_companies_id IS NULL
            THEN
                l_company_id := l_company_id + 1;

                INSERT
                  INTO dfn_ntp.m09_companies (m09_id,
                                              m09_description,
                                              m09_created_by_id_u17,
                                              m09_created_date,
                                              m09_modified_by_id_u17,
                                              m09_modified_date,
                                              m09_status_id_v01,
                                              m09_status_changed_by_id_u17,
                                              m09_status_changed_date,
                                              m09_custom_type,
                                              m09_institute_id_m02)
                VALUES (l_company_id, -- m09_id
                        i.m157_description, -- m09_description
                        i.created_by_new_id, -- m09_created_by_id_u17
                        i.created_date, -- m09_created_date
                        i.modifed_by_new_id, -- m09_modified_by_id_u17
                        i.modified_date, -- m09_modified_date
                        i.map01_ntp_id, -- m09_status_id_v01
                        i.status_changed_by_new_id, -- m09_status_changed_by_id_u17
                        i.status_changed_date, -- m09_status_changed_date
                        '1', -- m09_custom_type
                        i.new_institute_id -- m09_institute_id_m02
                                          );

                INSERT INTO m09_companies_mappings
                     VALUES (i.m157_id, l_company_id, i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m09_companies
                   SET m09_description = i.m157_description, -- m09_description
                       m09_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m09_modified_by_id_u17
                       m09_modified_date = NVL (i.modified_date, SYSDATE), -- m09_modified_date
                       m09_status_id_v01 = i.map01_ntp_id, -- m09_status_id_v01
                       m09_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m09_status_changed_by_id_u17
                       m09_status_changed_date = i.status_changed_date -- m09_status_changed_date
                 WHERE m09_id = i.new_companies_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M09_COMPANIES',
                                i.m157_id,
                                CASE
                                    WHEN i.new_companies_id IS NULL
                                    THEN
                                        l_company_id
                                    ELSE
                                        i.new_companies_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_companies_id IS NULL
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
