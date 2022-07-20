DECLARE
    l_customer_id   NUMBER;
    l_sqlerrm       VARCHAR2 (4000);
    l_use_new_key   NUMBER;
    l_rec_cnt       NUMBER := 0;
BEGIN
    SELECT NVL (MAX (u01_id), 0) INTO l_customer_id FROM dfn_ntp.u01_customer;

    DELETE FROM error_log
          WHERE mig_table = 'U01_CUSTOMER';

    l_use_new_key := fn_use_new_key ('U01_CUSTOMER');

    FOR i
        IN (  SELECT m01_customer_id,
                     m01.m01_c1_customer_id,
                     m02_map.new_institute_id,
                     CASE
                         WHEN m01.m01_account_category = 0 THEN 1 -- Individual
                         WHEN m01.m01_account_category = 1 THEN 3 -- Both
                         WHEN m01.m01_account_category = 2 THEN 2 -- Corporate
                     END
                         AS account_category,
                     NVL (m01.m01_c1_other_names, '') AS first_name, -- For All Customers
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             NVL (TO_CHAR (m01.m01_c1_arabic_first_name), -- Individual Customers Use M01_C1_ARABIC_FIRST_NAME as Name
                                  NVL (m01.m01_c1_other_names, ''))
                         ELSE
                             NVL (TO_CHAR (m01.m01_c1_arabic_name), -- Others Use M01_C1_ARABIC_NAME as Name
                                  NVL (m01.m01_c1_other_names, ''))
                     END
                         AS first_name_lang,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             NVL (m01.m01_c1_second_name, '')
                     END
                         AS second_name,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             NVL (TO_CHAR (m01.m01_c1_arabic_second_name),
                                  NVL (m01.m01_c1_second_name, ''))
                     END
                         AS second_name_lang,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             NVL (m01.m01_c1_third_name, '')
                     END
                         AS third_name,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             NVL (TO_CHAR (m01.m01_c1_arabic_third_name),
                                  NVL (m01.m01_c1_third_name, ''))
                     END
                         AS third_name_lang,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             NVL (m01.m01_c1_last_name, '')
                     END
                         AS last_name,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             NVL (TO_CHAR (m01.m01_c1_arabic_name),
                                  NVL (m01.m01_c1_last_name, ''))
                     END
                         AS last_name_lang,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             TRIM (
                                    TRIM (
                                           TRIM (
                                                  NVL (m01.m01_c1_other_names,
                                                       '')
                                               || ' '
                                               || NVL (m01.m01_c1_second_name,
                                                       ''))
                                        || ' '
                                        || NVL (m01.m01_c1_third_name, ''))
                                 || ' '
                                 || NVL (m01.m01_c1_last_name, ''))
                         ELSE
                             NVL (m01.m01_c1_other_names, '')
                     END
                         AS display_name,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             TRIM (
                                    TRIM (
                                           TRIM (
                                                  NVL (
                                                      TO_CHAR (
                                                          m01.m01_c1_arabic_first_name),
                                                      NVL (
                                                          m01.m01_c1_other_names,
                                                          ''))
                                               || ' '
                                               || NVL (
                                                      TO_CHAR (
                                                          m01.m01_c1_arabic_second_name),
                                                      NVL (
                                                          m01.m01_c1_second_name,
                                                          '')))
                                        || ' '
                                        || NVL (
                                               TO_CHAR (
                                                   m01.m01_c1_arabic_third_name),
                                               NVL (m01.m01_c1_third_name, '')))
                                 || ' '
                                 || NVL (TO_CHAR (m01.m01_c1_arabic_name),
                                         NVL (m01.m01_c1_last_name, '')))
                         ELSE
                             NVL (TO_CHAR (m01.m01_c1_arabic_name),
                                  NVL (m01.m01_c1_other_names, ''))
                     END
                         AS display_name_lang,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             CASE
                                 WHEN UPPER (m01_c1_gender) = 'MALE' THEN 'M'
                                 WHEN UPPER (m01_c1_gender) = 'FEMALE' THEN 'F'
                             END
                     END
                         AS gender,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1)
                         THEN
                             map11.map11_ntp_id
                     END
                         AS new_title_id,
                     CASE
                         WHEN m01.m01_marital_status IN (0, 1)
                         THEN
                             map10.map10_ntp_id
                     END
                         AS new_marital_status_id,
                     m01.m01_c1_dob,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             map06.map06_ntp_id
                     END
                         AS new_country_id,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             map07.map07_ntp_id
                     END
                         AS new_birth_city,
                     m243.m243_id_no,
                     map08.map08_ntp_id AS new_default_id_type,
                     DECODE (m01_prefered_language, 'EN', 1, 0)
                         AS preferred_lang_id,
                     m01.m01_ipo_flag,
                     NVL (u17_created_by.new_employee_id, 0)
                         AS created_by_new_id,
                     NVL (m01_created_date, SYSDATE) AS created_date,
                     u17_modified_by.new_employee_id AS modified_by_new_id,
                     m01_modified_date AS modified_date,
                     NVL (u17_status_changed_by.new_employee_id, 0)
                         AS status_changed_by_new_id,
                     NVL (m01_status_changed_date, SYSDATE)
                         AS status_changed_date,
                     map1.map01_ntp_id,
                     m07_map.new_location_id AS new_signup_location,
                     m10_map.new_rm_id,
                     m01.m01_grade,
                     m01.m01_phone_identification_code,
                     m05_national.map06_ntp_id AS new_naitonality_id,
                     m01.m01_trading_enabled,
                     m01.m01_online_trading_enabled,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             TRIM (
                                    TRIM (
                                           TRIM (
                                                  NVL (m01.m01_c1_other_names,
                                                       '')
                                               || ' '
                                               || NVL (m01.m01_c1_second_name,
                                                       ''))
                                        || ' '
                                        || NVL (m01.m01_c1_third_name, ''))
                                 || ' '
                                 || NVL (m01.m01_c1_last_name, ''))
                         ELSE
                             NULL -- No Preffered Name Captured for Corporate Customers
                     END
                         AS preferred_name,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             TRIM (
                                    TRIM (
                                           TRIM (
                                                  NVL (
                                                      TO_CHAR (
                                                          m01.m01_c1_arabic_first_name),
                                                      NVL (
                                                          m01.m01_c1_other_names,
                                                          ''))
                                               || ' '
                                               || NVL (
                                                      TO_CHAR (
                                                          m01.m01_c1_arabic_second_name),
                                                      NVL (
                                                          m01.m01_c1_second_name,
                                                          '')))
                                        || ' '
                                        || NVL (
                                               TO_CHAR (
                                                   m01.m01_c1_arabic_third_name),
                                               NVL (m01.m01_c1_third_name, '')))
                                 || ' '
                                 || NVL (TO_CHAR (m01.m01_c1_arabic_name),
                                         NVL (m01.m01_c1_last_name, '')))
                         ELSE
                             NULL -- No Preffered Name Captured for Corporate Customers
                     END
                         AS preferred_name_lang,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             TRIM (
                                    TRIM (
                                           TRIM (
                                                  NVL (m01.m01_c1_other_names,
                                                       '')
                                               || ' '
                                               || NVL (m01.m01_c1_second_name,
                                                       ''))
                                        || ' '
                                        || NVL (m01.m01_c1_third_name, ''))
                                 || ' '
                                 || NVL (m01.m01_c1_last_name, ''))
                         ELSE
                             NVL (m01.m01_c1_other_names, '')
                     END
                         AS full_name,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             TRIM (
                                    TRIM (
                                           TRIM (
                                                  NVL (
                                                      TO_CHAR (
                                                          m01.m01_c1_arabic_first_name),
                                                      NVL (
                                                          m01.m01_c1_other_names,
                                                          ''))
                                               || ' '
                                               || NVL (
                                                      TO_CHAR (
                                                          m01.m01_c1_arabic_second_name),
                                                      NVL (
                                                          m01.m01_c1_second_name,
                                                          '')))
                                        || ' '
                                        || NVL (
                                               TO_CHAR (
                                                   m01.m01_c1_arabic_third_name),
                                               NVL (m01.m01_c1_third_name, '')))
                                 || ' '
                                 || NVL (TO_CHAR (m01.m01_c1_arabic_name),
                                         NVL (m01.m01_c1_last_name, '')))
                         ELSE
                             NVL (TO_CHAR (m01.m01_c1_arabic_name),
                                  NVL (m01.m01_c1_other_names, ''))
                     END
                         AS full_name_lang,
                     CASE
                         WHEN m01_acc_category IN (1, 4) THEN 2 -- Sub & Fully Disclosed
                         WHEN m01_acc_category = 3 THEN 1 -- Master
                     END
                         AS new_account_type_id,
                     m01.m01_parent_ac_id,
                     CASE
                         WHEN m01.m01_account_category IN (1, 2)
                         THEN
                             CASE
                                 WHEN m01.m01_client_type = 2 THEN 1
                                 WHEN m01.m01_client_type = 3 THEN 2
                                 WHEN m01.m01_client_type = 4 THEN 3
                             END
                     END
                         AS corp_client_type_id,
                     m01.m01_ca_typeof_business,
                     NVL (m01.m01_ca_date_incorporation, SYSDATE)
                         AS corp_date_incorporation,
                     CASE
                         WHEN m01.m01_account_category IN (1, 2)
                         THEN
                             m05_national.map06_ntp_id
                     END
                         AS new_corp_country_id,
                     m01.m01_annual_turnover,
                     m01.m01_region_id, -- [SAME IDs]
                     m01.m01_no_of_employees,
                     m01.m01_paidup_capital,
                     CASE
                         WHEN m01.m01_account_category IN (0, 1) -- Only for Individual Customers
                         THEN
                             m01.m01_minor_account
                     END
                         AS minor_account,
                     m01.m01_guardian_id,
                     NVL (m01.m01_signup_date, SYSDATE) AS sigup_date,
                     m01.m01_is_qi,
                     NVL (m01.m01_vat_waive_off, 0) AS vat_waive_off,
                     m01.m01_tax_ref,
                     m01.m01_is_institutional_client,
                     m01.m01_c1_mobile,
                     m01.m01_c1_email,
                     m01.m01_agent_type, -- [SAME IDs]
                     m01.m01_agent_code,
                     u01_map.new_customer_id,
                     m01.m01_external_ref_no,
                     m01_primary_investor_no,
                     NVL (m01.m01_block_status, 2) AS block_status, -- [2 : Debit Block]
                     NVL (map17.map17_ntp_id, 0) AS map17_ntp_id, -- Default (0 - Standard)
                     m01.m01_customer_type
                FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                     map01_approval_status_v01 map1,
                     mubasher_oms.m243_customer_identifications@mubasher_db_link m243,
                     map08_identity_type_m15 map08,
                     map11_titles_m130 map11,
                     map10_marital_status_m128 map10,
                     m07_location_mappings m07_map,
                     m10_rm_mappings m10_map,
                     m02_institute_mappings m02_map,
                     map06_country_m05 map06,
                     map07_city_m06 map07,
                     u17_employee_mappings u17_created_by,
                     u17_employee_mappings u17_modified_by,
                     u17_employee_mappings u17_status_changed_by,
                     map06_country_m05 m05_national,
                     map17_customer_category_v01_86 map17,
                     u01_customer_mappings u01_map
               WHERE     m01.m01_status_id = map1.map01_oms_id
                     AND m01.m01_customer_id = m243.m243_customer(+)
                     AND m243.m243_identification_type = map08.map08_oms_id(+)
                     AND m01.m01_title = map11.map11_oms_id(+)
                     AND m01.m01_marital_status = map10.map10_oms_id(+)
                     AND m01.m01_signup_location = m07_map.old_location_id(+)
                     AND m01.m01_relationship_manager = m10_map.old_rm_id(+)
                     AND m01.m01_owner_id = m02_map.old_institute_id
                     AND m01.m01_country_id = map06.map06_oms_id(+)
                     AND m01.m01_city = map07.map07_oms_id(+)
                     AND m01.m01_created_by = u17_created_by.old_employee_id(+)
                     AND m01.m01_modified_by =
                             u17_modified_by.old_employee_id(+)
                     AND m01.m01_status_changed_by =
                             u17_status_changed_by.old_employee_id(+)
                     AND m01.m01_c1_nationality_id =
                             m05_national.map06_oms_id(+)
                     AND m01.m01_commssion_group = map17.map17_oms_id(+)
                     AND m01.m01_customer_id = u01_map.old_customer_id(+)
            ORDER BY m01.m01_customer_id)
    LOOP
        BEGIN
            IF i.new_customer_id IS NULL
            THEN
                l_customer_id :=
                    CASE
                        WHEN l_use_new_key = 0 THEN i.m01_customer_id
                        ELSE l_customer_id + 1
                    END;

                INSERT
                  INTO dfn_ntp.u01_customer (u01_id,
                                             u01_customer_no,
                                             u01_institute_id_m02,
                                             u01_account_category_id_v01,
                                             u01_first_name,
                                             u01_first_name_lang,
                                             u01_second_name,
                                             u01_second_name_lang,
                                             u01_third_name,
                                             u01_third_name_lang,
                                             u01_last_name,
                                             u01_last_name_lang,
                                             u01_display_name,
                                             u01_display_name_lang,
                                             u01_gender,
                                             u01_title_id_v01,
                                             u01_marital_status_id_v01,
                                             u01_date_of_birth,
                                             u01_birth_country_id_m05,
                                             u01_birth_city_id_m06,
                                             u01_default_id_no,
                                             u01_default_id_type_m15,
                                             u01_preferred_lang_id_v01,
                                             u01_is_ipo_customer,
                                             u01_is_black_listed,
                                             u01_created_by_id_u17,
                                             u01_created_date,
                                             u01_status_id_v01,
                                             u01_signup_location_id_m07,
                                             u01_service_location_id_m07,
                                             u01_relationship_mngr_id_m10,
                                             u01_grade,
                                             u01_black_listed_reason,
                                             u01_identification_code,
                                             u01_modified_by_id_u17,
                                             u01_modified_date,
                                             u01_status_changed_by_id_u17,
                                             u01_status_changed_date,
                                             u01_nationality_id_m05,
                                             u01_trading_enabled,
                                             u01_online_trading_enabled,
                                             u01_preferred_name,
                                             u01_preferred_name_lang,
                                             u01_full_name,
                                             u01_full_name_lang,
                                             u01_external_ref_no,
                                             u01_account_type_id_v01,
                                             u01_master_account_id_u01,
                                             u01_corp_client_type_id_v01,
                                             u01_corp_license_renewal_date,
                                             u01_corp_license,
                                             u01_corp_name_address_of_group,
                                             u01_corp_type_of_business,
                                             u01_corp_date_incorporation,
                                             u01_corp_country_id_m05,
                                             u01_corp_annual_turnover,
                                             u01_corp_region_id_m90,
                                             u01_corp_no_of_employees,
                                             u01_corp_regulatory_body,
                                             u01_corp_paid_up_capital,
                                             u01_corp_legal_form,
                                             u01_corp_general_partner,
                                             u01_corp_investors,
                                             u01_minor_account,
                                             u01_poa_available,
                                             u01_guardian_relationship_v01,
                                             u01_guardian_id_u01,
                                             u01_signup_date,
                                             u01_is_qualified_investor,
                                             u01_vat_waive_off,
                                             u01_tax_ref,
                                             u01_custom_type,
                                             u01_swap_master,
                                             u01_status_changed_reason,
                                             u01_ib_id_m21,
                                             u01_subfee_waiveoff_grp_id,
                                             u01_direct_dealing_enabled,
                                             u01_dd_from_date,
                                             u01_dd_to_date,
                                             u01_referral_cash_acc_id_u06,
                                             u01_incentive_group_id_m162,
                                             u01_tila_enable,
                                             u01_is_institutional_client,
                                             u01_def_mobile,
                                             u01_def_email,
                                             u01_agent_type,
                                             u01_agent_code,
                                             u01_dd_reference_no,
                                             u01_is_staff_b,
                                             u01_investor_id,
                                             u01_kyc_next_review,
                                             u01_block_status_b,
                                             u01_category_v01,
                                             u01_customer_type_b,
                                             u01_customer_sub_type_b,
                                             u01_is_staff_member,
                                             u01_batch_id_t80)
                VALUES (l_customer_id, -- u01_id
                        i.m01_c1_customer_id, -- u01_customer_no
                        i.new_institute_id, -- u01_institute_id_m02
                        i.account_category, -- u01_account_category_id_v01
                        i.first_name, -- u01_first_name
                        i.first_name_lang, -- u01_first_name_lang
                        i.second_name, -- u01_second_name
                        i.second_name_lang, -- u01_second_name_lang
                        i.third_name, -- u01_third_name
                        i.third_name_lang, -- u01_third_name_lang
                        i.last_name, -- u01_last_name
                        i.last_name_lang, -- u01_last_name_lang
                        i.display_name, -- u01_display_name
                        i.display_name_lang, -- u01_display_name_lang
                        i.gender, -- u01_gender
                        i.new_title_id, -- u01_title_id_v01
                        i.new_marital_status_id, -- u01_marital_status_id_v01
                        i.m01_c1_dob, -- u01_date_of_birth
                        i.new_country_id, -- u01_birth_country_id_m05
                        i.new_birth_city, -- u01_birth_city_id_m06
                        i.m243_id_no, -- u01_default_id_no
                        i.new_default_id_type, -- u01_default_id_type_m15
                        i.preferred_lang_id, -- u01_preferred_lang_id_v01
                        i.m01_ipo_flag, -- u01_is_ipo_customer
                        0, -- u01_is_black_listed | Not Available
                        i.created_by_new_id, -- u01_created_by_id_u17
                        i.created_date, -- u01_created_date
                        i.map01_ntp_id, -- u01_status_id_v01
                        i.new_signup_location, -- u01_signup_location_id_m07
                        i.new_signup_location, -- u01_service_location_id_m07
                        i.new_rm_id, -- u01_relationship_mngr_id_m10
                        i.m01_grade, -- u01_grade
                        NULL, -- u01_black_listed_reason | Not Available
                        i.m01_phone_identification_code, -- u01_identification_code
                        i.modified_by_new_id, -- u01_modified_by_id_u17
                        i.modified_date, -- u01_modified_date
                        i.status_changed_by_new_id, -- u01_status_changed_by_id_u17
                        i.status_changed_date, -- u01_status_changed_date
                        i.new_naitonality_id, -- u01_nationality_id_m05
                        i.m01_trading_enabled, -- u01_trading_enabled
                        i.m01_online_trading_enabled, -- u01_online_trading_enabled
                        i.preferred_name, -- u01_preferred_name
                        i.preferred_name_lang, --u 01_preferred_name_lang
                        i.full_name, -- u01_full_name
                        i.full_name_lang, -- u01_full_name_lang
                        i.m01_external_ref_no, -- u01_external_ref_no
                        i.new_account_type_id, --u01_account_type_id_v01
                        i.m01_parent_ac_id, -- u01_master_account_id_u01 | Update Later in this Script
                        i.corp_client_type_id, -- u01_corp_client_type_id_v01
                        NULL, -- u01_corp_license_renewal_date | Not Available
                        NULL, -- u01_corp_license | Not Available
                        NULL, -- u01_corp_name_address_of_group | Not Available
                        i.m01_ca_typeof_business, -- u01_corp_type_of_business
                        i.corp_date_incorporation, -- u01_corp_date_incorporation
                        i.new_corp_country_id, -- u01_corp_country_id_m05
                        i.m01_annual_turnover, -- u01_corp_annual_turnover
                        i.m01_region_id, -- u01_corp_region_id_m90
                        i.m01_no_of_employees, -- u01_corp_no_of_employees
                        NULL, -- u01_corp_regulatory_body | Not Available
                        i.m01_paidup_capital, -- u01_corp_paid_up_capital
                        NULL, -- u01_corp_legal_form | Not Available
                        NULL, -- u01_corp_general_partner | Not Available
                        NULL, -- u01_corp_investors | Not Available
                        i.minor_account, -- u01_minor_account
                        NULL, -- u01_poa_available [Will be Updated as 1 or 0 during POA Migration Considering Avialability of POA]
                        5, -- u01_guardian_relationship_v01 | Not Available
                        i.m01_guardian_id, -- u01_guardian_id_u01 | Update Later in this Script
                        i.sigup_date, -- u01_signup_date
                        i.m01_is_qi, -- u01_is_qualified_investor
                        i.vat_waive_off, -- u01_vat_waive_off
                        i.m01_tax_ref, -- u01_tax_ref
                        '1', -- u01_custom_type
                        0, -- u01_swap_master | Not Available
                        NULL, -- u01_status_changed_reason
                        NULL, -- u01_ib_id_m21
                        NULL, -- u01_subfee_waiveoff_grp_id
                        0, -- u01_direct_dealing_enabled | Not Available
                        NULL, -- u01_dd_from_date | Not Available
                        NULL, -- u01_dd_to_date | Not Available
                        NULL, -- u01_referral_cash_acc_id_u06, | Not Available
                        NULL, -- u01_incentive_group_id_m162 | Not Available
                        0, -- u01_tila_enable | Not Available
                        i.m01_is_institutional_client, -- u01_is_institutional_client
                        i.m01_c1_mobile, -- u01_def_mobile
                        i.m01_c1_email, -- u01_def_email
                        i.m01_agent_type, -- u01_agent_type
                        i.m01_agent_code, -- u01_agent_code
                        NULL, -- u01_dd_reference_no | Update Later in this Script
                        0, -- u01_is_staff_b | Not Available
                        i.m01_primary_investor_no, --u01_investor_id
                        NULL, -- u01_kyc_next_review | Update Later in the post migration script
                        i.block_status, -- u01_block_status_b
                        i.map17_ntp_id, -- u01_category_v01
                        i.m01_customer_type, -- u01_customer_type_b
                        NULL, -- u01_customer_sub_type_b | Not Available
                        0, -- u01_is_staff_member | Not Available
                        NULL -- u01_batch_id_t80 | Not Available
                            );

                INSERT INTO u01_customer_mappings
                     VALUES (i.m01_customer_id, l_customer_id);
            ELSE
                UPDATE dfn_ntp.u01_customer
                   SET u01_customer_no = i.m01_c1_customer_id, -- u01_customer_no
                       u01_institute_id_m02 = i.new_institute_id, -- u01_institute_id_m02
                       u01_account_category_id_v01 = i.account_category, -- u01_account_category_id_v01
                       u01_first_name = i.first_name, -- u01_first_name
                       u01_first_name_lang = i.first_name_lang, -- u01_first_name_lang
                       u01_second_name = i.second_name, -- u01_second_name
                       u01_second_name_lang = i.second_name_lang, -- u01_second_name_lang
                       u01_third_name = i.third_name, -- u01_third_name
                       u01_third_name_lang = i.third_name_lang, -- u01_third_name_lang
                       u01_last_name = i.last_name, -- u01_last_name
                       u01_last_name_lang = i.last_name_lang, -- u01_last_name_lang
                       u01_display_name = i.display_name, -- u01_display_name
                       u01_display_name_lang = i.display_name_lang, -- u01_display_name_lang
                       u01_gender = i.gender, -- u01_gender
                       u01_title_id_v01 = i.new_title_id, -- u01_title_id_v01
                       u01_marital_status_id_v01 = i.new_marital_status_id, -- u01_marital_status_id_v01
                       u01_date_of_birth = i.m01_c1_dob, -- u01_date_of_birth
                       u01_birth_country_id_m05 = i.new_country_id, -- u01_birth_country_id_m05
                       u01_birth_city_id_m06 = i.new_birth_city, -- u01_birth_city_id_m06
                       u01_default_id_no = i.m243_id_no, -- u01_default_id_no
                       u01_default_id_type_m15 = i.new_default_id_type, -- u01_default_id_type_m15
                       u01_preferred_lang_id_v01 = i.preferred_lang_id, -- u01_preferred_lang_id_v01
                       u01_is_ipo_customer = i.m01_ipo_flag, -- u01_is_ipo_customer
                       u01_status_id_v01 = i.map01_ntp_id, -- u01_status_id_v01
                       u01_signup_location_id_m07 = i.new_signup_location, -- u01_signup_location_id_m07
                       u01_service_location_id_m07 = i.new_signup_location, -- u01_service_location_id_m07
                       u01_relationship_mngr_id_m10 = i.new_rm_id, -- u01_relationship_mngr_id_m10
                       u01_grade = i.m01_grade, -- u01_grade
                       u01_identification_code =
                           i.m01_phone_identification_code, -- u01_identification_code
                       u01_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- u01_modified_by_id_u17
                       u01_modified_date = NVL (i.modified_date, SYSDATE), -- u01_modified_date
                       u01_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- u01_status_changed_by_id_u17
                       u01_status_changed_date = i.status_changed_date, -- u01_status_changed_date
                       u01_nationality_id_m05 = i.new_naitonality_id, -- u01_nationality_id_m05
                       u01_trading_enabled = i.m01_trading_enabled, -- u01_trading_enabled
                       u01_online_trading_enabled =
                           i.m01_online_trading_enabled, -- u01_online_trading_enabled
                       u01_preferred_name = i.preferred_name, -- u01_preferred_name
                       u01_preferred_name_lang = i.preferred_name_lang, --u 01_preferred_name_lang
                       u01_full_name = i.full_name, -- u01_full_name
                       u01_full_name_lang = i.full_name_lang, -- u01_full_name_lang
                       u01_external_ref_no = i.m01_external_ref_no, -- u01_external_ref_no
                       u01_account_type_id_v01 = i.new_account_type_id, --u01_account_type_id_v01
                       u01_master_account_id_u01 = i.m01_parent_ac_id, -- u01_master_account_id_u01 | Update Later in this Script
                       u01_corp_client_type_id_v01 = i.corp_client_type_id, -- u01_corp_client_type_id_v01
                       u01_corp_type_of_business = i.m01_ca_typeof_business, -- u01_corp_type_of_business
                       u01_corp_date_incorporation = i.corp_date_incorporation, -- u01_corp_date_incorporation
                       u01_corp_country_id_m05 = i.new_corp_country_id, -- u01_corp_country_id_m05
                       u01_corp_annual_turnover = i.m01_annual_turnover, -- u01_corp_annual_turnover
                       u01_corp_region_id_m90 = i.m01_region_id, -- u01_corp_region_id_m90
                       u01_corp_no_of_employees = i.m01_no_of_employees, -- u01_corp_no_of_employees
                       u01_corp_paid_up_capital = i.m01_paidup_capital, -- u01_corp_paid_up_capital
                       u01_minor_account = i.minor_account, -- u01_minor_account
                       u01_guardian_id_u01 = i.m01_guardian_id, -- u01_guardian_id_u01 | Update Later in this Script
                       u01_signup_date = i.sigup_date, -- u01_signup_date
                       u01_is_qualified_investor = i.m01_is_qi, -- u01_is_qualified_investor
                       u01_vat_waive_off = i.vat_waive_off, -- u01_vat_waive_off
                       u01_tax_ref = i.m01_tax_ref, -- u01_tax_ref
                       u01_is_institutional_client =
                           i.m01_is_institutional_client, -- u01_is_institutional_client
                       u01_def_mobile = i.m01_c1_mobile, -- u01_def_mobile
                       u01_def_email = i.m01_c1_email, -- u01_def_email
                       u01_agent_type = i.m01_agent_type, -- u01_agent_type
                       u01_agent_code = i.m01_agent_code, -- u01_agent_code
                       u01_investor_id = i.m01_primary_investor_no, --u01_investor_id
                       u01_block_status_b = i.block_status, -- u01_block_status_b
                       u01_category_v01 = i.map17_ntp_id, -- u01_category_v01
                       u01_customer_type_b = i.m01_customer_type -- u01_customer_type_b
                 WHERE u01_id = i.new_customer_id;
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
                                'U01_CUSTOMER',
                                i.m01_customer_id,
                                CASE
                                    WHEN i.new_customer_id IS NULL
                                    THEN
                                        l_customer_id
                                    ELSE
                                        i.new_customer_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_customer_id IS NULL
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

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('U01_CUSTOMER');
END;
/

