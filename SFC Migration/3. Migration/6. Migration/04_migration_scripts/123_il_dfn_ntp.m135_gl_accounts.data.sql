DECLARE
    l_gl_account_id           NUMBER;
    l_default_currency_id     NUMBER;
    l_default_currency_code   VARCHAR2 (10);
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_default_currency_id
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY';

    SELECT VALUE
      INTO l_default_currency_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    SELECT NVL (MAX (m135_id), 0)
      INTO l_gl_account_id
      FROM dfn_ntp.m135_gl_accounts;

    DELETE FROM error_log
          WHERE mig_table = 'M135_GL_ACCOUNTS';

    FOR i
        IN (SELECT m21.m21_id,
                   NVL (m21.m21_code, '-') AS m21_code,
                   m134_map.new_gl_acc_categories_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m21.m21_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m21.m21_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   m02_map.new_institute_id,
                   m135_map.new_gl_accounts_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m21.m21_status_changed_date, SYSDATE)
                       AS status_changed_date
              FROM mubasher_oms.m21_gl@mubasher_db_link m21,
                   m134_gl_acc_category_mappings m134_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m135_gl_accounts_mappings m135_map
             WHERE     m21.m21_description =
                           m134_map.old_gl_acc_category_name
                   AND m21.m21_status_id = map01.map01_oms_id
                   AND m21.m21_created_by = u17_created.old_employee_id(+)
                   AND m21.m21_modified_by = u17_modified.old_employee_id(+)
                   AND m21.m21_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m21.m21_id = m135_map.old_gl_accounts_id(+)
                   AND m02_map.old_institute_id =
                           m135_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_gl_accounts_id IS NULL
            THEN
                l_gl_account_id := l_gl_account_id + 1;

                INSERT
                  INTO dfn_ntp.m135_gl_accounts (m135_id,
                                                 m135_code,
                                                 m135_currency_code_m03,
                                                 m135_currency_id_m03,
                                                 m135_acc_cat_id_m134,
                                                 m135_external_ref,
                                                 m135_created_by_id_u17,
                                                 m135_created_date,
                                                 m135_modified_by_id_u17,
                                                 m135_modified_date,
                                                 m135_status_id_v01,
                                                 m135_status_changed_by_id_u17,
                                                 m135_status_changed_date,
                                                 m135_institute_id_m02,
                                                 m135_custom_type)
                VALUES (l_gl_account_id, -- m135_id
                        i.m21_code, -- m135_code
                        l_default_currency_code, -- m135_currency_code_m03 | Not Available
                        l_default_currency_id, -- m135_currency_id_m03 | Not Available
                        i.new_gl_acc_categories_id, -- m135_acc_cat_id_m134
                        i.m21_id, -- m135_external_ref
                        i.created_by_new_id, -- m135_created_by_id_u17
                        i.created_date, -- m135_created_date
                        i.modifed_by_new_id, -- m135_modified_by_id_u17
                        i.modified_date, -- m135_modified_date
                        i.map01_ntp_id, -- m135_status_id_v01
                        i.status_changed_by_new_id, -- m135_status_changed_by_id_u17
                        i.status_changed_date, -- m135_status_changed_date
                        i.new_institute_id, -- m135_institute_id_m02
                        '1' -- m135_custom_type
                           );

                INSERT INTO m135_gl_accounts_mappings
                     VALUES (i.m21_id, l_gl_account_id, i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m135_gl_accounts
                   SET m135_code = i.m21_code, -- m135_code
                       m135_acc_cat_id_m134 = i.new_gl_acc_categories_id, -- m135_acc_cat_id_m134
                       m135_external_ref = i.m21_id, -- m135_external_ref
                       m135_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m135_modified_by_id_u17
                       m135_modified_date = NVL (i.modified_date, SYSDATE), -- m135_modified_date
                       m135_status_id_v01 = i.map01_ntp_id, -- m135_status_id_v01
                       m135_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m135_status_changed_by_id_u17
                       m135_status_changed_date = i.status_changed_date -- m135_status_changed_date
                 WHERE m135_id = i.new_gl_accounts_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M135_GL_ACCOUNTS',
                                i.m21_id,
                                CASE
                                    WHEN i.new_gl_accounts_id IS NULL
                                    THEN
                                        l_gl_account_id
                                    ELSE
                                        i.new_gl_accounts_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_gl_accounts_id IS NULL
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
