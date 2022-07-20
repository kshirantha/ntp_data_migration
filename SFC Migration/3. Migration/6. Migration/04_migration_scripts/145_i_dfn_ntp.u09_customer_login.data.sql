DECLARE
    l_customer_login_id   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
    l_use_new_key         NUMBER;
BEGIN
    SELECT NVL (MAX (u09_id), 0)
      INTO l_customer_login_id
      FROM dfn_ntp.u09_customer_login;

    l_use_new_key := fn_use_new_key ('U09_CUSTOMER_LOGIN');

    DELETE FROM error_log
          WHERE mig_table = 'U09_CUSTOMER_LOGIN';

    FOR i
        IN (SELECT m04.m04_id,
                   u01_map.new_customer_id,
                   UPPER (m04.m04_login_name) AS m04_login_name, -- SFC Requirement
                   m04.m04_login_pw,
                   m01.m01_c1_mobile,
                   m01.m01_c1_email,
                   m04.m04_failed_attempts,
                   m04.m04_status, -- [SAME IDs]
                   m04.m04_sec_auth_type, -- [SAME IDs]
                   m04.m04_transaction_pw,
                   NVL (m04.m04_pw_expire_date, SYSDATE - 90)
                       AS new_pw_expiry_date,
                   m04.m04_price_user_name,
                   m04.m04_price_password,
                   m04.m04_last_loggedin_date,
                   m04.m04_sms_otp_gen_time,
                   m04.m04_password_history,
                   m04.m04_is_first_time,
                   m02_map.new_institute_id,
                   u09_map.new_customer_login_id,
                   CASE m01.m01_prefered_language
                       WHEN 'EN' THEN 1
                       WHEN 'AR' THEN 2
                   END
                       AS prefered_language,
                   m04.m04_expiray_date,
                   m01.m01_login_id
              FROM mubasher_oms.m04_logins@mubasher_db_link m04,
                   mubasher_oms.m01_customer@mubasher_db_link m01,
                   u01_customer_mappings u01_map,
                   m02_institute_mappings m02_map,
                   u09_customer_login_mappings u09_map
             WHERE     m04.m04_user_type = 0
                   AND m04.m04_id = m01.m01_login_id(+)
                   AND m01.m01_customer_id = u01_map.old_customer_id(+)
                   AND m01.m01_owner_id = m02_map.old_institute_id
                   AND m04.m04_id = u09_map.old_customer_login_id(+))
    LOOP
        BEGIN
            /* [Corrective Actions Discussed]

            IF i.m01_login_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Login ID Not Available',
                                         TRUE);
            END IF;*/

            IF i.new_customer_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.new_customer_login_id IS NULL
            THEN
                l_customer_login_id :=
                    CASE
                        WHEN l_use_new_key = 0 THEN i.m04_id
                        ELSE l_customer_login_id + 1
                    END;

                INSERT
                  INTO dfn_ntp.u09_customer_login (
                           u09_id,
                           u09_customer_id_u01,
                           u09_login_name,
                           u09_login_password,
                           u09_mobile_no,
                           u09_email,
                           u09_failed_attempts,
                           u09_login_status_id_v01,
                           u09_login_auth_type_id_v01,
                           u09_trans_auth_type_id_v01,
                           u09_transaction_password,
                           u09_password_expiry_date,
                           u09_change_pwd_at_next_login,
                           u09_auto_trading_acc,
                           u09_price_user_name,
                           u09_price_password,
                           u09_last_login_date,
                           u09_last_login_channel_id_v29,
                           u09_last_otp,
                           u09_last_otp_gen_time,
                           u09_pw_last_updated_date,
                           u09_kyc_ignored_attempts,
                           u09_modified_by_id_u17,
                           u09_modified_date,
                           u09_history_passwords,
                           u09_created_by_id_u17,
                           u09_created_date,
                           u09_status_id_v01,
                           u09_status_changed_by_id_u17,
                           u09_status_changed_date,
                           u09_is_first_time,
                           u09_custom_type,
                           u09_institute_id_m02,
                           u09_preferred_lang_id_v01,
                           u09_idle_session_time_out,
                           u09_sub_agreement_type)
                VALUES (l_customer_login_id, -- u09_id
                        i.new_customer_id, -- u09_customer_id_u01
                        i.m04_login_name, -- u09_login_name
                        i.m04_login_pw, -- u09_login_password
                        i.m01_c1_mobile, -- u09_mobile_no
                        i.m01_c1_email, -- u09_email
                        i.m04_failed_attempts, -- u09_failed_attempts
                        i.m04_status, -- u09_login_status_id_v01
                        1, -- u09_login_auth_type_id_v01
                        i.m04_sec_auth_type, -- u09_trans_auth_type_id_v01
                        i.m04_transaction_pw, -- u09_transaction_password
                        i.new_pw_expiry_date, -- u09_password_expiry_date
                        0, -- u09_change_pwd_at_next_login
                        0, -- u09_auto_trading_acc
                        i.m04_price_user_name, -- u09_price_user_name
                        i.m04_price_password, -- u09_price_password
                        i.m04_last_loggedin_date, -- u09_last_login_date
                        0, -- u09_last_login_channel_id_v29 | Updating in Post Migration Script
                        NULL, -- u09_last_otp
                        i.m04_sms_otp_gen_time, -- u09_last_otp_gen_time
                        NULL, -- u09_pw_last_updated_date
                        NULL, -- u09_kyc_ignored_attempts
                        NULL, -- u09_modified_by_id_u17
                        SYSDATE, -- u09_modified_date
                        i.m04_password_history, -- u09_history_passwords
                        0, -- u09_created_by_id_u17
                        SYSDATE, -- u09_created_date
                        2, -- u09_status_id_v01
                        0, -- u09_status_changed_by_id_u17
                        SYSDATE, -- u09_status_changed_date
                        i.m04_is_first_time, -- u09_is_first_time
                        '1', -- u06_custom_type
                        i.new_institute_id, -- u09_institute_id_m02
                        i.prefered_language, -- u09_preferred_lang_id_v01
                        15, -- u09_idle_session_time_out | Not Available
                        NULL -- u09_sub_agreement_type | Updated Later from M158 Table Migration
                            );

                INSERT INTO u09_customer_login_mappings
                     VALUES (i.m04_id, l_customer_login_id);
            ELSE
                UPDATE dfn_ntp.u09_customer_login
                   SET u09_customer_id_u01 = i.new_customer_id, -- u09_customer_id_u01
                       u09_login_name = i.m04_login_name, -- u09_login_name
                       u09_login_password = i.m04_login_pw, -- u09_login_password
                       u09_mobile_no = i.m01_c1_mobile, -- u09_mobile_no
                       u09_email = i.m01_c1_email, -- u09_email
                       u09_failed_attempts = i.m04_failed_attempts, -- u09_failed_attempts
                       u09_login_status_id_v01 = i.m04_status, -- u09_login_status_id_v01
                       u09_trans_auth_type_id_v01 = i.m04_sec_auth_type, -- u09_trans_auth_type_id_v01
                       u09_transaction_password = i.m04_transaction_pw, -- u09_transaction_password
                       u09_password_expiry_date = i.new_pw_expiry_date, -- u09_password_expiry_date
                       u09_price_user_name = i.m04_price_user_name, -- u09_price_user_name
                       u09_price_password = i.m04_price_password, -- u09_price_password
                       u09_last_login_date = i.m04_last_loggedin_date, -- u09_last_login_date
                       u09_last_otp_gen_time = i.m04_sms_otp_gen_time, -- u09_last_otp_gen_time
                       u09_history_passwords = i.m04_password_history, -- u09_history_passwords
                       u09_is_first_time = i.m04_is_first_time, -- u09_is_first_time
                       u09_institute_id_m02 = i.new_institute_id, -- u09_institute_id_m02
                       u09_preferred_lang_id_v01 = i.prefered_language, -- u09_preferred_lang_id_v01
                       u09_modified_by_id_u17 = 0, -- u09_modified_by_id_u17
                       u09_modified_date = SYSDATE -- u09_modified_date
                 WHERE u09_id = i.new_customer_login_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U09_CUSTOMER_LOGIN',
                                i.m04_id,
                                CASE
                                    WHEN i.new_customer_login_id IS NULL
                                    THEN
                                        l_customer_login_id
                                    ELSE
                                        i.new_customer_login_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_customer_login_id IS NULL
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
