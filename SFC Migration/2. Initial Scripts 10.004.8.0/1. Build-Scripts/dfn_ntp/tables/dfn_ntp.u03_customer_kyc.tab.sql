CREATE TABLE dfn_ntp.u03_customer_kyc
(
    u03_customer_id_u01              NUMBER (10, 0),
    u03_emp_date_of_emp              DATE,
    u03_emp_employer_name            VARCHAR2 (250 BYTE),
    u03_emp_po_box                   VARCHAR2 (25 BYTE),
    u03_emp_country_id_m05           NUMBER (5, 0),
    u03_emp_city_id_m06              NUMBER (5, 0),
    u03_emp_zip_code                 VARCHAR2 (50 BYTE),
    u03_emp_telephone                VARCHAR2 (20 BYTE),
    u03_emp_email                    VARCHAR2 (50 BYTE),
    u03_emp_position_id_m114         NUMBER (5, 0),
    u03_emp_title                    VARCHAR2 (20 BYTE),
    u03_emp_resign_date              DATE,
    u03_cop_name                     VARCHAR2 (250 BYTE),
    u03_cop_comercial_reg_no         VARCHAR2 (100 BYTE),
    u03_cop_comercial_reg_date       DATE,
    u03_cop_address                  VARCHAR2 (250 BYTE),
    u03_cop_country_id_m05           NUMBER (5, 0),
    u03_cop_bussness_start_date      DATE,
    u03_cop_telephone                VARCHAR2 (20 BYTE),
    u03_cop_mobile                   VARCHAR2 (20 BYTE),
    u03_cop_fax                      VARCHAR2 (20 BYTE),
    u03_cop_number_of_emp            NUMBER (5, 0),
    u03_cop_paid_up_capital          NUMBER (22, 5),
    u03_cop_annual_turnover          NUMBER (22, 5),
    u03_cop_contact_person_name      VARCHAR2 (100 BYTE),
    u03_cop_address_of_contact       VARCHAR2 (250 BYTE),
    u03_cop_phone_of_contact         VARCHAR2 (20 BYTE),
    u03_cop_fax_of_contact           VARCHAR2 (20 BYTE),
    u03_cop_mobile_of_contact        VARCHAR2 (20 BYTE),
    u03_cop_email_of_contact         VARCHAR2 (50 BYTE),
    u03_ideal_shares_h               NUMBER (22, 0),
    u03_ideal_shares_m               NUMBER (22, 0),
    u03_ideal_debit_instru_h         NUMBER (22, 0),
    u03_ideal_debit_instru_m         NUMBER (22, 0),
    u03_ideal_debit_instru_l         NUMBER (22, 0),
    u03_ideal_invest_funds_h         NUMBER (22, 0),
    u03_ideal_invest_funds_m         NUMBER (22, 0),
    u03_ideal_invest_funds_l         NUMBER (22, 0),
    u03_ideal_trade_fin_l            NUMBER (22, 0),
    u03_ideal_commodities_h          NUMBER (22, 0),
    u03_ideal_options_h              NUMBER (22, 0),
    u03_invest_shares                NUMBER (22, 0),
    u03_invest_debit_instru          NUMBER (22, 0),
    u03_invest_forign_exchange       NUMBER (22, 0),
    u03_invest_deposits              NUMBER (22, 0),
    u03_invest_trade_finance         NUMBER (22, 0),
    u03_invest_investment_funds      NUMBER (22, 0),
    u03_invest_commodities           NUMBER (22, 0),
    u03_invest_derivatives_options   NUMBER (22, 0),
    u03_invest_real_estate           NUMBER (22, 0),
    u03_invest_know_exp              NUMBER (5, 0),
    u03_invest_profile               NUMBER (5, 0),
    u03_invest_client_clasific       NUMBER (5, 0),
    u03_invest_gen_invest_object     NUMBER (5, 0),
    u03_invest_pref_invest_assets    NUMBER (5, 0),
    u03_invest_forign_currencies     VARCHAR2 (250 BYTE),
    u03_atc_contact_name             VARCHAR2 (250 BYTE),
    u03_atc_address_l1               VARCHAR2 (250 BYTE),
    u03_atc_address_l2               VARCHAR2 (250 BYTE),
    u03_atc_business_phone           VARCHAR2 (20 BYTE),
    u03_act_home_telephone           VARCHAR2 (20 BYTE),
    u03_atc_business_fax             VARCHAR2 (20 BYTE),
    u03_atc_mobile_no                VARCHAR2 (20 BYTE),
    u03_act_email                    VARCHAR2 (50 BYTE),
    u03_act_document_no              VARCHAR2 (20 BYTE),
    u03_act_document_date            DATE,
    u03_act_doc_issue_place          NUMBER (5, 0),
    u03_act_relationship             VARCHAR2 (100 BYTE),
    u03_atc_country                  NUMBER (5, 0),
    u03_ref_name                     VARCHAR2 (250 BYTE),
    u03_ref_relationship             VARCHAR2 (100 BYTE),
    u03_ref_pobox                    VARCHAR2 (100 BYTE),
    u03_ref_country                  NUMBER (5, 0),
    u03_ref_area                     VARCHAR2 (100 BYTE),
    u03_ref_zip                      VARCHAR2 (100 BYTE),
    u03_ref_email                    VARCHAR2 (50 BYTE),
    u03_ref_mobile                   VARCHAR2 (50 BYTE),
    u03_ref_telephone                VARCHAR2 (50 BYTE),
    u03_ref_work_phone               VARCHAR2 (50 BYTE),
    u03_politically_exposed          NUMBER (1, 0),
    u03_politically_exposed_narr     VARCHAR2 (200 BYTE),
    u03_beneficiary_owner            NUMBER (1, 0),
    u03_beneficiary_owner_narr       VARCHAR2 (200 BYTE),
    u03_repaper_date                 DATE,
    u03_next_review                  DATE,
    u03_modified_by_id_u17           NUMBER (5, 0),
    u03_modified_date                TIMESTAMP (6),
    u03_cra_pep_indicators_m106      NUMBER (3, 0),
    u03_cra_customer_group_m106      NUMBER (3, 0),
    u03_cra_client_status_m106       NUMBER (3, 0),
    u03_cra_legal_status_m106        NUMBER (3, 0),
    u03_cra_q1                       NUMBER (1, 0),
    u03_cra_q2                       NUMBER (1, 0),
    u03_cra_q3                       NUMBER (1, 0),
    u03_cra_q4                       NUMBER (1, 0),
    u03_cra_q5                       NUMBER (1, 0),
    u03_cra_q6                       NUMBER (1, 0),
    u03_cra_q7                       NUMBER (1, 0),
    u03_cra_q8                       NUMBER (1, 0),
    u03_cra_q9                       NUMBER (1, 0),
    u03_cra_q10                      NUMBER (1, 0),
    u03_emp_type_m106                NUMBER (5, 0),
    u03_id                           NUMBER (10, 0),
    u03_atc_custo_acc_name           VARCHAR2 (50 BYTE),
    u03_atc_custo_acc_no             VARCHAR2 (50 BYTE),
    u03_atc_custo_address_l1         VARCHAR2 (50 BYTE),
    u03_atc_custo_address_l2         VARCHAR2 (50 BYTE),
    u03_atc_custo_name               VARCHAR2 (50 BYTE),
    u03_atc_customer_type            VARCHAR2 (50 BYTE),
    u03_atc_id_exp_date              DATE,
    u03_atc_id_issue_date            DATE,
    u03_atc_id_issue_place           VARCHAR2 (50 BYTE),
    u03_atc_id_number                VARCHAR2 (50 BYTE),
    u03_atc_id_type_id_m15           VARCHAR2 (50 BYTE),
    u03_atc_nationality_id_m05       VARCHAR2 (50 BYTE),
    u03_atc_id_expiory_date2         DATE,
    u03_atc_id_issue_date2           DATE,
    u03_atc_id_issue_place2_id_m14   VARCHAR2 (50 BYTE),
    u03_atc_id_number2               VARCHAR2 (50 BYTE),
    u03_atc_id_type2_id_m15          VARCHAR2 (50 BYTE),
    u03_cop_countr                   VARCHAR2 (50 BYTE),
    u03_facta_entity_sub_type        VARCHAR2 (50 BYTE),
    u03_fatca_address_indicator      VARCHAR2 (50 BYTE),
    u03_fatca_cntry_residnce         VARCHAR2 (50 BYTE),
    u03_fatca_entity_class           VARCHAR2 (50 BYTE),
    u03_fatca_entity_type            VARCHAR2 (50 BYTE),
    u03_fatca_gin_conf               NUMBER (5, 0),
    u03_fatca_gin_number             VARCHAR2 (100 BYTE),
    u03_fatca_institution_id_m02     NUMBER (3, 0),
    u03_fatca_other_address          VARCHAR2 (200 BYTE),
    u03_fatca_ownership              NUMBER (22, 2),
    u03_fatca_residance              NUMBER (1, 0),
    u03_fatca_self_cert_corp         NUMBER (1, 0),
    u03_fatca_self_certification     NUMBER (1, 0),
    u03_fatca_standing_ord           NUMBER (2, 0),
    u03_fatca_status                 NUMBER (2, 0),
    u03_fatca_taxreference           VARCHAR2 (50 BYTE),
    u03_ideal_total_val              NUMBER (18, 0),
    u03_investment_total_value       NUMBER (18, 0),
    u03_other_annual_inc             NUMBER (18, 0),
    u03_other_approx_net_sar         NUMBER (18, 0),
    u03_other_certificates           NUMBER (1, 0),
    u03_other_divid_other_inc        NUMBER (1, 0),
    u03_other_education              VARCHAR2 (200 BYTE),
    u03_other_file_location          VARCHAR2 (200 BYTE),
    u03_other_inc_add_info           VARCHAR2 (50 BYTE),
    u03_other_monthly_sal            NUMBER (22, 5),
    u03_other_nationality_id_m05     NUMBER (5, 0),
    u03_other_next_review            DATE,
    u03_other_pub_listed_comp        NUMBER (1, 0),
    u03_other_region_area            VARCHAR2 (50 BYTE),
    u03_other_repaper_date           DATE,
    u03_other_sale_proc              NUMBER (1, 0),
    u03_ref_city_id_m06              NUMBER (5, 0),
    u03_ref_id_expiory_date          DATE,
    u03_ref_id_issue_date            DATE,
    u03_ref_id_issue_place           NUMBER (5, 0),
    u03_ref_id_number                VARCHAR2 (50 BYTE),
    u03_ref_id_type_id_m15           NUMBER (5, 0),
    u03_ref_id_expiry_date2          VARCHAR2 (50 BYTE),
    u03_ref_id_issue_date2           VARCHAR2 (50 BYTE),
    u03_ref_id_issue_place2_id_m14   VARCHAR2 (50 BYTE),
    u03_ref_id_number2               VARCHAR2 (50 BYTE),
    u03_ref_id_type2_id_m15          VARCHAR2 (50 BYTE),
    u03_risk_client_status           NUMBER (5, 0),
    u03_txt_overrall_risk_level      VARCHAR2 (50 BYTE),
    u03_txt_risk_customer_group      VARCHAR2 (50 BYTE),
    u03_txt_risk_legal_status        VARCHAR2 (50 BYTE),
    u03_txt_risk_pep_indicators      VARCHAR2 (11 BYTE),
    u03_txt_risk_q1                  VARCHAR2 (50 BYTE),
    u03_txt_risk_q10                 VARCHAR2 (50 BYTE),
    u03_txt_risk_q2                  VARCHAR2 (50 BYTE),
    u03_txt_risk_q3                  VARCHAR2 (50 BYTE),
    u03_txt_risk_q4                  VARCHAR2 (50 BYTE),
    u03_txt_risk_q5                  VARCHAR2 (50 BYTE),
    u03_txt_risk_q6                  VARCHAR2 (50 BYTE),
    u03_txt_risk_q7                  VARCHAR2 (50 BYTE),
    u03_txt_risk_q8                  VARCHAR2 (50 BYTE),
    u03_txt_risk_q9                  VARCHAR2 (50 BYTE),
    u03_custom_type                  VARCHAR2 (20 BYTE),
    u03_txt_risk_q11                 VARCHAR2 (50 BYTE),
    u03_txt_risk_q12                 VARCHAR2 (50 BYTE)
)
/



ALTER TABLE dfn_ntp.u03_customer_kyc
ADD CONSTRAINT u03_pk PRIMARY KEY (u03_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_client_status_m106 IS
    'fk from 106'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_customer_group_m106 IS
    'fk from 106'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_legal_status_m106 IS
    'fk from 106'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_pep_indicators_m106 IS
    'fk from 106'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q1 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q10 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q2 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q3 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q4 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q5 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q6 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q7 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q8 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_cra_q9 IS '1 - No, 2 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_custom_type IS
    'To support customization'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_emp_city_id_m06 IS
    'fk from m06'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_emp_country_id_m05 IS
    'fk from m05'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_emp_position_id_m114 IS
    'fk from m114'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_emp_type_m106 IS 'fk from 106'
/
COMMENT ON COLUMN dfn_ntp.u03_customer_kyc.u03_txt_risk_q11 IS
    'To test customization'
/

CREATE INDEX DFN_NTP.IDX_U03_CUSTOMER_ID_U01 ON DFN_NTP.U03_CUSTOMER_KYC
   (  U03_CUSTOMER_ID_U01 ASC  ) 
/