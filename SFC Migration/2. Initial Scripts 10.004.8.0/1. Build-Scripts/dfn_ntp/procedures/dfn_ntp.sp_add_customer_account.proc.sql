CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_customer_account (
    p_key                            OUT NUMBER,
    p_u01_id                         OUT NUMBER,
    p_u01_customer_no                OUT u01_customer.u01_customer_no%TYPE,
    p_u09_id                         OUT u09_customer_login.u09_id%TYPE,
    p_u05_id_no                   IN     u05_customer_identification.u05_id_no%TYPE,
    p_u01_external_ref_no         IN     u01_customer.u01_external_ref_no%TYPE,
    p_institution_id              IN     u01_customer.u01_institute_id_m02%TYPE,
    p_u01_first_name              IN     u01_customer.u01_first_name%TYPE,
    p_u01_last_name               IN     u01_customer.u01_last_name%TYPE,
    p_u09_is_first_time           IN     u09_customer_login.u09_is_first_time%TYPE,
    p_u02_mobile                  IN     u02_customer_contact_info.u02_mobile%TYPE,
    p_u02_address_line1           IN     u02_customer_contact_info.u02_address_line1%TYPE,
    p_u02_address_line2           IN     u02_customer_contact_info.u02_address_line2%TYPE,
    p_u02_zip_code                IN     u02_customer_contact_info.u02_zip_code%TYPE,
    p_country_code                IN     m05_country.m05_code%TYPE,
    p_u02_city                    IN     VARCHAR,
    p_u01_gender                  IN     VARCHAR,
    p_u01_title                   IN     VARCHAR,
    p_u01_date_of_birth           IN     u01_customer.u01_date_of_birth%TYPE,
    p_user_id                     IN     u01_customer.u01_created_by_id_u17%TYPE,
    p_is_ipo_customer             IN     u01_customer.u01_is_ipo_customer%TYPE,
    p_nationality                 IN     u01_customer.u01_nationality_id_m05%TYPE,
    p_u05_issue_location_id_m14   IN     u05_customer_identification.u05_issue_location_id_m14%TYPE)
IS
    l_sysid              VARCHAR2 (50);
    l_error_reason       NVARCHAR2 (4000);
    l_u05_id             NUMBER;
    l_u02_id             NUMBER;
    l_u01_title_id_v01   NUMBER;
    l_u02_city_id_m06    NUMBER;
    l_count              NUMBER;
