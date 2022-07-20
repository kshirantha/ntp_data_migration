DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_gl_account_types_id    NUMBER;
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

    SELECT NVL (MAX (m133_id), 0)
      INTO l_gl_account_types_id
      FROM dfn_ntp.m133_gl_account_types;

    DELETE FROM error_log
          WHERE mig_table = 'M133_GL_ACCOUNT_TYPES';

    FOR i
        IN (SELECT m79.m79_id,
                   m79.m79_description,
                   m133_map.new_gl_account_types_id
              FROM mubasher_oms.m79_gl_account_types@mubasher_db_link m79,
                   m133_gl_account_types_mappings m133_map
             WHERE m79.m79_id = m133_map.old_gl_account_types_id(+))
    LOOP
        BEGIN
            IF i.new_gl_account_types_id IS NULL
            THEN
                l_gl_account_types_id := l_gl_account_types_id + 1;

                INSERT
                  INTO dfn_ntp.m133_gl_account_types (
                           m133_id,
                           m133_description,
                           m133_description_lang,
                           m133_created_by_id_u17,
                           m133_created_date,
                           m133_modified_by_id_u17,
                           m133_modified_date,
                           m133_status_id_v01,
                           m133_status_changed_by_id_u17,
                           m133_status_changed_date,
                           m133_custom_type,
                           m133_institute_id_m02)
                VALUES (l_gl_account_types_id, -- m133_id
                        i.m79_description, -- m133_description
                        i.m79_description, -- m133_description_lang
                        0, -- m133_created_by_id_u17
                        SYSDATE, -- m133_created_date
                        NULL, -- m133_modified_by_id_u17
                        NULL, -- m133_modified_date
                        2, -- m133_status_id_v01
                        0, -- m133_status_changed_by_id_u17
                        SYSDATE, -- m133_status_changed_date
                        '1', -- m133_custom_type
                        l_primary_institute_id -- m133_institute_id_m02
                                              );

                INSERT INTO m133_gl_account_types_mappings
                     VALUES (i.m79_id, l_gl_account_types_id);
            ELSE
                UPDATE dfn_ntp.m133_gl_account_types
                   SET m133_description = i.m79_description, -- m133_description
                       m133_description_lang = i.m79_description, -- m133_description_lang
                       m133_modified_by_id_u17 = 0, -- m133_modified_by_id_u17
                       m133_modified_date = SYSDATE -- m133_modified_date
                 WHERE m133_id = i.new_gl_account_types_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M133_GL_ACCOUNT_TYPES',
                                i.m79_id,
                                CASE
                                    WHEN i.new_gl_account_types_id IS NULL
                                    THEN
                                        l_gl_account_types_id
                                    ELSE
                                        i.new_gl_account_types_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_gl_account_types_id IS NULL
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
