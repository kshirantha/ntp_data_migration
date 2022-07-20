CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_login
(
    u09_id,
    u09_customer_id_u01,
    u09_login_name,
    u09_login_password,
    u09_mobile_no,
    u09_email,
    u09_failed_attempts,
    u09_login_status_id_v01,
    login_status,
    u09_login_auth_type_id_v01,
    login_auth_type,
    u09_trans_auth_type_id_v01,
    trans_auth_type,
    u09_transaction_password,
    u09_password_expiry_date,
    u09_is_first_time,
    u09_auto_trading_acc,
    u09_price_user_name,
    u09_price_password,
    u09_last_login_date,
    u09_last_login_channel_id_v29,
    channel_name,
    u09_last_otp,
    u09_last_otp_gen_time,
    u09_pw_last_updated_date,
    u09_kyc_ignored_attempts,
    u09_modified_by_id_u17,
    modified_by_full_name,
    u09_modified_date,
    u09_history_passwords,
    u09_created_by_id_u17,
    created_by_full_name,
    u09_created_date,
    u09_status_id_v01,
    status_description,
    status_description_lang,
    u09_status_changed_by_id_u17,
    status_changed_by_full_name,
    u09_status_changed_date,
    u01_institute_id_m02,
    u01_display_name,
    u09_preferred_lang_id_v01,
    u09_change_pwd_at_next_login,
    u09_sub_agreement_type
)
AS
    (SELECT a.u09_id,
            a.u09_customer_id_u01,
            a.u09_login_name,
            a.u09_login_password,
            a.u09_mobile_no,
            a.u09_email,
            a.u09_failed_attempts,
            a.u09_login_status_id_v01,
            CASE a.u09_login_status_id_v01
                WHEN 0 THEN 'Pending'
                WHEN 1 THEN 'Active'
                WHEN 2 THEN 'Locked'
                WHEN 3 THEN 'Suspended'
                WHEN 4 THEN 'Deleted'
            END
                AS login_status,
            a.u09_login_auth_type_id_v01,
            CASE a.u09_login_auth_type_id_v01
                WHEN 1 THEN 'Password'
                WHEN 2 THEN 'Password & OTP'
            END
                AS login_auth_type,
            a.u09_trans_auth_type_id_v01,
            CASE a.u09_trans_auth_type_id_v01
                WHEN 1 THEN 'No Password'
                WHEN 2 THEN 'Password Once'
                WHEN 3 THEN 'Password Each Time'
                WHEN 4 THEN 'USB'
                WHEN 5 THEN 'OTP'
            END
                AS trans_auth_type,
            a.u09_transaction_password,
            a.u09_password_expiry_date,
            a.u09_is_first_time,
            a.u09_auto_trading_acc,
            a.u09_price_user_name,
            a.u09_price_password,
            a.u09_last_login_date,
            a.u09_last_login_channel_id_v29,
            v29.v29_description AS channel_name,
            a.u09_last_otp,
            a.u09_last_otp_gen_time,
            a.u09_pw_last_updated_date,
            a.u09_kyc_ignored_attempts,
            a.u09_modified_by_id_u17,
            u17_modified_by.u17_full_name AS modified_by_full_name,
            a.u09_modified_date,
            a.u09_history_passwords,
            a.u09_created_by_id_u17,
            u17_created_by.u17_full_name AS created_by_full_name,
            a.u09_created_date,
            a.u09_status_id_v01,
            status_list.v01_description AS status_description,
            status_list.v01_description_lang AS status_description_lang,
            a.u09_status_changed_by_id_u17,
            u17_status_changed_by.u17_full_name
                AS status_changed_by_full_name,
            a.u09_status_changed_date,
            u01_institute_id_m02,
            u01_display_name,
            a.u09_preferred_lang_id_v01,
            a.u09_change_pwd_at_next_login,
            a.u09_sub_agreement_type
       FROM u09_customer_login a
            LEFT JOIN u01_customer
                ON u01_customer.u01_id = a.u09_customer_id_u01
            LEFT JOIN v29_order_channel v29
                ON v29.v29_id = a.u09_last_login_channel_id_v29
            LEFT JOIN u17_employee u17_created_by
                ON u17_created_by.u17_id = a.u09_created_by_id_u17
            LEFT JOIN u17_employee u17_status_changed_by
                ON u17_status_changed_by.u17_id =
                       a.u09_status_changed_by_id_u17
            LEFT JOIN u17_employee u17_modified_by
                ON u17_modified_by.u17_id = a.u09_modified_by_id_u17
            LEFT JOIN vw_status_list status_list
                ON a.u09_status_id_v01 = status_list.v01_id)
/