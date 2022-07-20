DECLARE
    l_fix_login_id   NUMBER;
    l_sqlerrm        VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m67_id), 0)
      INTO l_fix_login_id
      FROM dfn_ntp.m67_fix_logins;

    DELETE FROM error_log
          WHERE mig_table = 'M67_FIX_LOGINS';

    FOR i IN (SELECT m184.m184_login_id,
                     m02.new_institute_id,
                     m184.m184_enabled,
                     m184.m184_id,
                     m67_map.new_fix_logins_id
                FROM mubasher_oms.m184_fix_logins@mubasher_db_link m184
                     JOIN m02_institute_mappings m02
                         ON m184.m184_inst_id = m02.old_institute_id
                     LEFT JOIN m67_fix_logins_mappings m67_map
                         ON m184.m184_id = m67_map.old_fix_logins_id)
    LOOP
        BEGIN
            IF i.new_fix_logins_id IS NULL
            THEN
                l_fix_login_id := l_fix_login_id + 1;

                INSERT INTO dfn_ntp.m67_fix_logins (m67_login_id,
                                                    m67_inst_id_m02,
                                                    m67_enabled,
                                                    m67_id,
                                                    m67_mubasher_no,
                                                    m67_created_by_id_u17,
                                                    m67_created_date,
                                                    m67_modified_by_id_u17,
                                                    m67_modified_date,
                                                    m67_custom_type)
                     VALUES (i.m184_login_id, -- m67_login_id
                             i.new_institute_id, -- m67_inst_id_m02
                             i.m184_enabled, -- m67_enabled
                             l_fix_login_id, -- m67_id
                             NULL, -- m67_mubasher_no | Not Available
                             0, -- m67_created_by_id_u17
                             SYSDATE, -- m67_created_date
                             NULL, -- m67_modified_by_id_u17
                             NULL, -- m67_modified_date
                             '1' -- m67_custom_type
                                );

                INSERT INTO m67_fix_logins_mappings
                     VALUES (i.m184_id, l_fix_login_id);
            ELSE
                UPDATE dfn_ntp.m67_fix_logins
                   SET m67_login_id = i.m184_login_id, -- m67_login_id
                       m67_inst_id_m02 = i.new_institute_id, -- m67_inst_id_m02
                       m67_enabled = i.m184_enabled, -- m67_enabled
                       m67_modified_by_id_u17 = 0, -- m67_modified_by_id_u17
                       m67_modified_date = SYSDATE -- m67_modified_date
                 WHERE m67_id = i.new_fix_logins_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M67_FIX_LOGINS',
                                i.m184_id,
                                CASE
                                    WHEN i.new_fix_logins_id IS NULL
                                    THEN
                                        l_fix_login_id
                                    ELSE
                                        i.new_fix_logins_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_fix_logins_id IS NULL
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