BEGIN
    DBMS_STATS.gather_table_stats (
        ownname            => 'DFN_MIG',
        tabname            => 'U01_CUSTOMER_MAPPINGS',
        cascade            => TRUE,
        estimate_percent   => DBMS_STATS.auto_sample_size);
END;
/

-- Updating Parent Customer and Guardian

DECLARE
    l_rec_cnt   NUMBER := 0;
BEGIN
    IF fn_use_new_key ('U01_CUSTOMER') = 1
    THEN
        FOR i
            IN (SELECT u01.u01_id,
                       u01_map_parent.new_customer_id AS parent_customer_id,
                       u01_map_guardian.new_customer_id
                           AS guardian_customer_id
                  FROM dfn_ntp.u01_customer u01,
                       u01_customer_mappings u01_map_parent,
                       u01_customer_mappings u01_map_guardian
                 WHERE     u01.u01_master_account_id_u01 =
                               u01_map_parent.old_customer_id(+)
                       AND u01.u01_guardian_id_u01 =
                               u01_map_guardian.old_customer_id(+))
        LOOP
            UPDATE dfn_ntp.u01_customer u01
               SET u01.u01_master_account_id_u01 = i.parent_customer_id,
                   u01.u01_guardian_id_u01 = i.guardian_customer_id
             WHERE u01.u01_id = i.u01_id;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        END LOOP;
    END IF;
