DECLARE
    l_cust_grd_id   NUMBER;
    l_sqlerrm       VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m28_id), 0)
      INTO l_cust_grd_id
      FROM dfn_ntp.m28_customer_grade_data;

    DELETE FROM error_log
          WHERE mig_table = 'M28_CUSTOMER_GRADE_DATA';

    FOR i
        IN (SELECT m127_id,
                   m127_from_value,
                   m127_to_value,
                   m127_grade_label,
                   m02_map.new_institute_id,
                   2 AS status_id,
                   m28_map.new_cust_grade_data_id
              FROM mubasher_oms.m127_customer_grade_data@mubasher_db_link m127,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m28_cust_grade_data_mappings m28_map
             WHERE     m127.m127_id = m28_map.old_cust_grade_data_id(+)
                   AND m02_map.new_institute_id = m28_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_cust_grade_data_id IS NULL
            THEN
                l_cust_grd_id := l_cust_grd_id + 1;

                INSERT
                  INTO dfn_ntp.m28_customer_grade_data (
                           m28_id,
                           m28_from_value,
                           m28_to_value,
                           m28_grade_label,
                           m28_institution_id_m02,
                           m28_version,
                           m28_created_by_id_u17,
                           m28_created_date,
                           m28_modified_by_id_u17,
                           m28_modified_date,
                           m28_status_id_v01,
                           m28_status_changed_by_id_u17,
                           m28_status_changed_date,
                           m28_custom_type)
                VALUES (l_cust_grd_id, -- m07_id
                        i.m127_from_value, -- m28_from_value
                        i.m127_to_value, -- m28_to_value
                        i.m127_grade_label, -- m28_grade_label
                        i.new_institute_id, -- m28_institution_id_m02
                        NULL, -- m28_version
                        0, -- m28_created_by_id_u17
                        SYSDATE, -- m28_created_date
                        NULL, -- m28_modified_by_id_u17
                        NULL, -- m28_modified_date
                        i.status_id, -- m28_status_id_v01
                        0, -- m28_status_changed_by_id_u17
                        SYSDATE, -- m28_status_changed_date
                        '1' -- m28_custom_type
                           );

                INSERT INTO m28_cust_grade_data_mappings
                     VALUES (i.m127_id, l_cust_grd_id, i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m28_customer_grade_data
                   SET m28_from_value = i.m127_from_value, -- m28_from_value
                       m28_to_value = i.m127_to_value, -- m28_to_value
                       m28_grade_label = i.m127_grade_label, -- m28_grade_label
                       m28_modified_by_id_u17 = 0, -- m28_modified_by_id_u17
                       m28_modified_date = SYSDATE -- m28_modified_date
                 WHERE m28_id = i.new_cust_grade_data_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M28_CUSTOMER_GRADE_DATA',
                                i.m127_id,
                                CASE
                                    WHEN i.new_cust_grade_data_id IS NULL
                                    THEN
                                        l_cust_grd_id
                                    ELSE
                                        i.new_cust_grade_data_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_grade_data_id IS NULL
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
