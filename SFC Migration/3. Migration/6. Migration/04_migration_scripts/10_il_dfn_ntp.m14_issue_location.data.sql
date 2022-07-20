DECLARE
    l_issue_location_id   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m14_id), 0)
      INTO l_issue_location_id
      FROM dfn_ntp.m14_issue_location;

    DELETE FROM error_log
          WHERE mig_table = 'M14_ISSUE_LOCATION';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m146.m146_id,
                   m06_map.map06_ntp_id,
                   m146.m146_description,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m146.m146_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m146.m146_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m146.m146_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m14_map.new_issue_location_id
              FROM mubasher_oms.m146_issue_location@mubasher_db_link m146,
                   map01_approval_status_v01 map01,
                   map06_country_m05 m06_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m14_issue_location_mappings m14_map
             WHERE     m146.m146_status_id = map01.map01_oms_id
                   AND m146.m146_country_id = m06_map.map06_oms_id
                   AND m146.m146_created_by = u17_created.old_employee_id(+)
                   AND m146.m146_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m146.m146_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m146.m146_id = m14_map.old_issue_location_id(+)
                   AND m02_map.new_institute_id = m14_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_issue_location_id IS NULL
            THEN
                l_issue_location_id := l_issue_location_id + 1;

                INSERT
                  INTO dfn_ntp.m14_issue_location (
                           m14_id,
                           m14_country_id_m05,
                           m14_name,
                           m14_name_lang,
                           m14_created_by_id_u17,
                           m14_created_date,
                           m14_status_id_v01,
                           m14_modified_by_id_u17,
                           m14_modified_date,
                           m14_status_changed_by_id_u17,
                           m14_status_changed_date,
                           m14_external_ref,
                           m14_custom_type,
                           m14_institute_id_m02)
                VALUES (l_issue_location_id, -- m14_id
                        i.map06_ntp_id, -- m14_country_id_m05
                        i.m146_description, -- m14_name
                        i.m146_description, -- m14_name_lang
                        i.created_by_new_id, -- m14_created_by_id_u17
                        i.created_date, -- m14_created_date
                        i.map01_ntp_id, -- m14_status_id_v01
                        i.modifed_by_new_id, -- m14_modified_by_id_u17
                        i.modified_date, -- m14_modified_date
                        i.status_changed_by_new_id, -- m14_status_changed_by_id_u17
                        i.status_changed_date, -- m14_status_changed_date
                        i.m146_id, -- m14_external_ref
                        '1', -- m14_custom_type
                        i.new_institute_id -- m14_institute_id_m02
                                          );

                INSERT INTO m14_issue_location_mappings
                     VALUES (
                                i.m146_id,
                                l_issue_location_id,
                                i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m14_issue_location
                   SET m14_country_id_m05 = i.map06_ntp_id, -- m14_country_id_m05
                       m14_name = i.m146_description, -- m14_name
                       m14_name_lang = i.m146_description, -- m14_name_lang
                       m14_status_id_v01 = i.map01_ntp_id, -- m14_status_id_v01
                       m14_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m14_modified_by_id_u17
                       m14_modified_date = NVL (i.modified_date, SYSDATE), -- m14_modified_date
                       m14_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m14_status_changed_by_id_u17
                       m14_status_changed_date = i.status_changed_date, -- m14_status_changed_date
                       m14_external_ref = i.m146_id -- m14_external_ref
                 WHERE m14_id = i.new_issue_location_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M14_ISSUE_LOCATION',
                                i.m146_id,
                                CASE
                                    WHEN i.new_issue_location_id IS NULL
                                    THEN
                                        l_issue_location_id
                                    ELSE
                                        i.new_issue_location_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_issue_location_id IS NULL
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

COMMIT;

-- Updating Default Issue Location

BEGIN
    FOR i
        IN (SELECT m14_institute_id_m02, m14_id
              FROM dfn_ntp.m14_issue_location
             WHERE UPPER (m14_name) = 'RIYADH' AND m14_country_id_m05 = 2
            UNION
              SELECT m14_institute_id_m02, MAX (m14_id) AS m14_id
                FROM dfn_ntp.m14_issue_location
               WHERE     UPPER (m14_name) <> 'RIYADH'
                     AND m14_country_id_m05 = 2
                     AND m14_institute_id_m02 NOT IN
                             (SELECT m14_institute_id_m02
                                FROM dfn_ntp.m14_issue_location
                               WHERE     UPPER (m14_name) = 'RIYADH'
                                     AND m14_country_id_m05 = 2)
            GROUP BY m14_institute_id_m02)
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.m14_id
         WHERE     v20.v20_institute_id_m02 = i.m14_institute_id_m02
               AND v20.v20_tag = 'issueLocation';
    END LOOP;
END;
/

COMMIT;