END;
/

-- Updating Direct Dealing for Mobile (2) Trading Channel

DECLARE
    l_rec_cnt   NUMBER := 0;
BEGIN
    FOR i
        IN (SELECT u01_map.new_customer_id, m140.m140_direct_dial_number
              FROM (  SELECT m140_customer_id,
                             MAX (m140_direct_dial_number)
                                 AS m140_direct_dial_number
                        FROM mubasher_oms.m140_customer_trading_channels@mubasher_db_link
                       WHERE     m140_trading_channel = 2
                             AND m140_status_id = 2
                             AND m140_direct_dial_number IS NOT NULL
                    GROUP BY m140_customer_id) m140,
                   u01_customer_mappings u01_map
             WHERE m140.m140_customer_id = u01_map.old_customer_id)
    LOOP
        UPDATE dfn_ntp.u01_customer u01
           SET u01.u01_dd_reference_no = i.m140_direct_dial_number,
               u01.u01_direct_dealing_enabled = 1
         WHERE u01.u01_id = i.new_customer_id;

        l_rec_cnt := l_rec_cnt + 1;

        IF MOD (l_rec_cnt, 25000) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;
END;
/

-- Updating Default Master Data

BEGIN
    FOR i
        IN (SELECT u01.u01_id, u01.u01_institute_id_m02
              FROM dfn_ntp.u01_customer u01, u01_customer_mappings u01_map
             WHERE     u01.u01_id = u01_map.new_customer_id
                   AND u01_map.old_customer_id IN
                           (SELECT m48_value
                              FROM mubasher_oms.m48_sys_para@mubasher_db_link
                             WHERE m48_id = 'DEFAULT_MASTER_ACC_ID'))
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.u01_id
         WHERE     v20.v20_institute_id_m02 = i.u01_institute_id_m02
               AND v20.v20_tag = 'masterAccounts';
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('U01_CUSTOMER');
END;
/
