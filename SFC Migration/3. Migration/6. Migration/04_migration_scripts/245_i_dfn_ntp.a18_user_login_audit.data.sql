BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'A18_USER_LOGIN_AUDIT';

    FOR i
        IN (SELECT logins.*,
                   a18.a18_channel_id_v29,
                   a18.a18_login_id,
                   a18.a18_entity_type
              FROM (SELECT u01.u01_channel_id, -- [SAME IDs]
                           u01.u01_appsvr_id,
                           u01.u01_ip,
                           u01.u01_login_name,
                           u01.u01_password,
                           u01.u01_version,
                           u01.u01_login_time,
                           map01.map01_ntp_id,
                           u01.u01_login_id,
                           u09_map.new_customer_login_id AS new_login_id,
                           u01_narration,
                           u01_failed_attempts,
                           1 AS entity_type, -- 1 - Customer
                           u09.u09_institute_id_m02 AS institute_id_m02
                      FROM mubasher_oms.u01_user_login_audit@mubasher_db_link u01,
                           map01_approval_status_v01 map01,
                           u09_customer_login_mappings u09_map,
                           dfn_ntp.u09_customer_login u09,
                           dfn_ntp.a18_user_login_audit
                     WHERE     u01.u01_status = map01.map01_oms_id
                           AND u01.u01_login_id =
                                   u09_map.old_customer_login_id
                           AND u09_map.new_customer_login_id = u09.u09_id
                           AND u01.u01_channel_id NOT IN (7, 12)
                    UNION ALL
                    SELECT u01.u01_channel_id, -- [SAME IDs]
                           u01.u01_appsvr_id,
                           u01.u01_ip,
                           u01.u01_login_name,
                           u01.u01_password,
                           u01.u01_version,
                           u01.u01_login_time,
                           map01.map01_ntp_id,
                           u01.u01_login_id,
                           u17_map.new_employee_id AS new_login_id,
                           u01_narration,
                           u01_failed_attempts,
                           2 AS entity_type, -- 2 - User
                           u17.u17_institution_id_m02 AS institute_id_m02
                      FROM mubasher_oms.u01_user_login_audit@mubasher_db_link u01,
                           map01_approval_status_v01 map01,
                           u17_employee_mappings u17_map,
                           dfn_ntp.u17_employee u17
                     WHERE     u01.u01_status = map01.map01_oms_id
                           AND u01.u01_login_id = u17_map.old_employee_id
                           AND u17_map.new_employee_id = u17.u17_id
                           AND u01.u01_channel_id IN (7, 12)) logins,
                   dfn_ntp.a18_user_login_audit a18
             WHERE     logins.u01_channel_id = a18.a18_channel_id_v29(+)
                   AND logins.new_login_id = a18.a18_login_id(+)
                   AND logins.entity_type = a18.a18_entity_type(+))
    LOOP
        BEGIN
            IF     i.a18_channel_id_v29 IS NOT NULL
               AND i.a18_login_id IS NOT NULL
               AND i.a18_entity_type IS NOT NULL
            THEN
                UPDATE dfn_ntp.a18_user_login_audit
                   SET a18_appsvr_id = i.u01_appsvr_id, -- a18_appsvr_id
                       a18_ip = i.u01_ip, -- a18_ip
                       a18_login_name = i.u01_login_name, -- a18_login_name
                       a18_password = i.u01_password, -- a18_password
                       a18_version = i.u01_version, -- a18_version
                       a18_login_time = i.u01_login_time, -- a18_login_time
                       a18_status_id_v01 = i.map01_ntp_id, -- a18_status_id_v01
                       a18_narration = i.u01_narration, -- a18_narration
                       a18_failed_attempts = i.u01_failed_attempts, -- a18_failed_attempts
                       a18_institute_id_m02 = i.institute_id_m02 -- a18_institute_id_m02
                 WHERE     a18_channel_id_v29 = i.a18_channel_id_v29
                       AND a18_login_id = i.a18_login_id
                       AND a18_entity_type = i.a18_entity_type;
            ELSE
                INSERT
                  INTO dfn_ntp.a18_user_login_audit (a18_channel_id_v29,
                                                     a18_appsvr_id,
                                                     a18_ip,
                                                     a18_login_name,
                                                     a18_password,
                                                     a18_version,
                                                     a18_login_time,
                                                     a18_status_id_v01,
                                                     a18_login_id,
                                                     a18_narration,
                                                     a18_failed_attempts,
                                                     a18_password_b,
                                                     a18_entity_type,
                                                     a18_institute_id_m02)
                VALUES (i.u01_channel_id, --a18_channel_id_v29
                        i.u01_appsvr_id, -- a18_appsvr_id
                        i.u01_ip, -- a18_ip
                        i.u01_login_name, -- a18_login_name
                        i.u01_password, -- a18_password
                        i.u01_version, -- a18_version
                        i.u01_login_time, -- a18_login_time
                        i.map01_ntp_id, -- a18_status_id_v01
                        i.new_login_id, -- a18_login_id
                        i.u01_narration, -- a18_narration
                        i.u01_failed_attempts, -- a18_failed_attempts
                        NULL, -- a18_password_b
                        i.entity_type, -- a18_entity_type
                        i.institute_id_m02 -- a18_institute_id_m02
                                          );
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'A18_USER_LOGIN_AUDIT',
                                   'Entity Type : '
                                || CASE
                                       WHEN i.a18_entity_type = 1
                                       THEN
                                           'Customer'
                                       ELSE
                                           'User'
                                   END
                                || ' - '
                                || 'Channel Id : '
                                || i.u01_channel_id
                                || 'Login Id : '
                                || i.u01_login_id,
                                CASE
                                    WHEN     i.a18_channel_id_v29 IS NOT NULL
                                         AND i.a18_login_id IS NOT NULL
                                         AND i.a18_entity_type IS NOT NULL
                                    THEN
                                           'Entity Type : '
                                        || i.a18_entity_type
                                        || ' - '
                                        || 'Channel Id : '
                                        || i.u01_channel_id
                                        || ' - '
                                        || 'Login Id : '
                                        || i.new_login_id
                                    ELSE
                                           'Entity Type : '
                                        || i.entity_type
                                        || ' - '
                                        || 'Channel Id : '
                                        || i.a18_channel_id_v29
                                        || ' - '
                                        || 'Login Id : '
                                        || i.a18_login_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.a18_channel_id_v29 IS NOT NULL
                                         AND i.a18_login_id IS NOT NULL
                                         AND i.a18_entity_type IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                l_sqlerrm);
        END;
    END LOOP;
END;
/
