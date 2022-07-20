DECLARE
    l_customer_kyc_id        NUMBER;
    l_default_country_code   VARCHAR (100);
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u03_id), 0)
      INTO l_customer_kyc_id
      FROM dfn_ntp.u03_customer_kyc;

    SELECT VALUE
      INTO l_default_country_code
      FROM migration_params
     WHERE code = 'DEFAULT_COUNTRY';

    DELETE FROM error_log
          WHERE mig_table = 'U03_CUSTOMER_KYC';

    FOR i
        IN (  SELECT m01_cma.m01_customer_id,
                     m01_emp_city,
                     u01_map.new_customer_id,
                     m01_cma.m01_emp_date_of_emp,
                     m01_cma.m01_emp_employer_name,
                     m01_cma.m01_emp_p_o_box,
                     map06.map06_ntp_id AS new_country_id,
                     map07.map07_ntp_id AS new_city_id,
                     m01_cma.m01_emp_postal_code,
                     m01_cma.m01_emp_phone_no,
                     m01_cma.m01_emp_email_address,
                     m01_cma.m01_ideal_shares_h,
                     m01_cma.m01_ideal_shares_m,
                     m01_cma.m01_ideal_debit_instru_h,
                     m01_cma.m01_ideal_debit_instru_m,
                     m01_cma.m01_ideal_debit_instru_l,
                     m01_cma.m01_ideal_invest_funds_h,
                     m01_cma.m01_ideal_invest_funds_m,
                     m01_cma.m01_ideal_invest_funds_l,
                     m01_cma.m01_ideal_trade_fin_l,
                     m01_cma.m01_ideal_commodities_h,
                     m01_cma.m01_ideal_options_h,
                     m01_cma.m01_invest_shares,
                     m01_cma.m01_invest_debit_instru,
                     m01_cma.m01_invest_forign_exchange,
                     m01_cma.m01_invest_deposits,
                     m01_cma.m01_invest_trade_finance,
                     m01_cma.m01_invest_investment_funds,
                     m01_cma.m01_invest_commodities,
                     m01_cma.m01_invest_derivatives_options,
                     m01_cma.m01_invest_real_estate,
                     m01_cma.m01_invest_know_exp,
                     m01_cma.m01_invest_profile,
                     m01_cma.m01_invest_client_clasific,
                     m01_cma.m01_invest_gen_invest_object,
                     m01_cma.m01_invest_pref_invest_assets,
                     m01_cma.m01_invest_forign_currencies,
                     m01_cma.m01_atc_contact_name,
                     m01_cma.m01_atc_address_l1,
                     m01_cma.m01_atc_address_l2,
                     m01_cma.m01_atc_business_phone,
                     m01_cma.m01_atc_business_fax,
                     m01_cma.m01_atc_mobile_no,
                     m01_cma.m01_atc_custo_name,
                     m01_cma.m01_atc_custo_acc_no,
                     m01_cma.m01_atc_custo_address_l1,
                     m01_cma.m01_atc_custo_address_l2,
                     m01_cma.m01_atc_custo_acc_name,
                     m01_cma.m01_atc_id_exp_date,
                     m01_cma.m01_atc_id_number,
                     m01_cma.m01_other_annual_inc,
                     m01_cma.m01_other_approx_net_sar,
                     m01_cma.m01_other_certificates,
                     m01_cma.m01_other_divid_other_inc,
                     m01_cma.m01_other_inc_add_info,
                     m01_cma.m01_other_monthly_sal,
                     m01_cma.m01_other_next_review,
                     m01_cma.m01_other_pub_listed_comp,
                     m01_cma.m01_other_repaper_date,
                     m01_cma.m01_other_sale_proc,
                     u03_map.new_customer_kyc_id
                FROM mubasher_oms.m01_cma_complient_details@mubasher_db_link m01_cma,
                     u01_customer_mappings u01_map,
                     map06_country_m05 map06,
                     (SELECT map07_ntp_id, UPPER (map07_name) AS map07_name
                        FROM map07_city_m06) map07,
                     u03_customer_kyc_mappings u03_map
               WHERE     TO_NUMBER (m01_cma.m01_customer_id) =
                             u01_map.old_customer_id
                     AND m01_cma.m01_emp_country_id = map06.map06_oms_id(+)
                     AND UPPER (m01_cma.m01_emp_city) = map07.map07_name(+)
                     AND m01_customer_id = u03_map.old_customer_kyc_id(+)
            ORDER BY m01_cma.m01_customer_id)
    LOOP
        BEGIN
            IF i.new_customer_kyc_id IS NULL
            THEN
                l_customer_kyc_id := l_customer_kyc_id + 1;

                INSERT
                  INTO dfn_ntp.u03_customer_kyc (
                           u03_customer_id_u01,
                           u03_emp_date_of_emp,
                           u03_emp_employer_name,
                           u03_emp_po_box,
                           u03_emp_country_id_m05,
                           u03_emp_city_id_m06,
                           u03_emp_zip_code,
                           u03_emp_telephone,
                           u03_emp_email,
                           u03_emp_position_id_m114,
                           u03_emp_title,
                           u03_emp_resign_date,
                           u03_cop_name,
                           u03_cop_comercial_reg_no,
                           u03_cop_comercial_reg_date,
                           u03_cop_address,
                           u03_cop_country_id_m05,
                           u03_cop_bussness_start_date,
                           u03_cop_telephone,
                           u03_cop_mobile,
                           u03_cop_fax,
                           u03_cop_number_of_emp,
                           u03_cop_paid_up_capital,
                           u03_cop_annual_turnover,
                           u03_cop_contact_person_name,
                           u03_cop_address_of_contact,
                           u03_cop_phone_of_contact,
                           u03_cop_fax_of_contact,
                           u03_cop_mobile_of_contact,
                           u03_cop_email_of_contact,
                           u03_ideal_shares_h,
                           u03_ideal_shares_m,
                           u03_ideal_debit_instru_h,
                           u03_ideal_debit_instru_m,
                           u03_ideal_debit_instru_l,
                           u03_ideal_invest_funds_h,
                           u03_ideal_invest_funds_m,
                           u03_ideal_invest_funds_l,
                           u03_ideal_trade_fin_l,
                           u03_ideal_commodities_h,
                           u03_ideal_options_h,
                           u03_invest_shares,
                           u03_invest_debit_instru,
                           u03_invest_forign_exchange,
                           u03_invest_deposits,
                           u03_invest_trade_finance,
                           u03_invest_investment_funds,
                           u03_invest_commodities,
                           u03_invest_derivatives_options,
                           u03_invest_real_estate,
                           u03_invest_know_exp,
                           u03_invest_profile,
                           u03_invest_client_clasific,
                           u03_invest_gen_invest_object,
                           u03_invest_pref_invest_assets,
                           u03_invest_forign_currencies,
                           u03_atc_contact_name,
                           u03_atc_address_l1,
                           u03_atc_address_l2,
                           u03_atc_business_phone,
                           u03_act_home_telephone,
                           u03_atc_business_fax,
                           u03_atc_mobile_no,
                           u03_act_email,
                           u03_act_document_no,
                           u03_act_document_date,
                           u03_act_doc_issue_place,
                           u03_act_relationship,
                           u03_atc_country,
                           u03_ref_name,
                           u03_ref_relationship,
                           u03_ref_pobox,
                           u03_ref_country,
                           u03_ref_area,
                           u03_ref_zip,
                           u03_ref_email,
                           u03_ref_mobile,
                           u03_ref_telephone,
                           u03_ref_work_phone,
                           u03_politically_exposed,
                           u03_politically_exposed_narr,
                           u03_beneficiary_owner,
                           u03_beneficiary_owner_narr,
                           u03_repaper_date,
                           u03_next_review,
                           u03_modified_by_id_u17,
                           u03_modified_date,
                           u03_cra_pep_indicators_m106,
                           u03_cra_customer_group_m106,
                           u03_cra_client_status_m106,
                           u03_cra_legal_status_m106,
                           u03_cra_q1,
                           u03_cra_q2,
                           u03_cra_q3,
                           u03_cra_q4,
                           u03_cra_q5,
                           u03_cra_q6,
                           u03_cra_q7,
                           u03_cra_q8,
                           u03_cra_q9,
                           u03_cra_q10,
                           u03_emp_type_m106,
                           u03_id,
                           u03_atc_custo_acc_name,
                           u03_atc_custo_acc_no,
                           u03_atc_custo_address_l1,
                           u03_atc_custo_address_l2,
                           u03_atc_custo_name,
                           u03_atc_customer_type,
                           u03_atc_id_exp_date,
                           u03_atc_id_issue_date,
                           u03_atc_id_issue_place,
                           u03_atc_id_number,
                           u03_atc_id_type_id_m15,
                           u03_atc_nationality_id_m05,
                           u03_atc_id_expiory_date2,
                           u03_atc_id_issue_date2,
                           u03_atc_id_issue_place2_id_m14,
                           u03_atc_id_number2,
                           u03_atc_id_type2_id_m15,
                           u03_cop_countr,
                           u03_facta_entity_sub_type,
                           u03_fatca_address_indicator,
                           u03_fatca_cntry_residnce,
                           u03_fatca_entity_class,
                           u03_fatca_entity_type,
                           u03_fatca_gin_conf,
                           u03_fatca_gin_number,
                           u03_fatca_institution_id_m02,
                           u03_fatca_other_address,
                           u03_fatca_ownership,
                           u03_fatca_residance,
                           u03_fatca_self_cert_corp,
                           u03_fatca_self_certification,
                           u03_fatca_standing_ord,
                           u03_fatca_status,
                           u03_fatca_taxreference,
                           u03_ideal_total_val,
                           u03_investment_total_value,
                           u03_other_annual_inc,
                           u03_other_approx_net_sar,
                           u03_other_certificates,
                           u03_other_divid_other_inc,
                           u03_other_education,
                           u03_other_file_location,
                           u03_other_inc_add_info,
                           u03_other_monthly_sal,
                           u03_other_nationality_id_m05,
                           u03_other_next_review,
                           u03_other_pub_listed_comp,
                           u03_other_region_area,
                           u03_other_repaper_date,
                           u03_other_sale_proc,
                           u03_ref_city_id_m06,
                           u03_ref_id_expiory_date,
                           u03_ref_id_issue_date,
                           u03_ref_id_issue_place,
                           u03_ref_id_number,
                           u03_ref_id_type_id_m15,
                           u03_ref_id_expiry_date2,
                           u03_ref_id_issue_date2,
                           u03_ref_id_issue_place2_id_m14,
                           u03_ref_id_number2,
                           u03_ref_id_type2_id_m15,
                           u03_risk_client_status,
                           u03_txt_overrall_risk_level,
                           u03_txt_risk_customer_group,
                           u03_txt_risk_legal_status,
                           u03_txt_risk_pep_indicators,
                           u03_txt_risk_q1,
                           u03_txt_risk_q10,
                           u03_txt_risk_q2,
                           u03_txt_risk_q3,
                           u03_txt_risk_q4,
                           u03_txt_risk_q5,
                           u03_txt_risk_q6,
                           u03_txt_risk_q7,
                           u03_txt_risk_q8,
                           u03_txt_risk_q9,
                           u03_custom_type,
                           u03_txt_risk_q11,
                           u03_txt_risk_q12)
                VALUES (i.new_customer_id, -- u03_customer_id_u01
                        i.m01_emp_date_of_emp, -- u03_emp_date_of_emp
                        i.m01_emp_employer_name, -- u03_emp_employer_name
                        i.m01_emp_p_o_box, -- u03_emp_po_box
                        i.new_country_id, -- u03_emp_country_id_m05
                        i.new_city_id, -- u03_emp_city_id_m06
                        i.m01_emp_postal_code, -- u03_emp_zip_code
                        i.m01_emp_phone_no, -- u03_emp_telephone
                        i.m01_emp_email_address, -- u03_emp_email
                        NULL, -- u03_emp_position_id_m114 | Not Available
                        NULL, -- u03_emp_title | Not Available
                        NULL, -- u03_emp_resign_date | Not Available
                        NULL, -- u03_cop_name | Not Available
                        NULL, -- u03_cop_comercial_reg_no | Not Available
                        NULL, -- u03_cop_comercial_reg_date | Not Available
                        NULL, -- u03_cop_address | Not Available
                        NULL, -- u03_cop_country_id_m05 | Not Available
                        NULL, -- u03_cop_bussness_start_date | Not Available
                        NULL, -- u03_cop_telephone | Not Available
                        NULL, -- u03_cop_mobile | Not Available
                        NULL, -- u03_cop_fax | Not Available
                        NULL, -- u03_cop_number_of_emp | Not Available
                        NULL, -- u03_cop_paid_up_capital | Not Available
                        NULL, -- u03_cop_annual_turnover | Not Available
                        NULL, -- u03_cop_contact_person_name | Not Available
                        NULL, -- u03_cop_address_of_contact | Not Available
                        NULL, -- u03_cop_phone_of_contact | Not Available
                        NULL, -- u03_cop_fax_of_contact | Not Available
                        NULL, -- u03_cop_mobile_of_contact | Not Available
                        NULL, -- u03_cop_email_of_contact | Not Available
                        i.m01_ideal_shares_h, -- u03_ideal_shares_h
                        i.m01_ideal_shares_m, -- u03_ideal_shares_m
                        i.m01_ideal_debit_instru_h, -- u03_ideal_debit_instru_h
                        i.m01_ideal_debit_instru_m, -- u03_ideal_debit_instru_m
                        i.m01_ideal_debit_instru_l, -- u03_ideal_debit_instru_l
                        i.m01_ideal_invest_funds_h, -- u03_ideal_invest_funds_h
                        i.m01_ideal_invest_funds_m, -- u03_ideal_invest_funds_m
                        i.m01_ideal_invest_funds_l, -- u03_ideal_invest_funds_l
                        i.m01_ideal_trade_fin_l, -- u03_ideal_trade_fin_l
                        i.m01_ideal_commodities_h, -- u03_ideal_commodities_h
                        i.m01_ideal_options_h, -- u03_ideal_options_h
                        i.m01_invest_shares, -- u03_invest_shares
                        i.m01_invest_debit_instru, -- u03_invest_debit_instru
                        i.m01_invest_forign_exchange, -- u03_invest_forign_exchange
                        i.m01_invest_deposits, -- u03_invest_deposits
                        i.m01_invest_trade_finance, -- u03_invest_trade_finance
                        i.m01_invest_investment_funds, -- u03_invest_investment_funds
                        i.m01_invest_commodities, -- u03_invest_commodities
                        i.m01_invest_derivatives_options, -- u03_invest_derivatives_options
                        i.m01_invest_real_estate, -- u03_invest_real_estate
                        i.m01_invest_know_exp, -- u03_invest_know_exp
                        i.m01_invest_profile, -- u03_invest_profile
                        i.m01_invest_client_clasific, -- u03_invest_client_clasific
                        i.m01_invest_gen_invest_object, -- u03_invest_gen_invest_object
                        i.m01_invest_pref_invest_assets, -- u03_invest_pref_invest_assets
                        i.m01_invest_forign_currencies, -- u03_invest_forign_currencies
                        i.m01_atc_contact_name, -- u03_atc_contact_name
                        i.m01_atc_address_l1, -- u03_atc_address_l1
                        i.m01_atc_address_l2, -- u03_atc_address_l2
                        i.m01_atc_business_phone, -- u03_atc_business_phone
                        NULL, --bu03_act_home_telephone | Not Available
                        i.m01_atc_business_fax, -- u03_atc_business_fax
                        i.m01_atc_mobile_no, -- u03_atc_mobile_no
                        NULL, -- u03_act_email | Not Available
                        NULL, -- u03_act_document_no | Not Available
                        NULL, -- u03_act_document_date | Not Available
                        NULL, -- u03_act_doc_issue_place | Not Available
                        NULL, -- u03_act_relationship | Not Available
                        l_default_country_code, -- u03_atc_country
                        NULL, -- u03_ref_name | Not Available
                        NULL, -- u03_ref_relationship | Not Available
                        NULL, -- u03_ref_pobox | Not Available
                        NULL, -- u03_ref_country | Not Available
                        NULL, -- u03_ref_area | Not Available
                        NULL, -- u03_ref_zip | Not Available
                        NULL, -- u03_ref_email | Not Available
                        NULL, -- u03_ref_mobile | Not Available
                        NULL, -- u03_ref_telephone | Not Available
                        NULL, -- u03_ref_work_phone | Not Available
                        NULL, -- u03_politically_exposed | Not Available
                        NULL, -- u03_politically_exposed_narr | Not Available
                        NULL, -- u03_beneficiary_owner | Not Available
                        NULL, -- u03_beneficiary_owner_narr | Not Available
                        SYSDATE, -- u03_repaper_date
                        SYSDATE, -- u03_next_review
                        NULL, -- u03_modified_by_id_u17 | Not Available
                        NULL, -- u03_modified_date | Not Available
                        NULL, -- u03_cra_pep_indicators_m106
                        NULL, -- u03_cra_customer_group_m106
                        NULL, -- u03_cra_client_status_m106
                        NULL, -- u03_cra_legal_status_m106
                        NULL, -- u03_cra_q1
                        NULL, -- u03_cra_q2
                        NULL, -- u03_cra_q3
                        NULL, -- u03_cra_q4
                        NULL, -- u03_cra_q5
                        NULL, -- u03_cra_q6
                        NULL, -- u03_cra_q7
                        NULL, -- u03_cra_q8
                        NULL, -- u03_cra_q9
                        NULL, -- u03_cra_q10
                        NULL, -- u03_emp_type_m106
                        l_customer_kyc_id, -- u03_id
                        i.m01_atc_custo_name, -- u03_atc_custo_acc_name
                        i.m01_atc_custo_acc_no, -- u03_atc_custo_acc_no
                        i.m01_atc_custo_address_l1, -- u03_atc_custo_address_l1
                        i.m01_atc_custo_address_l2, -- u03_atc_custo_address_l2
                        i.m01_atc_custo_acc_name, -- u03_atc_custo_name
                        NULL, -- u03_atc_customer_type
                        i.m01_atc_id_exp_date, -- u03_atc_id_exp_date
                        SYSDATE, -- u03_atc_id_issue_date
                        NULL, -- u03_atc_id_issue_place
                        i.m01_atc_id_number, -- u03_atc_id_number
                        0, -- u03_atc_id_type_id_m15
                        NULL, -- u03_atc_nationality_id_m05
                        SYSDATE, -- u03_atc_id_expiory_date2
                        SYSDATE, -- u03_atc_id_issue_date2
                        0, -- u03_atc_id_issue_place2_id_m14
                        0, -- u03_atc_id_number2
                        0, -- u03_atc_id_type2_id_m15
                        0, -- u03_cop_countr
                        NULL, -- u03_facta_entity_sub_type
                        NULL, -- u03_fatca_address_indicator
                        NULL, -- u03_fatca_cntry_residnce
                        NULL, -- u03_fatca_entity_class
                        NULL, -- u03_fatca_entity_type
                        NULL, -- u03_fatca_gin_conf
                        NULL, -- u03_fatca_gin_number
                        NULL, -- u03_fatca_institution_id_m02
                        NULL, -- u03_fatca_other_address
                        NULL, -- u03_fatca_ownership
                        NULL, -- u03_fatca_residance
                        NULL, -- u03_fatca_self_cert_corp
                        NULL, -- u03_fatca_self_certification
                        NULL, -- u03_fatca_standing_ord
                        NULL, -- u03_fatca_status
                        NULL, -- u03_fatca_taxreference
                        0, -- u03_ideal_total_val
                        0, -- u03_investment_total_value
                        i.m01_other_annual_inc, -- u03_other_annual_inc
                        i.m01_other_approx_net_sar, -- u03_other_approx_net_sar
                        i.m01_other_certificates, -- u03_other_certificates
                        i.m01_other_divid_other_inc, -- u03_other_divid_other_inc
                        NULL, -- u03_other_education | Not Available
                        NULL, -- u03_other_file_location | Not Available
                        i.m01_other_inc_add_info, -- u03_other_inc_add_info
                        i.m01_other_monthly_sal, -- u03_other_monthly_sal
                        NULL, -- u03_other_nationality_id_m05 | Not Available
                        i.m01_other_next_review, -- u03_other_next_review
                        i.m01_other_pub_listed_comp, -- u03_other_pub_listed_comp
                        NULL, -- u03_other_region_area | Not Available
                        i.m01_other_repaper_date, -- u03_other_repaper_date
                        i.m01_other_sale_proc, -- u03_other_sale_proc
                        NULL, -- u03_ref_city_id_m06 | Not Available
                        SYSDATE, -- u03_ref_id_expiory_date
                        SYSDATE, -- u03_ref_id_issue_date
                        0, -- u03_ref_id_issue_place
                        0, -- u03_ref_id_number
                        0, -- u03_ref_id_type_id_m15
                        SYSDATE, -- u03_ref_id_expiry_date2
                        SYSDATE, -- u03_ref_id_issue_date2
                        0, -- u03_ref_id_issue_place2_id_m14
                        0, -- u03_ref_id_number2
                        0, -- u03_ref_id_type2_id_m15
                        NULL, -- u03_risk_client_status
                        NULL, -- u03_txt_overrall_risk_level
                        0, -- u03_txt_risk_customer_group
                        0, -- u03_txt_risk_legal_status
                        0, -- u03_txt_risk_pep_indicators
                        0, -- u03_txt_risk_q1
                        0, -- u03_txt_risk_q10
                        0, -- u03_txt_risk_q2
                        0, -- u03_txt_risk_q3
                        0, -- u03_txt_risk_q4
                        0, -- u03_txt_risk_q5
                        0, -- u03_txt_risk_q6
                        0, -- u03_txt_risk_q7
                        0, -- u03_txt_risk_q8
                        0, -- u03_txt_risk_q9
                        1, -- u03_custom_type
                        0, -- u03_txt_risk_q11
                        0 -- u03_txt_risk_q12
                         );

                INSERT INTO u03_customer_kyc_mappings
                     VALUES (i.m01_customer_id, l_customer_kyc_id);
            ELSE
                UPDATE dfn_ntp.u03_customer_kyc
                   SET u03_customer_id_u01 = i.new_customer_id, -- u03_customer_id_u01
                       u03_emp_date_of_emp = i.m01_emp_date_of_emp, -- u03_emp_date_of_emp
                       u03_emp_employer_name = i.m01_emp_employer_name, -- u03_emp_employer_name
                       u03_emp_po_box = i.m01_emp_p_o_box, -- u03_emp_po_box
                       u03_emp_country_id_m05 = i.new_country_id, -- u03_emp_country_id_m05
                       u03_emp_city_id_m06 = i.new_city_id, -- u03_emp_city_id_m06
                       u03_emp_zip_code = i.m01_emp_postal_code, -- u03_emp_zip_code
                       u03_emp_telephone = i.m01_emp_phone_no, -- u03_emp_telephone
                       u03_emp_email = i.m01_emp_email_address, -- u03_emp_email
                       u03_ideal_shares_h = i.m01_ideal_shares_h, -- u03_ideal_shares_h
                       u03_ideal_shares_m = i.m01_ideal_shares_m, -- u03_ideal_shares_m
                       u03_ideal_debit_instru_h = i.m01_ideal_debit_instru_h, -- u03_ideal_debit_instru_h
                       u03_ideal_debit_instru_m = i.m01_ideal_debit_instru_m, -- u03_ideal_debit_instru_m
                       u03_ideal_debit_instru_l = i.m01_ideal_debit_instru_l, -- u03_ideal_debit_instru_l
                       u03_ideal_invest_funds_h = i.m01_ideal_invest_funds_h, -- u03_ideal_invest_funds_h
                       u03_ideal_invest_funds_m = i.m01_ideal_invest_funds_m, -- u03_ideal_invest_funds_m
                       u03_ideal_invest_funds_l = i.m01_ideal_invest_funds_l, -- u03_ideal_invest_funds_l
                       u03_ideal_trade_fin_l = i.m01_ideal_trade_fin_l, -- u03_ideal_trade_fin_l
                       u03_ideal_commodities_h = i.m01_ideal_commodities_h, -- u03_ideal_commodities_h
                       u03_ideal_options_h = i.m01_ideal_options_h, -- u03_ideal_options_h
                       u03_invest_shares = i.m01_invest_shares, -- u03_invest_shares
                       u03_invest_debit_instru = i.m01_invest_debit_instru, -- u03_invest_debit_instru
                       u03_invest_forign_exchange =
                           i.m01_invest_forign_exchange, -- u03_invest_forign_exchange
                       u03_invest_deposits = i.m01_invest_deposits, -- u03_invest_deposits
                       u03_invest_trade_finance = i.m01_invest_trade_finance, -- u03_invest_trade_finance
                       u03_invest_investment_funds =
                           i.m01_invest_investment_funds, -- u03_invest_investment_funds
                       u03_invest_commodities = i.m01_invest_commodities, -- u03_invest_commodities
                       u03_invest_derivatives_options =
                           i.m01_invest_derivatives_options, -- u03_invest_derivatives_options
                       u03_invest_real_estate = i.m01_invest_real_estate, -- u03_invest_real_estate
                       u03_invest_know_exp = i.m01_invest_know_exp, -- u03_invest_know_exp
                       u03_invest_profile = i.m01_invest_profile, -- u03_invest_profile
                       u03_invest_client_clasific =
                           i.m01_invest_client_clasific, -- u03_invest_client_clasific
                       u03_invest_gen_invest_object =
                           i.m01_invest_gen_invest_object, -- u03_invest_gen_invest_object
                       u03_invest_pref_invest_assets =
                           i.m01_invest_pref_invest_assets, -- u03_invest_pref_invest_assets
                       u03_invest_forign_currencies =
                           i.m01_invest_forign_currencies, -- u03_invest_forign_currencies
                       u03_atc_contact_name = i.m01_atc_contact_name, -- u03_atc_contact_name
                       u03_atc_address_l1 = i.m01_atc_address_l1, -- u03_atc_address_l1
                       u03_atc_address_l2 = i.m01_atc_address_l2, -- u03_atc_address_l2
                       u03_atc_business_phone = i.m01_atc_business_phone, -- u03_atc_business_phone
                       u03_atc_business_fax = i.m01_atc_business_fax, -- u03_atc_business_fax
                       u03_atc_mobile_no = i.m01_atc_mobile_no, -- u03_atc_mobile_no
                       u03_atc_custo_acc_name = i.m01_atc_custo_name, -- u03_atc_custo_acc_name
                       u03_atc_custo_acc_no = i.m01_atc_custo_acc_no, -- u03_atc_custo_acc_no
                       u03_atc_custo_address_l1 = i.m01_atc_custo_address_l1, -- u03_atc_custo_address_l1
                       u03_atc_custo_address_l2 = i.m01_atc_custo_address_l2, -- u03_atc_custo_address_l2
                       u03_atc_custo_name = i.m01_atc_custo_acc_name, -- u03_atc_custo_name
                       u03_atc_id_exp_date = i.m01_atc_id_exp_date, -- u03_atc_id_exp_date
                       u03_atc_id_number = i.m01_atc_id_number, -- u03_atc_id_number
                       u03_other_annual_inc = i.m01_other_annual_inc, -- u03_other_annual_inc
                       u03_other_approx_net_sar = i.m01_other_approx_net_sar, -- u03_other_approx_net_sar
                       u03_other_certificates = i.m01_other_certificates, -- u03_other_certificates
                       u03_other_divid_other_inc = i.m01_other_divid_other_inc, -- u03_other_divid_other_inc
                       u03_other_inc_add_info = i.m01_other_inc_add_info, -- u03_other_inc_add_info
                       u03_other_monthly_sal = i.m01_other_monthly_sal, -- u03_other_monthly_sal
                       u03_other_next_review = i.m01_other_next_review, -- u03_other_next_review
                       u03_other_pub_listed_comp = i.m01_other_pub_listed_comp, -- u03_other_pub_listed_comp
                       u03_other_repaper_date = i.m01_other_repaper_date, -- u03_other_repaper_date
                       u03_other_sale_proc = i.m01_other_sale_proc, -- u03_other_sale_proc
                       u03_modified_by_id_u17 = 0, -- u03_modified_by_id_u17
                       u03_modified_date = SYSDATE -- u03_modified_date
                 WHERE u03_id = i.new_customer_kyc_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U03_CUSTOMER_KYC',
                                i.m01_customer_id,
                                CASE
                                    WHEN i.new_customer_kyc_id IS NULL
                                    THEN
                                        l_customer_kyc_id
                                    ELSE
                                        i.new_customer_kyc_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_customer_kyc_id IS NULL
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
