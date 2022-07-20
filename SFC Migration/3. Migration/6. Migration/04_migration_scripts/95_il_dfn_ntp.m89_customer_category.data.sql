DECLARE
    l_customer_category_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m89_id), 0)
      INTO l_customer_category_id
      FROM dfn_ntp.m89_customer_category;

    DELETE FROM error_log
          WHERE mig_table = 'M89_CUSTOMER_CATEGORY';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m51.m51_id,
                   m51.m51_name,
                   m51.m51_details,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m51.m51_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m51.m51_modified_date AS modified_date,
                   m89_map.new_customer_category_id
              FROM mubasher_oms.m51_commission_type@mubasher_db_link m51,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m89_customer_category_mappings m89_map
             WHERE     m51.m51_created_by = u17_created.old_employee_id(+)
                   AND m51.m51_modified_by = u17_modified.old_employee_id(+)
                   AND m51.m51_id = m89_map.old_customer_category_id(+)
                   AND m02_map.new_institute_id = m89_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_customer_category_id IS NULL
            THEN
                l_customer_category_id := l_customer_category_id + 1;

                INSERT
                  INTO dfn_ntp.m89_customer_category (
                           m89_id,
                           m89_institute_id_m02,
                           m89_name,
                           m89_name_lang,
                           m89_created_by_id_u17,
                           m89_created_date,
                           m89_status_id_v01,
                           m89_modified_by_id_u17,
                           m89_modified_date,
                           m89_status_changed_by_id_u17,
                           m89_status_changed_date,
                           m89_external_ref,
                           m89_additional_details,
                           m89_custom_type)
                VALUES (l_customer_category_id, -- m89_id
                        i.new_institute_id, -- m89_institute_id_m02
                        i.m51_name, -- m89_name
                        i.m51_name, -- m89_name_lang
                        i.created_by_new_id, -- m89_created_by_id_u17
                        i.created_date, -- m89_created_date
                        2, -- m89_status_id_v01 | Not Available
                        i.modifed_by_new_id, -- m89_modified_by_id_u17
                        i.modified_date, -- m89_modified_date
                        0, -- m89_status_changed_by_id_u17 | Not Available
                        SYSDATE, -- m89_status_changed_date | Not Available
                        i.m51_id, -- m89_external_ref
                        i.m51_details, -- m89_additional_details
                        '1' -- m09_custom_type
                           );

                INSERT INTO m89_customer_category_mappings
                     VALUES (
                                i.m51_id,
                                l_customer_category_id,
                                i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m89_customer_category
                   SET m89_name = i.m51_name, -- m89_name
                       m89_name_lang = i.m51_name, -- m89_name_lang
                       m89_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m89_modified_by_id_u17
                       m89_modified_date = NVL (i.modified_date, SYSDATE), -- m89_modified_date
                       m89_external_ref = i.m51_id, -- m89_external_ref
                       m89_additional_details = i.m51_details -- m89_additional_details
                 WHERE m89_id = i.new_customer_category_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M89_CUSTOMER_CATEGORY',
                                i.m51_id,
                                CASE
                                    WHEN i.new_customer_category_id IS NULL
                                    THEN
                                        l_customer_category_id
                                    ELSE
                                        i.new_customer_category_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_customer_category_id IS NULL
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