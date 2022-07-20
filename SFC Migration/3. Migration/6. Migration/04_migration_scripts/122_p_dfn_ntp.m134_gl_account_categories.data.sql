DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_gl_acc_categories_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m134_id), 0)
      INTO l_gl_acc_categories_id
      FROM dfn_ntp.m134_gl_account_categories;

    DELETE FROM error_log
          WHERE mig_table = 'M134_GL_ACCOUNT_CATEGORIES';

    FOR i
        IN (  SELECT MAX (m21.m21_id) AS m21_id,
                     m21.m21_description, -- Finding different types of account categories and using it as the key
                     MAX (m133_map.new_gl_account_types_id)
                         AS new_gl_account_types_id,
                     MAX (NVL (u17_created.new_employee_id, 0))
                         AS created_by_new_id,
                     MAX (NVL (m21.m21_created_date, SYSDATE)) AS created_date,
                     MAX (u17_modified.new_employee_id) AS modifed_by_new_id,
                     MAX (m21.m21_modified_date) AS modified_date,
                     MAX (map01.map01_ntp_id) AS map01_ntp_id,
                     MAX (NVL (u17_status_changed.new_employee_id, 0))
                         AS status_changed_by_new_id,
                     MAX (NVL (m21.m21_status_changed_date, SYSDATE))
                         AS status_changed_date,
                     MAX (m134_map.new_gl_acc_categories_id)
                         AS new_gl_acc_categories_id
                FROM mubasher_oms.m21_gl@mubasher_db_link m21,
                     map01_approval_status_v01 map01,
                     m133_gl_account_types_mappings m133_map,
                     u17_employee_mappings u17_created,
                     u17_employee_mappings u17_modified,
                     u17_employee_mappings u17_status_changed,
                     m134_gl_acc_category_mappings m134_map
               WHERE     m21_status_id = map01.map01_oms_id
                     AND m21.m21_gl_account_type =
                             m133_map.new_gl_account_types_id
                     AND m21.m21_created_by = u17_created.old_employee_id(+)
                     AND m21.m21_modified_by = u17_modified.old_employee_id(+)
                     AND m21.m21_status_changed_by =
                             u17_status_changed.old_employee_id(+)
                     AND m21.m21_description =
                             m134_map.old_gl_acc_category_name(+)
            GROUP BY m21.m21_description)
    LOOP
        BEGIN
            IF i.new_gl_acc_categories_id IS NULL
            THEN
                l_gl_acc_categories_id := l_gl_acc_categories_id + 1;

                INSERT
                  INTO dfn_ntp.m134_gl_account_categories (
                           m134_id,
                           m134_description,
                           m134_description_lang,
                           m134_account_type_id_m133,
                           m134_institute_id_m02,
                           m134_created_by_id_u17,
                           m134_created_date,
                           m134_modified_by_id_u17,
                           m134_modified_date,
                           m134_status_id_v01,
                           m134_status_changed_by_id_u17,
                           m134_status_changed_date,
                           m134_custom_type)
                VALUES (l_gl_acc_categories_id, -- m134_id
                        i.m21_description, -- m134_description
                        i.m21_description, -- m134_description_lang
                        i.new_gl_account_types_id, -- m134_account_type_id_m133
                        l_primary_institute_id, -- m134_institute_id_m02
                        i.created_by_new_id, -- m134_created_by_id_u17
                        i.created_date, -- m134_created_date
                        i.modifed_by_new_id, -- m134_modified_by_id_u17
                        i.modified_date, -- m134_modified_date
                        i.map01_ntp_id, -- m134_status_id_v01
                        i.status_changed_by_new_id, -- m134_status_changed_by_id_u17
                        i.status_changed_date, -- m134_status_changed_date
                        '1' -- m134_custom_type
                           );

                INSERT INTO m134_gl_acc_category_mappings
                     VALUES (i.m21_description, l_gl_acc_categories_id);
            ELSE
                UPDATE dfn_ntp.m134_gl_account_categories
                   SET m134_description = i.m21_description, -- m134_description
                       m134_description_lang = i.m21_description, -- m134_description_lang
                       m134_account_type_id_m133 = i.new_gl_account_types_id, -- m134_account_type_id_m133
                       m134_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m134_modified_by_id_u17
                       m134_modified_date = NVL (i.modified_date, SYSDATE), -- m134_modified_date
                       m134_status_id_v01 = i.map01_ntp_id, -- m134_status_id_v01
                       m134_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m134_status_changed_by_id_u17
                       m134_status_changed_date = i.status_changed_date -- m134_status_changed_date
                 WHERE m134_id = i.new_gl_acc_categories_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M134_GL_ACCOUNT_CATEGORIES',
                                i.m21_description,
                                CASE
                                    WHEN i.new_gl_acc_categories_id IS NULL
                                    THEN
                                        l_gl_acc_categories_id
                                    ELSE
                                        i.new_gl_acc_categories_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_gl_acc_categories_id IS NULL
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
