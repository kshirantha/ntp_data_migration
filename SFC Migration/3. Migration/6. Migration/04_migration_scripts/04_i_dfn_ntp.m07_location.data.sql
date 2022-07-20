DECLARE
    l_default_currency        NUMBER;
    l_default_currency_code   VARCHAR2 (5);
    l_location_id             NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m07_id), 0) INTO l_location_id FROM dfn_ntp.m07_location;

    DELETE FROM error_log
          WHERE mig_table = 'M07_LOCATION';

    SELECT VALUE
      INTO l_default_currency
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY';

    SELECT VALUE
      INTO l_default_currency_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m53.m53_location_id,
                   m53.m53_institute_id,
                   m53.m53_location,
                   m53.m53_arabic_name,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m53.m53_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m53.m53_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m53.m53_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m53.m53_region_id,
                   m53.m53_branch_code,
                   m07_map.new_location_id
              FROM mubasher_oms.m53_locations@mubasher_db_link m53,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m07_location_mappings m07_map
             WHERE     m53.m53_status_id = map01.map01_oms_id
                   AND m02_map.old_institute_id = m53.m53_institute_id
                   AND m53.m53_created_by = u17_created.old_employee_id(+)
                   AND m53.m53_modified_by = u17_modified.old_employee_id(+)
                   AND m53.m53_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m53.m53_location_id = m07_map.old_location_id(+))
    LOOP
        BEGIN
            IF i.new_location_id IS NULL
            THEN
                l_location_id := l_location_id + 1;

                INSERT
                  INTO dfn_ntp.m07_location (m07_id,
                                             m07_institute_id_m02,
                                             m07_name,
                                             m07_name_lang,
                                             m07_created_by_id_u17,
                                             m07_created_date,
                                             m07_status_id_v01,
                                             m07_modified_by_id_u17,
                                             m07_modified_date,
                                             m07_status_changed_by_id_u17,
                                             m07_status_changed_date,
                                             m07_external_ref,
                                             m07_region_id_m90, -- [SAME IDs]
                                             m07_location_code,
                                             m07_custom_type,
                                             m07_order_value_per_day,
                                             m07_order_volume_per_day,
                                             m07_default_currency_code_m03,
                                             m07_default_currency_id_m03)
                VALUES (l_location_id, -- m07_id
                        i.new_institute_id, -- m07_institute_id_m02
                        i.m53_location, -- m07_name
                        i.m53_arabic_name, -- m07_name_lang
                        i.created_by_new_id, -- m07_created_by_id_u17
                        i.created_date, -- m07_created_date
                        i.map01_ntp_id, -- m07_status_id_v01
                        i.modifed_by_new_id, -- m07_modified_by_id_u17
                        i.modified_date, -- m07_modified_date
                        i.status_changed_by_new_id, -- m07_status_changed_by_id_u17
                        i.status_changed_date, -- m07_status_changed_date
                        i.m53_location_id, -- m07_external_ref
                        i.m53_region_id, -- m07_region_id_m90
                        i.m53_branch_code, -- m07_location_code
                        '1', -- m07_custom_type
                        0, --m07_order_value_per_day | Not Available
                        0, --m07_order_volume_per_day | Not Available
                        l_default_currency_code, --m07_default_currency_code_m03
                        l_default_currency --m07_default_currency_id_m03
                                          );

                INSERT INTO m07_location_mappings
                     VALUES (i.m53_location_id, l_location_id);
            ELSE
                UPDATE dfn_ntp.m07_location
                   SET m07_institute_id_m02 = i.new_institute_id, -- m07_institute_id_m02
                       m07_name = i.m53_location, -- m07_name
                       m07_name_lang = i.m53_arabic_name, -- m07_name_lang
                       m07_status_id_v01 = i.map01_ntp_id, -- m07_status_id_v01
                       m07_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m07_modified_by_id_u17
                       m07_modified_date = NVL (i.modified_date, SYSDATE), -- m07_modified_date
                       m07_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m07_status_changed_by_id_u17
                       m07_status_changed_date = i.status_changed_date, -- m07_status_changed_date
                       m07_external_ref = i.m53_location_id, -- m07_external_ref
                       m07_region_id_m90 = i.m53_region_id, -- m07_region_id_m90
                       m07_location_code = i.m53_branch_code -- m07_location_code
                 WHERE m07_id = i.new_location_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M07_LOCATION',
                                i.m53_location_id,
                                CASE
                                    WHEN i.new_location_id IS NULL
                                    THEN
                                        l_location_id
                                    ELSE
                                        i.new_location_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_location_id IS NULL
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

-- Updating Default Location

BEGIN
    FOR i
        IN (SELECT m07_institute_id_m02, m07_id
              FROM dfn_ntp.m07_location
             WHERE     UPPER (m07_name) = 'HEAD OFFICE'
                   AND m07_institute_id_m02 > 0
            UNION
              SELECT m07_institute_id_m02, MAX (m07_id) AS m07_id
                FROM dfn_ntp.m07_location
               WHERE     UPPER (m07_name) <> 'HEAD OFFICE'
                     AND m07_institute_id_m02 > 0
                     AND m07_institute_id_m02 NOT IN
                             (SELECT m07_institute_id_m02
                                FROM dfn_ntp.m07_location
                               WHERE     UPPER (m07_name) = 'HEAD OFFICE'
                                     AND m07_institute_id_m02 > 0)
            GROUP BY m07_institute_id_m02)
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.m07_id
         WHERE     v20.v20_institute_id_m02 = i.m07_institute_id_m02
               AND v20.v20_tag = 'location';
    END LOOP;
END;
/

COMMIT;