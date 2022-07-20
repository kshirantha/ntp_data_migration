CREATE OR REPLACE 
PROCEDURE dfn_ntp.sp_update_authentication (p_login_name             IN VARCHAR2,  --1
                                    p_password               IN VARCHAR2,  --2
                                    p_auth_status            IN NUMBER,    --3
                                    p_new_session            IN NUMBER,    --4
                                    p_channel_id             IN NUMBER,    --5
                                    p_login_id               IN NUMBER,    --6
                                    p_user_id                IN NUMBER,    --7
                                    p_institute_id           IN NUMBER,    --8
                                    p_user_type              IN NUMBER,    --9
                                    p_session_token          IN VARCHAR2, --10
                                    p_client_ip              IN VARCHAR2, --11
                                    p_login_time             IN TIMESTAMP, --12
                                    p_last_updated_time      IN TIMESTAMP, --13
                                    p_expiry_time            IN TIMESTAMP, --14
                                    p_login_date             IN DATE,     --15
                                    p_last_updated_date      IN DATE,     --16
                                    p_persist_otp            IN NUMBER,   --17
                                    p_otp                    IN VARCHAR2, --18
                                    p_otp_gen_time           IN TIMESTAMP, --19
                                    p_failed_attempts        IN NUMBER,   --20
                                    pre_failed_attempts      IN NUMBER,   --21
                                    p_allowed_attempts       IN NUMBER,   --22
                                    p_narration              IN VARCHAR2, --23
                                    p_com_version            IN VARCHAR2, --24
                                    p_app_server_id          IN NUMBER,   --25
                                    p_kyc_ignored_attempts   IN NUMBER,   --26
                                    p_persist_history        IN NUMBER,   --27
									p_operating_system       IN VARCHAR2,  --28
                                    p_location               IN VARCHAR2, --29
                                    p_browser                IN VARCHAR2) --30

IS
    pre_session_id         VARCHAR2 (60);
    pre_channel_id_v29     NUMBER (5);
    pre_auth_status        NUMBER (3);
    pre_login_time         TIMESTAMP;
    pre_last_updated       TIMESTAMP;
    pre_ip                 VARCHAR2 (20);
    pre_expiry_time        TIMESTAMP;
    pre_entity_id          NUMBER (7);
    pre_entity_type        NUMBER (2);
    pre_institute_id_m02   NUMBER (3);
    pre_login_date         DATE;
    pre_last_upd_date      DATE;
    pre_operating_system   VARCHAR2 (60);
    pre_location           VARCHAR2 (60);
    pre_browser            VARCHAR2 (60);
