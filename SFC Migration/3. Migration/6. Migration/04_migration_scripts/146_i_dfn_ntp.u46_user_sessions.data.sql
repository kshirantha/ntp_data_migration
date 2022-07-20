-- Live sessions are also migrated to history table

DECLARE
    l_sqlerrm   VARCHAR2 (4000);
BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'H07_USER_SESSIONS - Live';

    FOR i
        IN (SELECT sessions.*,
                   h07.h07_channel_id AS mapped_channel_id,
                   h07.h07_login_id AS mapped_login_id,
                   h07.h07_entity_type AS mapped_entity_type,
                   h07.h07_login_date AS mapped_login_date
              FROM (SELECT u01_oms.u01_session_id,
                           v29.v29_id,
                           u01_oms.u01_login_id AS login_id,
                           u01_oms.u01_login_time,
                           TRUNC (u01_oms.u01_login_time) AS login_date,
                           u01_oms.u01_last_updated,
                           u01_oms.u01_ip,
                           u09.u09_customer_id_u01 AS entity_id,
                           1 AS entity_type, -- 1 [Customer]
                           u09.u09_institute_id_m02 AS institute_id
                      FROM mubasher_oms.u01_user_sessions@mubasher_db_link u01_oms,
                           mubasher_oms.m04_logins@mubasher_db_link m04_oms,
                           mubasher_oms.m01_customer@mubasher_db_link m01_oms,
                           u09_customer_login_mappings u09_map,
                           dfn_ntp.u09_customer_login u09,
                           dfn_ntp.v29_order_channel v29,
                           m02_institute_mappings m02_map
                     WHERE     u01_oms.u01_login_id = m04_oms.m04_id(+) -- [Corrective Actions Discussed]
                           AND m04_oms.m04_id = m01_oms.m01_login_id(+) -- [Corrective Actions Discussed]
                           AND m01_oms.m01_login_id =
                                   u09_map.old_customer_login_id(+)
                           AND m01_oms.m01_owner_id =
                                   m02_map.old_institute_id
                           AND u09_map.new_customer_login_id = u09.u09_id(+)
                           AND u01_oms.u01_usertype = v29.v29_id -- OMS Capture Channel ID in U01_USERTYPE
                           AND v29.v29_id NOT IN (7, 12)
                           AND m04_oms.m04_user_type = 0
                    UNION
                    SELECT u01_oms.u01_session_id,
                           v29.v29_id,
                           u17.u17_id AS login_id, -- Employees ID is Stored Here as Well
                           u01_oms.u01_login_time,
                           TRUNC (u01_oms.u01_login_time) AS login_date,
                           u01_oms.u01_last_updated,
                           u01_oms.u01_ip,
                           u17.u17_id AS entity_id,
                           2 AS entity_type, -- 2 [User]
                           u17.u17_institution_id_m02 AS institute_id
                      FROM mubasher_oms.u01_user_sessions@mubasher_db_link u01_oms,
                           mubasher_oms.m04_logins@mubasher_db_link m04_oms,
                           mubasher_oms.m06_employees@mubasher_db_link m06_oms,
                           u17_employee_mappings u17_map,
                           dfn_ntp.u17_employee u17,
                           dfn_ntp.v29_order_channel v29,
                           m02_institute_mappings m02_map
                     WHERE     u01_oms.u01_login_id = m04_oms.m04_id(+) -- [Corrective Actions Discussed]
                           AND m04_oms.m04_id = m06_oms.m06_login_id(+) -- [Corrective Actions Discussed]
                           AND m06_oms.m06_id = u17_map.old_employee_id(+)
                           AND u17_map.new_employee_id = u17.u17_id(+)
                           AND m06_oms.m06_branch_id =
                                   m02_map.old_institute_id
                           AND u01_oms.u01_usertype = v29.v29_id -- OMS Capture Channel ID in U01_USERTYPE
                           AND v29.v29_id IN (7, 12)
                           AND m04_oms.m04_user_type = 1) sessions,
                   (SELECT h07_channel_id,
                           h07_login_id,
                           h07_entity_type,
                           TRUNC (h07_login_time) AS h07_login_date
                      FROM dfn_ntp.h07_user_sessions) h07
             WHERE     sessions.v29_id = h07.h07_channel_id(+)
                   AND sessions.login_id = h07.h07_login_id(+)
                   AND sessions.entity_type = h07.h07_entity_type(+)
                   AND sessions.login_date = h07.h07_login_date(+))
    LOOP
        BEGIN
            IF i.entity_id IS NULL AND i.entity_type = 1
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.entity_id IS NULL AND i.entity_type = 2
            THEN
                raise_application_error (-20001, 'User Not Available', TRUE);
            END IF;

            IF     i.mapped_channel_id IS NOT NULL
               AND i.mapped_login_id IS NOT NULL
               AND i.mapped_entity_type IS NOT NULL
            THEN
                UPDATE dfn_ntp.h07_user_sessions
                   SET h07_session_id = i.u01_session_id, -- h07_session_id
                       h07_login_time = i.u01_login_time, -- h07_login_time
                       h07_last_updated = i.u01_last_updated, -- h07_last_updated
                       h07_ip = i.u01_ip, -- h07_ip
                       h07_entity_id = i.entity_id, -- h07_entity_id
                       h07_institute_id_m02 = i.institute_id -- h07_institute_id_m02
                 WHERE     h07_channel_id = i.mapped_channel_id
                       AND h07_login_id = i.mapped_login_id
                       AND h07_entity_type = i.mapped_entity_type
                       AND TRUNC (h07_login_time) = i.mapped_login_date;
            ELSE
                INSERT INTO dfn_ntp.h07_user_sessions (h07_session_id,
                                                       h07_channel_id,
                                                       h07_login_id,
                                                       h07_auth_status,
                                                       h07_login_time,
                                                       h07_last_updated,
                                                       h07_logout_time,
                                                       h07_ip,
                                                       h07_expiry_time,
                                                       h07_entity_id,
                                                       h07_entity_type,
                                                       h07_institute_id_m02,
                                                       h07_operating_system,
                                                       h07_location,
                                                       h07_browser)
                     VALUES (i.u01_session_id, -- h07_session_id
                             i.v29_id, -- h07_channel_id
                             i.login_id, -- h07_login_id
                             -1, -- h07_auth_status | Default
                             i.u01_login_time, -- h07_login_time
                             i.u01_last_updated, -- h07_last_updated
                             SYSDATE, -- h07_logout_time
                             i.u01_ip, -- h07_ip
                             SYSDATE, -- h07_expiry_time
                             i.entity_id, -- h07_entity_id
                             i.entity_type, -- h07_entity_type
                             i.institute_id, -- h07_institute_id_m02
                             NULL, -- h07_operating_system | Not Available
                             NULL, -- h07_location | Not Available
                             NULL -- h07_browser | Not Available
                                 );
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H07_USER_SESSIONS - Live',
                                'Session - ' || i.u01_session_id,
                                CASE
                                    WHEN     i.mapped_channel_id IS NOT NULL
                                         AND i.mapped_login_id IS NOT NULL
                                         AND i.mapped_entity_type IS NOT NULL
                                    THEN
                                           'Channel : '
                                        || i.mapped_channel_id
                                        || ' - '
                                        || 'Login Id : '
                                        || i.mapped_login_id
                                        || ' - '
                                        || 'Entity Type : '
                                        || i.mapped_entity_type
                                    ELSE
                                           'Channel : '
                                        || i.v29_id
                                        || ' - '
                                        || 'Login Id : '
                                        || i.login_id
                                        || ' - '
                                        || 'Entity Type : '
                                        || i.entity_type
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.mapped_channel_id IS NOT NULL
                                         AND i.mapped_login_id IS NOT NULL
                                         AND i.mapped_entity_type IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
