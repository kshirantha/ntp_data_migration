DECLARE
    l_employee_id        NUMBER;
    l_default_emp_type   NUMBER;
    l_sys_password       NVARCHAR2 (4000);
    l_sqlerrm            VARCHAR2 (4000);
    l_use_new_key        NUMBER;
BEGIN
    SELECT NVL (MAX (u17_id), 0) INTO l_employee_id FROM dfn_ntp.u17_employee;

    SELECT VALUE
      INTO l_default_emp_type
      FROM migration_params
     WHERE code = 'DEFAULT_EMPLOYEE_TYPE';

    l_use_new_key := fn_use_new_key ('U17_EMPLOYEE');

    DELETE FROM error_log
          WHERE mig_table = 'U17_EMPLOYEE';

    FOR i
        IN (  SELECT m02_map.new_institute_id,
                     m06.m06_id,
                     m06.m06_branch_id,
                     UPPER (
                         TRIM (
                                NVL (m06.m06_other_names, '')
                             || ' '
                             || NVL (m06.m06_last_name, '')))
                         AS emp_full_name,
                     UPPER (m04.m04_login_name) AS m04_login_name, -- SFC Requirement
                     m04.m04_login_pw,
                     m04.m04_failed_attempts,
                     NVL (m06.m06_created_by, 0) AS created_by,
                     NVL (m06.m06_created_date, SYSDATE) AS created_date,
                     map01.map01_ntp_id,
                     m04.m04_status, -- [SAME IDs]
                     NVL (map05.map05_ntp_id, l_default_emp_type)
                         AS employee_type,
                     m06.m06_price_username,
                     m06.m06_price_password,
                     NVL (m04.m04_expiray_date, SYSDATE - 90)
                         AS m04_expiray_date,
                     m04.m04_last_loggedin_date,
                     m06.m06_telephone,
                     m06.m06_telephone_ext,
                     m06.m06_mobile,
                     m06.m06_email,
                     m12_map.new_emp_dep_id,
                     m06.m06_employee_no,
                     m06.m06_modified_by,
                     m06.m06_modified_date,
                     NVL (m06.m06_status_changed_by, 0) AS status_changed_by,
                     NVL (m06.m06_status_changed_date, SYSDATE)
                         AS status_changed_date,
                     m04.m04_password_history,
                     0 AS m06_user_category, -- [NOT USED] NTP => Local = 0, International = 1, both = 3 | OLD SYSTEM => Local - 1, International - 2, Both - 3
                     m04.m04_client_version,
                     m06.m06_trading_enabled,
                     m06.m06_department_id,
                     u17_map.new_employee_id
                FROM mubasher_oms.m06_employees@mubasher_db_link m06,
                     mubasher_oms.m04_logins@mubasher_db_link m04,
                     mubasher_oms.m71_employee_subtype@mubasher_db_link m71,
                     map01_approval_status_v01 map01,
                     map05_employee_type_m11 map05,
                     m02_institute_mappings m02_map,
                     m12_emp_dep_mappings m12_map,
                     u17_employee_mappings u17_map
               WHERE     m06.m06_login_id = m04.m04_id
                     AND m06.m06_status_id = map01.map01_oms_id
                     AND m06.m06_employee_subtype = m71.m71_id(+)
                     AND m71.m71_id = map05.map05_oms_id(+)
                     AND m06.m06_id <> 0
                     AND m02_map.old_institute_id = m06.m06_branch_id
                     AND m04.m04_user_type = 1
                     AND m06.m06_department_id = m12_map.old_emp_dep_id(+)
                     AND m06.m06_id = u17_map.old_employee_id(+)
            ORDER BY m06.m06_id)
    LOOP
        BEGIN
            IF i.new_employee_id IS NULL
            THEN
                l_employee_id :=
                    CASE
                        WHEN l_use_new_key = 0 THEN i.m06_id
                        ELSE l_employee_id + 1
                    END;

                INSERT
                  INTO dfn_ntp.u17_employee (u17_id,
                                             u17_institution_id_m02,
                                             u17_full_name,
                                             u17_login_name,
                                             u17_password,
                                             u17_failed_attempts,
                                             u17_is_first_time,
                                             u17_created_by_id_u17,
                                             u17_created_date,
                                             u17_status_id_v01,
                                             u17_login_status,
                                             u17_type_id_m11,
                                             u17_price_login_name,
                                             u17_price_password,
                                             u17_pw_expire_date,
                                             u17_last_login_date,
                                             u17_telephone,
                                             u17_telephone_ext,
                                             u17_mobile,
                                             u17_email,
                                             u17_department_id_m12,
                                             u17_employee_no,
                                             u17_modified_by_id_u17,
                                             u17_modified_date,
                                             u17_status_changed_by_u17,
                                             u17_status_changed_date,
                                             u17_history_passwords,
                                             u17_client_version,
                                             u17_trading_enabled,
                                             u17_full_name_saudi,
                                             u17_location_id_m07,
                                             u17_custom_type,
                                             u17_dealer_cmsn_grp_id_m162,
                                             u17_authentication_type,
                                             u17_external_ref,
                                             u17_user_category)
                VALUES (l_employee_id, -- u17_id
                        i.new_institute_id, -- u17_institution_id_m02
                        i.emp_full_name, -- u17_full_name
                        i.m04_login_name, -- u17_login_name
                        i.m04_login_pw, -- u17_password
                        i.m04_failed_attempts, -- u17_failed_attempts
                        0, -- u17_is_first_time | Discussed to Not to Migrate
                        i.created_by, -- u17_created_by_id_u17 | Updated Later from 999 Script
                        i.created_date, -- u17_created_date
                        i.map01_ntp_id, -- u17_status_id_v01
                        i.m04_status, -- u17_login_status
                        i.employee_type, -- u17_type_id_m11
                        i.m06_price_username, -- u17_price_login_name
                        i.m06_price_password, -- u17_price_password
                        i.m04_expiray_date, -- u17_pw_expire_date
                        i.m04_last_loggedin_date, -- u17_last_login_date
                        i.m06_telephone, -- u17_telephone
                        i.m06_telephone_ext, -- u17_telephone_ext
                        i.m06_mobile, -- u17_mobile
                        i.m06_email, -- u17_email
                        i.new_emp_dep_id, -- u17_department_id_m12
                        i.m06_employee_no, -- u17_employee_no
                        i.m06_modified_by, -- u17_modified_by_id_u17 | Updated Later from 999 Script
                        i.m06_modified_date, -- u17_modified_date
                        i.status_changed_by, -- u17_status_changed_by_u17 | Updated Later from 999 Script
                        i.status_changed_date, -- u17_status_changed_date
                        i.m04_password_history, -- u17_history_passwords
                        i.m04_client_version, -- u17_client_version
                        i.m06_trading_enabled, -- u17_trading_enabled
                        i.emp_full_name, -- u17_full_name_saudi
                        NULL, -- u17_location_id_m07
                        '1', -- u17_custom_type
                        NULL, -- u17_dealer_cmsn_grp_id_m162 | Updating in the Post Migration Script
                        0, -- u17_authentication_type
                        i.m06_id, -- u17_external_ref
                        i.m06_user_category -- u17_user_category
                                           );

                INSERT INTO u17_employee_mappings
                     VALUES (i.m06_id, l_employee_id);
            ELSE
                UPDATE dfn_ntp.u17_employee
                   SET u17_institution_id_m02 = i.new_institute_id, -- u17_institution_id_m02
                       u17_full_name = i.emp_full_name, -- u17_full_name
                       u17_login_name = i.m04_login_name, -- u17_login_name
                       u17_password = i.m04_login_pw, -- u17_password
                       u17_failed_attempts = i.m04_failed_attempts, -- u17_failed_attempts
                       u17_status_id_v01 = i.map01_ntp_id, -- u17_status_id_v01
                       u17_login_status = i.m04_status, -- u17_login_status
                       u17_type_id_m11 = i.employee_type, -- u17_type_id_m11
                       u17_price_login_name = i.m06_price_username, -- u17_price_login_name
                       u17_price_password = i.m06_price_password, -- u17_price_password
                       u17_pw_expire_date = i.m04_expiray_date, -- u17_pw_expire_date
                       u17_last_login_date = i.m04_last_loggedin_date, -- u17_last_login_date
                       u17_telephone = i.m06_telephone, -- u17_telephone
                       u17_telephone_ext = i.m06_telephone_ext, -- u17_telephone_ext
                       u17_mobile = i.m06_mobile, -- u17_mobile
                       u17_email = i.m06_email, -- u17_email
                       u17_department_id_m12 = i.new_emp_dep_id, -- u17_department_id_m12
                       u17_employee_no = i.m06_employee_no, -- u17_employee_no
                       u17_modified_by_id_u17 = NVL (i.m06_modified_by, 0), -- u17_modified_by_id_u17 | Updated Later from 999 Script
                       u17_modified_date = NVL (i.m06_modified_date, SYSDATE), -- u17_modified_date
                       u17_status_changed_by_u17 = i.status_changed_by, -- u17_status_changed_by_u17 | Updated Later from 999 Script
                       u17_status_changed_date = i.status_changed_date, -- u17_status_changed_date
                       u17_history_passwords = i.m04_password_history, -- u17_history_passwords
                       u17_client_version = i.m04_client_version, -- u17_client_version
                       u17_trading_enabled = i.m06_trading_enabled, -- u17_trading_enabled
                       u17_full_name_saudi = i.emp_full_name, -- u17_full_name_saudi
                       u17_external_ref = i.m06_id, -- u17_external_ref
                       u17_user_category = i.m06_user_category -- u17_user_category
                 WHERE u17_id = i.new_employee_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U17_EMPLOYEE',
                                i.m06_id,
                                CASE
                                    WHEN i.new_employee_id IS NULL
                                    THEN
                                        l_employee_id
                                    ELSE
                                        i.new_employee_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_employee_id IS NULL
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