BEGIN
    IF (NOT (p_auth_status = 0                       --USER_PASSWORD_INCORRECT
                              OR p_auth_status = 3))          --ACCOUNT_LOCKED
    THEN                                       --Insert or Update Session Info
        IF (p_new_session = 1)                            --Insert New Session
        THEN
            INSERT INTO u46_user_sessions (u46_session_id,
                                           u46_channel_id_v29,
                                           u46_auth_status,
                                           u46_login_time,
                                           u46_last_updated,
                                           u46_expiry_time,
                                           u46_ip,
                                           u46_entity_id,
                                           u46_entity_type,
                                           u46_institute_id_m02,
                                           u46_login_date,
                                           u46_last_upd_date,
                                           u46_login_id_u09,
										   u46_operating_system,
                                           u46_location,
                                           u46_browser)
                 VALUES (p_session_token,
                         p_channel_id,
                         p_auth_status,
                         p_login_time,
                         p_last_updated_time,
                         p_expiry_time,
                         p_client_ip,
                         p_user_id,
                         p_user_type,
                         p_institute_id,
                         p_login_date,
                         p_last_updated_date,
                         p_login_id,
						 p_operating_system,
                         p_location,
                         p_browser);
        ELSE                  --Update Session Details with new Authentication
            IF (p_user_type = 2)                          --USER_TYPE_EMPLOYEE
            THEN
                SELECT u46_session_id,            --Load Previous Session Data
                       u46_channel_id_v29,
                       u46_auth_status,
                       u46_login_time,
                       u46_last_updated,
                       u46_ip,
                       u46_expiry_time,
                       u46_entity_id,
                       u46_entity_type,
                       u46_institute_id_m02,
                       u46_login_date,
                       u46_last_upd_date,
                       u46_operating_system,
                       u46_location,
                       u46_browser
                  INTO pre_session_id,
                       pre_channel_id_v29,
                       pre_auth_status,
                       pre_login_time,
                       pre_last_updated,
                       pre_ip,
                       pre_expiry_time,
                       pre_entity_id,
                       pre_entity_type,
                       pre_institute_id_m02,
                       pre_login_date,
                       pre_last_upd_date,
                       pre_operating_system,
                       pre_location,
                       pre_browser
                  FROM u46_user_sessions
                 WHERE     u46_login_id_u09 = p_login_id
                       AND u46_entity_type = p_user_type
                       AND u46_channel_id_v29 = p_channel_id;

                UPDATE u46_user_sessions              --Update Current Session
                   SET u46_session_id = p_session_token,                    
                       u46_auth_status = p_auth_status,
                       u46_login_time = p_login_time,
                       u46_last_updated = p_last_updated_time,
                       u46_expiry_time = p_expiry_time,
                       u46_ip = p_client_ip,
                       u46_login_date = p_login_date,
                       u46_last_upd_date = p_last_updated_date,
                       u46_operating_system = p_operating_system,
                       u46_location = p_location,
                       u46_browser = p_browser
                 WHERE     u46_login_id_u09 = p_login_id
                       AND u46_entity_type = p_user_type
                       AND u46_channel_id_v29 = p_channel_id;
            ELSE                                          --USER_TYPE_CUSTOMER
                SELECT u46_session_id,            --Load Previous Session Data
                       u46_channel_id_v29,
                       u46_auth_status,
                       u46_login_time,
                       u46_last_updated,
                       u46_ip,
                       u46_expiry_time,
                       u46_entity_id,
                       u46_entity_type,
                       u46_institute_id_m02,
                       u46_login_date,
                       u46_last_upd_date,
                       u46_operating_system,
                       u46_location,
                       u46_browser
                  INTO pre_session_id,
                       pre_channel_id_v29,
                       pre_auth_status,
                       pre_login_time,
                       pre_last_updated,
                       pre_ip,
                       pre_expiry_time,
                       pre_entity_id,
                       pre_entity_type,
                       pre_institute_id_m02,
                       pre_login_date,
                       pre_last_upd_date,
                       pre_operating_system,
                       pre_location,
                       pre_browser
                  FROM u46_user_sessions
                 WHERE     u46_login_id_u09 = p_login_id
                       AND u46_entity_type = p_user_type;

                UPDATE u46_user_sessions              --Update Current Session
                   SET u46_session_id = p_session_token,
                       u46_channel_id_v29 = p_channel_id,
                       u46_auth_status = p_auth_status,
                       u46_login_time = p_login_time,
                       u46_last_updated = p_last_updated_time,
                       u46_expiry_time = p_expiry_time,
                       u46_ip = p_client_ip,
                       u46_login_date = p_login_date,
                       u46_last_upd_date = p_last_updated_date,
                       u46_operating_system = p_operating_system,
                       u46_location = p_location,
                       u46_browser = p_browser
                 WHERE     u46_login_id_u09 = p_login_id
                       AND u46_entity_type = p_user_type;
            END IF;

            IF (p_persist_history = 1)     --Move Old session to History Table
            THEN
                INSERT INTO h07_user_sessions (h07_session_id,
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
                                               h07_login_date,
                                               h07_last_upd_date,
                                               h07_operating_system,
                                               h07_location,
                                               h07_browser)
                     VALUES (pre_session_id,
                             pre_channel_id_v29,
                             p_login_id,
                             pre_auth_status,
                             pre_login_time,
                             pre_last_updated,
                             SYSDATE,
                             pre_ip,
                             pre_expiry_time,
                             pre_entity_id,
                             pre_entity_type,
                             pre_institute_id_m02,
                             TRUNC (pre_login_date),
                             TRUNC (pre_last_upd_date),
                             pre_operating_system,
                             pre_location,
                             pre_browser);
            END IF;
        END IF;

        --Update last login date and customer otp
        IF (p_user_type = 2)                              --USER_TYPE_EMPLOYEE
        THEN
            UPDATE u17_employee
               SET u17_last_login_date = SYSDATE
             WHERE u17_id = p_login_id;
        ELSE                                              --USER_TYPE_CUSTOMER
            IF (p_persist_otp = 1)
            THEN
                UPDATE u09_customer_login
                   SET u09_last_login_date = SYSDATE,
                       u09_kyc_ignored_attempts = p_kyc_ignored_attempts,
                       u09_last_otp = p_otp,
                       u09_last_otp_gen_time = p_otp_gen_time
                 WHERE u09_id = p_login_id;
            ELSE
                UPDATE u09_customer_login
                   SET u09_last_login_date = SYSDATE,
                       u09_kyc_ignored_attempts = p_kyc_ignored_attempts
                 WHERE u09_id = p_login_id;
            END IF;
        END IF;
    END IF;
	
	--Insert Login audit for all authentication scenarios
    INSERT INTO a18_user_login_audit (a18_channel_id_v29,
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
                                      a18_institute_id_m02,
                                      a18_login_date,
									  a18_entity_type)
         VALUES (p_channel_id,
                 p_app_server_id,
                 p_client_ip,
                 p_login_name,
                 p_password,
                 p_com_version,
                 SYSDATE,
                 p_auth_status,
                 p_login_id,
                 p_narration,
                 p_failed_attempts,
                 p_institute_id,
                 TRUNC (SYSDATE),
				 p_user_type);

    --Update Failed attempts for failed authentication and rest Failed Attempts for succesful Authentication
    IF (   (p_auth_status = 1 AND pre_failed_attempts != p_failed_attempts) --SUCCESSFUL
        OR p_auth_status = 0                         --USER_PASSWORD_INCORRECT
        OR p_auth_status = 3                                  --ACCOUNT_LOCKED
        OR p_auth_status = 27                     --FORGOT_PASSWORD_OTP_ENABLE
        OR p_auth_status = 9)                                    --OTP_ENABLED
    THEN
        IF (p_failed_attempts < p_allowed_attempts)
        THEN
            IF (p_user_type = 2)                          --USER_TYPE_EMPLOYEE
            THEN
                UPDATE u17_employee
                   SET u17_failed_attempts = p_failed_attempts
                 WHERE u17_id = p_login_id;
            ELSE
                UPDATE u09_customer_login
                   SET u09_failed_attempts = p_failed_attempts
                 WHERE u09_id = p_login_id;
            END IF;
        ELSE        --Update failed attempts and auth status as ACCOUNT_LOCKED
            IF (p_user_type = 2)                          --USER_TYPE_EMPLOYEE
            THEN
                UPDATE u17_employee
                   SET u17_failed_attempts = p_failed_attempts,
                       u17_login_status = 2                   --ACCOUNT_LOCKED
                 WHERE u17_id = p_login_id;
            ELSE
                UPDATE u09_customer_login
                   SET u09_failed_attempts = p_failed_attempts,
                       u09_login_status_id_v01 = 2            --ACCOUNT_LOCKED
                 WHERE u09_id = p_login_id;
            END IF;
        END IF;
    END IF;
END;
/