DECLARE
    l_sqlerrm   VARCHAR2 (4000);
BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'H07_USER_SESSIONS - History';

    FOR i
        IN (SELECT sessions.*,
                   h07.h07_channel_id AS mapped_channel_id,
                   h07.h07_login_id AS mapped_login_id,
                   h07.h07_entity_type AS mapped_entity_type,
                   h07.h07_login_date AS mapped_login_date
              FROM (  SELECT MAX (u04.u04_session_id) AS u04_session_id,
                             TO_NUMBER (u04.u04_channel_id) AS u04_channel_id, -- [SAME IDs]
                             u01_map.new_customer_id AS login_id, -- Customer ID Stored is Stored Here as Well
                             TRUNC (u04.u04_login_time) AS login_date,
                             MAX (u04.u04_login_time) AS u04_login_time,
                             MAX (u04.u04_last_updated) AS u04_last_updated,
                             MAX (u04.u04_logout_time) AS u04_logout_time,
                             MAX (u04.u04_ip) AS u04_ip,
                             u01_map.new_customer_id AS entity_id,
                             1 AS entity_type, -- 1 - Customer
                             MAX (u01.u01_institute_id_m02) AS institute_id
                        FROM (SELECT *
                                FROM mubasher_oms.u04_user_sessions_history@mubasher_db_link
                               WHERE u04_channel_id NOT IN ('TRS01', 'TRS02')) u04,
                             u01_customer_mappings u01_map,
                             dfn_ntp.u01_customer u01
                       WHERE     u04.u04_userid = u01_map.old_customer_id(+)
                             AND u01_map.new_customer_id = u01.u01_id(+)
                             AND u04.u04_channel_id NOT IN ('7', '12')
                    GROUP BY TO_NUMBER (u04.u04_channel_id),
                             u01_map.new_customer_id,
                             TRUNC (u04.u04_login_time)
                    UNION ALL
                      SELECT MAX (u04.u04_session_id) AS u04_session_id,
                             TO_NUMBER (u04.u04_channel_id) AS u04_channel_id, -- [SAME IDs]
                             u17.u17_id AS login_id, -- Employees ID Stored is Stored Here as Well
                             TRUNC (u04.u04_login_time) AS login_date,
                             MAX (u04.u04_login_time) AS u04_login_time,
                             MAX (u04.u04_last_updated) AS u04_last_updated,
                             MAX (u04.u04_logout_time) AS u04_logout_time,
                             MAX (u04.u04_ip) AS u04_ip,
                             u17.u17_id AS entity_id,
                             2 AS entity_type, -- 2 - User
                             MAX (u17.u17_institution_id_m02) AS institute_id
                        FROM (SELECT *
                                FROM mubasher_oms.u04_user_sessions_history@mubasher_db_link
                               WHERE u04_channel_id NOT IN ('TRS01', 'TRS02')) u04,
                             u17_employee_mappings u17_map,
                             dfn_ntp.u17_employee u17
                       WHERE     u04.u04_userid = u17_map.old_employee_id(+)
                             AND u17_map.new_employee_id = u17.u17_id(+)
                             AND u04.u04_channel_id IN ('7', '12')
                    GROUP BY TO_NUMBER (u04.u04_channel_id),
                             u17.u17_id,
                             TRUNC (u04.u04_login_time)) sessions,
                   (SELECT h07_channel_id,
                           h07_login_id,
                           h07_entity_type,
                           TRUNC (h07_login_time) AS h07_login_date
                      FROM dfn_ntp.h07_user_sessions) h07
             WHERE     sessions.u04_channel_id = h07.h07_channel_id(+)
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
               AND i.mapped_login_date IS NOT NULL
            THEN
                UPDATE dfn_ntp.h07_user_sessions
                   SET h07_session_id = i.u04_session_id, -- h07_session_id
                       h07_login_time = i.u04_login_time, -- h07_login_time
                       h07_last_updated = i.u04_last_updated, -- h07_last_updated
                       h07_logout_time = i.u04_logout_time, -- h07_logout_time
                       h07_ip = i.u04_ip, -- h07_ip
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
                     VALUES (i.u04_session_id, -- h07_session_id
                             i.u04_channel_id, -- h07_channel_id
                             i.login_id, -- h07_login_id
                             -1, -- h07_auth_status | Default
                             i.u04_login_time, -- h07_login_time
                             i.u04_last_updated, -- h07_last_updated
                             i.u04_logout_time, -- h07_logout_time
                             i.u04_ip, -- h07_ip
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
                                'H07_USER_SESSIONS - History',
                                'Session - ' || i.u04_session_id,
                                CASE
                                    WHEN     i.mapped_channel_id IS NOT NULL
                                         AND i.mapped_login_id IS NOT NULL
                                         AND i.mapped_entity_type IS NOT NULL
                                         AND i.mapped_login_date IS NOT NULL
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
                                        || i.u04_channel_id
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
                                         AND i.mapped_login_date IS NOT NULL
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
