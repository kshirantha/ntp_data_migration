DECLARE
    l_audit_id   NUMBER;
    l_sqlerrm    VARCHAR2 (4000);

    l_rec_cnt    NUMBER := 0;
BEGIN
    SELECT NVL (MAX (a06_id), 0) INTO l_audit_id FROM dfn_ntp.a06_audit;

    DELETE FROM error_log
          WHERE mig_table = 'A06_AUDIT';

    FOR i
        IN (SELECT t22.t22_date,
                   u17_map.new_employee_id,
                   map02.map02_ntp_id,
                   t22.t22_description,
                   t22.t22_reference_no,
                   t22.t22_channel, -- [SAME IDs]
                   u01_map.new_customer_id,
                   u17.u17_institution_id_m02,
                   NULL AS new_customer_login_id,
                   m04.m04_user_type,
                   t22.t22_id,
                   a06_map.new_audit_id
              FROM mubasher_oms.t22_audit@mubasher_db_link t22,
                   mubasher_oms.m04_logins@mubasher_db_link m04, -- [Corrective Actions Discussed]
                   mubasher_oms.m06_employees@mubasher_db_link m06, -- [Corrective Actions Discussed]
                   map02_audit_activity_m82 map02,
                   u17_employee_mappings u17_map,
                   u01_customer_mappings u01_map,
                   dfn_ntp.u17_employee u17,
                   m02_institute_mappings m02_map,
                   a06_audit_mappings a06_map
             WHERE     t22.t22_login_id = m04.m04_id(+) -- [Corrective Actions Discussed]
                   AND m04.m04_id = m06.m06_login_id(+) -- [Corrective Actions Discussed]
                   AND m04.m04_user_type = 1 -- [Corrective Actions Discussed]
                   AND t22.t22_activity_id = map02.map02_oms_id(+)
                   AND t22.t22_customer_id = u01_map.old_customer_id(+)
                   AND m06.m06_id = u17_map.old_employee_id(+)
                   AND u17_map.new_employee_id = u17.u17_id(+)
                   AND m06.m06_branch_id = m02_map.old_institute_id
                   AND t22.t22_id = a06_map.old_audit_id(+)
            UNION ALL
            SELECT t22.t22_date,
                   NULL AS new_employee_id,
                   map02.map02_ntp_id,
                   t22.t22_description,
                   t22.t22_reference_no,
                   t22.t22_channel, -- [SAME IDs]
                   u01_map.new_customer_id,
                   u01.u01_institute_id_m02 AS u17_institution_id_m02,
                   u09_map.new_customer_login_id,
                   m04.m04_user_type,
                   t22.t22_id,
                   a06_map.new_audit_id
              FROM mubasher_oms.t22_audit@mubasher_db_link t22,
                   mubasher_oms.m04_logins@mubasher_db_link m04, -- [Corrective Actions Discussed]
                   map02_audit_activity_m82 map02,
                   u01_customer_mappings u01_map,
                   dfn_ntp.u01_customer u01,
                   u09_customer_login_mappings u09_map,
                   a06_audit_mappings a06_map
             WHERE     t22.t22_login_id = m04.m04_id(+) -- [Corrective Actions Discussed]
                   AND m04.m04_user_type = 0 -- [Corrective Actions Discussed]
                   AND t22.t22_login_id = u09_map.old_customer_login_id(+)
                   AND t22.t22_activity_id = map02.map02_oms_id(+)
                   AND t22.t22_customer_id = u01_map.old_customer_id(+)
                   AND u01_map.new_customer_id = u01.u01_id(+)
                   AND t22.t22_id = a06_map.old_audit_id(+))
    LOOP
        BEGIN
            IF i.m04_user_type = 1 AND i.new_employee_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Employee Not Available',
                                         TRUE);
            END IF;

            IF i.m04_user_type = 0 AND i.new_customer_login_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.map02_ntp_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Audit Activity Not Available',
                                         TRUE);
            END IF;

            IF i.new_audit_id IS NULL
            THEN
                l_audit_id := l_audit_id + 1;

                INSERT INTO dfn_ntp.a06_audit (a06_id,
                                               a06_date,
                                               a06_user_id_u17,
                                               a06_activity_id_m82,
                                               a06_description,
                                               a06_reference_no,
                                               a06_channel_v29,
                                               a06_customer_id_u01,
                                               a06_login_id_u09,
                                               a06_user_login_id_u17,
                                               a06_ip,
                                               a06_connected_machine,
                                               a06_custom_type,
                                               a06_institute_id_m02)
                     VALUES (l_audit_id, -- a06_id
                             i.t22_date, -- a06_date
                             i.new_employee_id, -- a06_user_id_u17
                             i.map02_ntp_id, -- a06_activity_id_m82
                             i.t22_description, -- a06_description
                             i.t22_reference_no, -- a06_reference_no
                             i.t22_channel, -- a06_channel_v29
                             i.new_customer_id, -- a06_customer_id_u01
                             i.new_customer_login_id, -- a06_login_id_u09
                             i.new_employee_id, -- a06_user_login_id_u17
                             NULL, -- a06_ip | Not Available
                             NULL, -- a06_connected_machine | Not Available
                             '1', -- a06_custom_type
                             i.u17_institution_id_m02 -- a06_institute_id_m02
                                                     );

                INSERT
                  INTO dfn_mig.a06_audit_mappings (old_audit_id, new_audit_id)
                VALUES (i.t22_id, l_audit_id);
            ELSE
                UPDATE dfn_ntp.a06_audit
                   SET a06_date = i.t22_date, -- a06_date
                       a06_user_id_u17 = i.new_employee_id, -- a06_user_id_u17
                       a06_activity_id_m82 = i.map02_ntp_id, -- a06_activity_id_m82
                       a06_description = i.t22_description, -- a06_description
                       a06_reference_no = i.t22_reference_no, -- a06_reference_no
                       a06_channel_v29 = i.t22_channel, -- a06_channel_v29
                       a06_customer_id_u01 = i.new_customer_id, -- a06_customer_id_u01
                       a06_login_id_u09 = i.new_customer_login_id, -- a06_login_id_u09
                       a06_user_login_id_u17 = i.new_employee_id, -- a06_user_login_id_u17
                       a06_institute_id_m02 = i.u17_institution_id_m02 -- a06_institute_id_m02
                 WHERE a06_id = i.new_audit_id;
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'A06_AUDIT',
                                i.t22_id,
                                CASE
                                    WHEN i.new_audit_id IS NULL
                                    THEN
                                        l_audit_id
                                    ELSE
                                        i.new_audit_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_audit_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