BEGIN
    dfn_ntp.generatenewmubasherno (mubasherno => p_u01_customer_no);

    p_u01_id := fn_get_next_sequnce (pseq_name => 'U01_CUSTOMER');
    p_u09_id := fn_get_next_sequnce (pseq_name => 'U09_CUSTOMER_LOGIN');
    l_u05_id :=
        fn_get_next_sequnce (pseq_name => 'U05_CUSTOMER_IDENTIFICATION');
    l_u02_id := fn_get_next_sequnce (pseq_name => 'U02_CUSTOMER_CONTACT_INFO');

    INSERT INTO u01_customer (u01_id,
                              u01_customer_no,
                              u01_nationality_id_m05,
                              u01_created_by_id_u17,
                              u01_created_date,
                              u01_external_ref_no,
                              u01_default_id_no,
                              u01_institute_id_m02,
                              u01_account_category_id_v01,
                              u01_status_id_v01,
                              u01_status_changed_by_id_u17,
                              u01_status_changed_date,
                              u01_is_ipo_customer,
                              u01_is_black_listed,
                              u01_first_name,
                              u01_first_name_lang,
                              u01_last_name,
                              u01_last_name_lang,
                              u01_trading_enabled,
                              u01_online_trading_enabled,
                              u01_date_of_birth,
                              u01_title_id_v01,
                              u01_gender,
                              u01_default_id_type_m15,
                              u01_display_name,
                              u01_display_name_lang,
                              u01_account_type_id_v01)
         VALUES (
                    p_u01_id,                                         --u01_id
                    p_u01_customer_no,                       --u01_customer_no
                    p_nationality,                    --u01_nationality_id_m05
                    p_user_id,                         --u01_created_by_id_u17
                    SYSDATE,                                --u01_created_date
                    p_u01_external_ref_no,               --u01_external_ref_no
                    p_u05_id_no,                          -- u01_default_id_no
                    p_institution_id,                       --p_institution_id
                    1,                           --U01_ACCOUNT_CATEGORY_ID_V01
                    2,                                     --u01_status_id_v01
                    p_user_id,                         --m01_status_changed_by
                    SYSDATE,                         --m01_status_changed_date
                    p_is_ipo_customer,                   --u01_is_ipo_customer
                    0,
                    p_u01_first_name,
                    p_u01_first_name,                                  -- lang
                    p_u01_last_name,                           --u01_last_name
                    p_u01_last_name,                             -- last lang,
                    1,                                   --u01_trading_enabled
                    1,                           -- u01_online_trading_enabled
                    p_u01_date_of_birth,
                    NVL (p_u01_title, 1),                             -- title
                    CASE
                        WHEN SUBSTR (p_u01_gender, 0, 1) = '1' THEN 'M'
                        WHEN SUBSTR (p_u01_gender, 0, 1) = '0' THEN 'F'
                        ELSE SUBSTR (p_u01_gender, 0, 1)
                    END,
                    1,                              -- TODO hardcoding id type
                    p_u01_first_name || ' ' || p_u01_last_name, -- u01_display_name
                    p_u01_first_name || ' ' || p_u01_last_name, -- u01_display_name_lang
                    2                           -- TODO hardcoding Sub account
                     );

    ------------------ create id detail  ---------------------------
    INSERT INTO u05_customer_identification (u05_id,
                                             u05_identity_type_id_m15,
                                             u05_customer_id_u01,
                                             u05_id_no,
                                             u05_issue_date,
                                             u05_issue_location_id_m14,
                                             u05_expiry_date,
                                             u05_is_default,
                                             u05_created_date,
                                             u05_created_by_id_u17,
                                             u05_custom_type)
         VALUES (l_u05_id,
                 1,                                 -- TODO hardcoding id type
                 p_u01_id,
                 p_u05_id_no,
                 TRUNC (SYSDATE),
                 p_u05_issue_location_id_m14,
                 TRUNC (SYSDATE),
                 1,
                 SYSDATE,
                 p_user_id,
                 1);

    ------------- create customer info ----------------------------
    INSERT INTO u02_customer_contact_info (u02_id,
                                           u02_customer_id_u01,
                                           u02_is_default,
                                           u02_mobile,
                                           u02_zip_code,
                                           u02_address_line1,
                                           u02_address_line2,
                                           u02_city_id_m06,
                                           u02_country_id_m05,
                                           u02_status_id_v01,
                                           u02_created_by_id_u17,
                                           u02_created_date,
                                           u02_status_changed_by_id_u17,
                                           u02_status_changed_date,
                                           u02_custom_type)
         VALUES (l_u02_id,
                 p_u01_id,
                 1,
                 p_u02_mobile,
                 p_u02_zip_code,
                 p_u02_address_line1,
                 p_u02_address_line2,
                 l_u02_city_id_m06,
                 p_nationality,
                 2,
                 p_user_id,
                 SYSDATE,
                 p_user_id,
                 SYSDATE,
                 1);

    ------------- create login detail ----------------------------
    INSERT INTO u09_customer_login (u09_id,
                                    u09_customer_id_u01,
                                    u09_login_name,
                                    u09_login_password,
                                    u09_failed_attempts,
                                    u09_login_status_id_v01,
                                    u09_login_auth_type_id_v01,
                                    u09_trans_auth_type_id_v01,
                                    u09_password_expiry_date,
                                    u09_change_pwd_at_next_login,
                                    u09_auto_trading_acc,
                                    u09_created_by_id_u17,
                                    u09_created_date,
                                    u09_status_id_v01,
                                    u09_status_changed_by_id_u17,
                                    u09_status_changed_date,
                                    u09_custom_type,
                                    u09_institute_id_m02)
         VALUES (
                    p_u09_id,                                    --    u09_id,
                    p_u01_id,                         --  u09_customer_id_u01,
                    p_u01_customer_no,                    --   u09_login_name,
                    'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', -- 123  u09_login_password,
                    0,                           --       u09_failed_attempts,
                    1,                  -- active     u09_login_status_id_v01,
                    1,            -- password      u09_login_auth_type_id_v01,
                    1,           -- no password    u09_trans_auth_type_id_v01,
                    ADD_MONTHS (SYSDATE, 5),     --  u09_password_expiry_date,
                    1,                      --   u09_change_pwd_at_next_login,
                    1,                              --   u09_auto_trading_acc,
                    p_user_id,                      --  u09_created_by_id_u17,
                    SYSDATE,                              -- u09_created_date,
                    2,                                   -- u09_status_id_v01,
                    p_user_id,            --     u09_status_changed_by_id_u17,
                    SYSDATE,                      --  u09_status_changed_date,
                    1,                                   --   u09_custom_type,
                    p_institution_id                 --   u09_institute_id_m02
                                    );

    p_key := p_u01_id;
END;
/
