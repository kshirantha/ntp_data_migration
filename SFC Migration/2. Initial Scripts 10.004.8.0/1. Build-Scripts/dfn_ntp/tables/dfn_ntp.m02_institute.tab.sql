-- Table DFN_NTP.M02_INSTITUTE

CREATE TABLE dfn_ntp.m02_institute
(
    m02_id                           NUMBER (3, 0),
    m02_address                      VARCHAR2 (255),
    m02_code                         VARCHAR2 (255),
    m02_email                        VARCHAR2 (255),
    m02_fax                          VARCHAR2 (255),
    m02_name                         VARCHAR2 (255),
    m02_name_lang                    VARCHAR2 (255),
    m02_telephone                    VARCHAR2 (255),
    m02_off_mrkt_orders_allowed      NUMBER (1, 0) DEFAULT 1,
    m02_add_rcvbl_for_bp             NUMBER (1, 0) DEFAULT 1,
    m02_use_exg_com_discount         NUMBER (1, 0) DEFAULT 1,
    m02_primary_contact              VARCHAR2 (100),
    m02_branch_status                NUMBER (2, 0),
    m02_created_by_id_u17            NUMBER (10, 0),
    m02_created_date                 DATE,
    m02_approved_by_id_u17           NUMBER (10, 0),
    m02_approved_date                DATE,
    m02_account_activation_period    NUMBER (5, 0),
    m02_account_suspension_period    NUMBER (5, 0),
    m02_account_deletion_period      NUMBER (5, 0),
    m02_maker_checker_status         NUMBER (1, 0) DEFAULT 0,
    m02_is_local                     NUMBER (1, 0) DEFAULT 1,
    m02_price_block_type_id_m55      NUMBER (1, 0) DEFAULT 0,
    m02_price_block_perc             NUMBER (5, 3) DEFAULT 0,
    m02_password_history_count       NUMBER (3, 0) DEFAULT 3,
    m02_minimum_password_length      NUMBER (2, 0) DEFAULT 5,
    m02_pwd_complexity_lvl_id_m96    NUMBER (10, 0) DEFAULT 1,
    m02_password_expiry_period       NUMBER (3, 0) DEFAULT 90,
    m02_overdraw                     NUMBER (1, 0) DEFAULT 0,
    m02_print_price_login_in_pin     NUMBER (1, 0) DEFAULT 1,
    m02_pwd_expiry_warning_days      NUMBER (2, 0) DEFAULT 7,
    m02_exchange_book_keepers_enab   NUMBER (1, 0) DEFAULT 0,
    m02_broker_code                  VARCHAR2 (50),
    m02_pwd_lowercase_required       NUMBER (1, 0) DEFAULT 0,
    m02_pwd_uppercase_required       NUMBER (1, 0) DEFAULT 0,
    m02_pwd_numbers_required         NUMBER (1, 0) DEFAULT 0,
    m02_pwd_specialchars_required    NUMBER (1, 0) DEFAULT 0,
    m02_gen_use_pwd_comp_lvl_users   NUMBER (1, 0) DEFAULT 0,
    m02_gen_use_pwd_comp_lvl_cust    NUMBER (1, 0) DEFAULT 0,
    m02_cus_pwd_complex_lvl_id_m96   NUMBER (10, 0) DEFAULT 1,
    m02_cus_minimum_pwd_length       NUMBER (2, 0) DEFAULT 0,
    m02_cus_pwd_lowercase_required   NUMBER (1, 0) DEFAULT 0,
    m02_cus_pwd_uppercase_required   NUMBER (1, 0) DEFAULT 0,
    m02_cus_pwd_numbers_required     NUMBER (1, 0) DEFAULT 0,
    m02_cus_pwd_specials_required    NUMBER (1, 0) DEFAULT 0,
    m02_cus_pwd_expiry_period        NUMBER (3, 0) DEFAULT 90,
    m02_cus_pwd_expiry_warningdays   NUMBER (2, 0) DEFAULT 7,
    m02_cus_acct_activation_period   NUMBER (5, 0) DEFAULT 0,
    m02_cus_acct_suspension_period   NUMBER (5, 0) DEFAULT 0,
    m02_cus_acct_deletion_period     NUMBER (5, 0) DEFAULT 0,
    m02_cus_pwd_history_count        NUMBER (3, 0) DEFAULT 3,
    m02_is_root_institution          NUMBER (1, 0) DEFAULT 0,
    m02_website_url                  VARCHAR2 (200),
    m02_product_name                 VARCHAR2 (200),
    m02_product_name_arb             VARCHAR2 (200),
    m02_address_lang                 VARCHAR2 (2000),
    m02_define_com_grp_for_sub_ac    NUMBER (1, 0) DEFAULT 0,
    m02_display_currency_code_m03    CHAR (3),
    m02_bypass_buying_power          NUMBER (1, 0) DEFAULT 0,
    m02_max_margin                   NUMBER (18, 5) DEFAULT 0,
    m02_margin_blocked               NUMBER (18, 5) DEFAULT 0,
    m02_margin_utilized              NUMBER (18, 5) DEFAULT 0,
    m02_max_day_limit                NUMBER (18, 5) DEFAULT 0,
    m02_day_limit_blocked            NUMBER (18, 5) DEFAULT 0,
    m02_day_limit_utilized           NUMBER (18, 5) DEFAULT 0,
    m02_currency_code_m03            VARCHAR2 (3),
    m02_change_pwd_on_fir_log        NUMBER (1, 0) DEFAULT 1,
    m02_mubasher_exec_id             NUMBER (1, 0),
    m02_swift_enabled                NUMBER (1, 0) DEFAULT 0,
    m02_allow_small_orders           NUMBER (1, 0) DEFAULT 0,
    m02_deposit_sms_allow            NUMBER (1, 0) DEFAULT 0,
    m02_login_url                    VARCHAR2 (255),
    m02_allow_multiple_id_types      NUMBER (1, 0) DEFAULT 0,
    m02_overdrawn_interest_rate      NUMBER (4, 2) DEFAULT 0,
    m02_bp_buypass_manual_order      NUMBER (1, 0) DEFAULT 0,
    m02_validate_price_sub_channel   NUMBER (1, 0) DEFAULT 0,
    m02_enable_cust_rebate_calc      NUMBER (1, 0) DEFAULT 0,
    m02_max_backsearch_months        NUMBER (4, 0) DEFAULT 3,
    m02_trade_settle_curr_restric    NUMBER (1, 0) DEFAULT 0,
    m02_cash_transation_disable      NUMBER (1, 0) DEFAULT 0,
    m02_enable_sharia_compliant      NUMBER (1, 0) DEFAULT 0,
    m02_validate_exp_date_min_diff   NUMBER (1, 0) DEFAULT 0,
    m02_issue_exp_min_days_diff      NUMBER (4, 0) DEFAULT 90,
    m02_send_cma_deta_updat_remind   NUMBER (1, 0) DEFAULT 0,
    m02_cma_details_remind_days      NUMBER (4, 0) DEFAULT 60,
    m02_send_primry_id_exp_remind    NUMBER (1, 0) DEFAULT 0,
    m02_primry_id_exp_remind_days    NUMBER (4, 0) DEFAULT 90,
    m02_modified_by_id_u17           NUMBER (10, 0),
    m02_modified_date                DATE,
    m02_hotline                      NVARCHAR2 (100),
    m02_agreement_check_date         DATE,
    m02_is_check_agreement           NUMBER (1, 0) DEFAULT 0,
    m02_trans_approve_disable        NUMBER (1, 0) DEFAULT 0,
    m02_min_req_coverage_ratio       NUMBER (6, 2) DEFAULT 0,
    m02_group_bp_enable              NUMBER (1, 0) DEFAULT 0,
    m02_daily_withdrawal_limit       NUMBER (18, 5) DEFAULT 0,
    m02_daily_withd_lmt_cur_cd_m03   NVARCHAR2 (3),
    m02_status_id_v01                NUMBER (20, 0) DEFAULT 2,
    m02_status_changed_by_id_u17     NUMBER (20, 0),
    m02_status_changed_date          DATE,
    m02_pwd_max_same_adj_chars       NUMBER (1, 0) DEFAULT 2,
    m02_cust_pwd_max_same_adj_chrs   NUMBER (1, 0) DEFAULT 2,
    m02_pwd_not_contain_login_name   NUMBER (1, 0) DEFAULT 1,
    m02_cust_pwd_not_contain_lgn_n   NUMBER (1, 0) DEFAULT 1,
    m02_cust_login_trading_pwd_dif   NUMBER (1, 0) DEFAULT 1,
    m02_pwd_max_repeated_chars       NUMBER (1, 0) DEFAULT 3,
    m02_cust_pwd_max_repeated_char   NUMBER (1, 0) DEFAULT 3,
    m02_pwd_start_should_char        NUMBER (1, 0) DEFAULT 1,
    m02_cust_pwd_start_should_char   NUMBER (1, 0) DEFAULT 1,
    m02_maximum_password_length      NUMBER (2, 0) DEFAULT 16,
    m02_cust_maximum_pwd_length      NUMBER (2, 0) DEFAULT 16,
    m02_stmt_purge_period            NUMBER (3, 0) DEFAULT 90,
    m02_primary_security_acc         VARCHAR2 (20),
    m02_secondary_security_acc       VARCHAR2 (20),
    m02_display_minus_buying_power   NUMBER (1, 0) DEFAULT 0,
    m02_sec_comm_grp_allowed         NUMBER (1, 0) DEFAULT 0,
    m02_enable_cash_due_cleared      NUMBER (1, 0) DEFAULT 0,
    m02_due_settle_enabled           NUMBER (1, 0) DEFAULT 0,
    m02_enable_hold_due_cleared      NUMBER (1, 0) DEFAULT 0,
    m02_enable_pend_stl_utilize      NUMBER (1, 0) DEFAULT 0,
    m02_display_unique_order         NUMBER (1, 0) DEFAULT 1,
    m02_disable_portf_self_trade     NUMBER (1, 0) DEFAULT 0,
    m02_disclaimer                   VARCHAR2 (300),
    m02_disclaimer_ar                VARCHAR2 (300),
    m02_cust_detail_in_tmptbl_days   NUMBER (20, 0) DEFAULT 0,
    m02_max_intl_backsearch_months   NUMBER (1, 0) DEFAULT 1,
    m02_toll_free_number             VARCHAR2 (20),
    m02_apply_min_discount           NUMBER (1, 0),
    m02_daily_withd_lmt_cur_id_m03   NUMBER (5, 0),
    m02_display_currency_id_m03      NUMBER (5, 0),
    m02_underage_to_minor_years      NUMBER (2, 0),
    m02_minor_to_major_years         NUMBER (2, 0),
    m02_report_logo_path             VARCHAR2 (2000),
    m02_add_pledge_for_bp            NUMBER (1, 0) DEFAULT 0,
    m02_kyc_renewal_individual       NUMBER (2, 0),
    m02_kyc_renewal_corporate        NUMBER (2, 0),
    PRIMARY KEY (m02_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
OVERFLOW
/

-- Constraints for  DFN_NTP.M02_INSTITUTE


  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_off_mrkt_orders_allowed NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_password_history_count NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_minimum_password_length NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_pwd_complexity_lvl_id_m96 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_password_expiry_period NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_print_price_login_in_pin NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_pwd_expiry_warning_days NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_exchange_book_keepers_enab NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_pwd_lowercase_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_pwd_uppercase_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_pwd_numbers_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_pwd_specialchars_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_gen_use_pwd_comp_lvl_users NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_gen_use_pwd_comp_lvl_cust NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_pwd_complex_lvl_id_m96 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_minimum_pwd_length NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_pwd_lowercase_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_pwd_uppercase_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_pwd_numbers_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_pwd_specials_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_pwd_expiry_period NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_pwd_expiry_warningdays NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_acct_activation_period NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_acct_suspension_period NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_acct_deletion_period NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_cus_pwd_history_count NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_is_root_institution NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_define_com_grp_for_sub_ac NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute MODIFY (m02_sec_comm_grp_allowed NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m02_institute ADD CONSTRAINT uk_m02_code UNIQUE (m02_code)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.M02_INSTITUTE

COMMENT ON COLUMN dfn_ntp.m02_institute.m02_off_mrkt_orders_allowed IS
    '1 - allowed,2- Not allowed'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_add_rcvbl_for_bp IS
    '1-Add, 0- Remove'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_use_exg_com_discount IS
    '1 - allowed,0- Not allowed'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_created_by_id_u17 IS
    'FK from U17'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_approved_by_id_u17 IS
    'FK from U17'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_maker_checker_status IS
    '0 = No 1 = YES'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_is_local IS '0 = No 1 = Yes'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_price_block_type_id_m55 IS
    'FK from M55, 0-default,1- max,2-best bid,3- best ask,4- last trade'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_password_history_count IS
    'no of previous passwords to be kept in user password history'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_minimum_password_length IS
    'minimum length of the oMS users password for this institution'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_pwd_complexity_lvl_id_m96 IS
    'FK from M96'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_password_expiry_period IS
    'passowrd expiry period for this institution for OMS users'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_overdraw IS '0 = No 1 = Yes'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_print_price_login_in_pin IS
    '0=no,1=yes print price login details in PIN'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_pwd_expiry_warning_days IS
    'password expiry warning days'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_exchange_book_keepers_enab IS
    'whether to use book keepers for trading or not'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_pwd_lowercase_required IS
    '0 - Ignore the rule | 1 - Should contain lowercase | 2 - Should not contain lowercase'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_pwd_uppercase_required IS
    '0 - Ignore the rule | 1 - Should contain uppercase | 2 - Should not contain uppercase'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_pwd_numbers_required IS
    '0 - Ignore the rule | 1 - Should contain numbers | 2 - Should not contain numbers'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_pwd_specialchars_required IS
    '0 - Ignore the rule | 1 - Should contain special characters | 2 - Should not contain special characters'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_gen_use_pwd_comp_lvl_users IS
    'when generating passwords for OMS users, use the password complexity level:1=yes,0=No'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_gen_use_pwd_comp_lvl_cust IS
    'when generating passwords for Customers, use the password complexity level:1=yes,0=No'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cus_pwd_complex_lvl_id_m96 IS
    'FK from M96'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cus_minimum_pwd_length IS
    'Minimum password length for customers'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cus_pwd_lowercase_required IS
    '0 - Ignore the rule | 1 - Should contain lowercase | 2 - Should not contain lowercase'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cus_pwd_uppercase_required IS
    '0 - Ignore the rule | 1 - Should contain uppercase | 2 - Should not contain uppercase'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cus_pwd_numbers_required IS
    '0 - Ignore the rule | 1 - Should contain numbers | 2 - Should not contain numbers'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cus_pwd_specials_required IS
    '0 - Ignore the rule | 1 - Should contain special characters | 2 - Should not contain special characters'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cus_pwd_expiry_warningdays IS
    'customer password expiry warning days'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cus_pwd_history_count IS
    'no of previous passwords to be kept in customer password history'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_is_root_institution IS
    'when the OMs is having multiple institutuions witha executiong broker, this flag specifies what is the root instituion is'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_website_url IS
    'Institution Website URL'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_product_name IS 'Product Name'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_product_name_arb IS
    'Product Arabic Name'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_address_lang IS
    'Institution Arabic Address'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_display_currency_code_m03 IS
    'FK from M03'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_currency_code_m03 IS
    'FK from M03'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_deposit_sms_allow IS
    '0=not,1=allow'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_allow_multiple_id_types IS
    '0-not allow, 1-allow'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_overdrawn_interest_rate IS
    'Customers Overdrawn interest calculation %'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_bp_buypass_manual_order IS
    '0=not allow, 1=allow'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_validate_price_sub_channel IS
    '0-not, 1-allow'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_enable_cust_rebate_calc IS
    '0-not, 1-allow'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_max_backsearch_months IS
    'this is for DT'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_trade_settle_curr_restric IS
    '0=not,1=restric'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cash_transation_disable IS
    '0 - Enable, 1 - Disable'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_enable_sharia_compliant IS
    '1 - Enable, 0 - Disable'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_send_cma_deta_updat_remind IS
    '1=Yes, 0=No'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cma_details_remind_days IS
    'CMA details Update Remider days'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_send_primry_id_exp_remind IS
    '1=Yes, 0=No'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_primry_id_exp_remind_days IS
    'primary ID expiry reminder days'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_modified_by_id_u17 IS
    'FK from U17'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_trans_approve_disable IS
    '0 - Enable, 1 - Disable'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_group_bp_enable IS
    '1 - Enable, 0 - Disable'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_daily_withdrawal_limit IS
    'maximum withdrawal limit for each cash account'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_daily_withd_lmt_cur_cd_m03 IS
    'FK from M03, Daily withdrawal limit currency code'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_status_id_v01 IS 'FK from V01'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_status_changed_by_id_u17 IS
    'FK from U17'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_pwd_max_same_adj_chars IS
    'Maximun Adjust Chars for User password'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cust_pwd_max_same_adj_chrs IS
    'Maximun Adjust Chars for Customer password'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_pwd_not_contain_login_name IS
    '0 - can contain, 1 - Shoud not contain login name'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cust_pwd_not_contain_lgn_n IS
    '0 - can contain, 1 - Shoud not contain login name'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cust_login_trading_pwd_dif IS
    '0 - Can be same, 1 - Should be different'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_pwd_start_should_char IS
    '0 - Ignore the rule | 1 - Should be charactor | 2 - Should not charactor'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cust_pwd_start_should_char IS
    '0 - Ignore the rule | 1 - Should be charactor | 2 - Should not charactor'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_maximum_password_length IS
    'Maximum user password length'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_cust_maximum_pwd_length IS
    'Maximum customer password length'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_stmt_purge_period IS
    'Statement purge period in days'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_display_minus_buying_power IS
    '1=Minus Allow, 0=Minus Not Allow'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_sec_comm_grp_allowed IS
    '0 - No, 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_enable_cash_due_cleared IS
    '0 - No, 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_due_settle_enabled IS
    '0 - No, 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_enable_hold_due_cleared IS
    '0 - No, 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_enable_pend_stl_utilize IS
    '0 - No, 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_display_unique_order IS
    '1=unique, else duplicate'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_disclaimer IS
    'Institutions Disclaimer in English'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_disclaimer_ar IS
    'Institutions Disclaimer in Arabic'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_apply_min_discount IS
    'Apply minimum discount when apply two ruls'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_daily_withd_lmt_cur_id_m03 IS
    'FK from M03'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_display_currency_id_m03 IS
    'FK from M03'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_underage_to_minor_years IS
    'No of Hijiri Years required to become Minor from Underage'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_minor_to_major_years IS
    'No of Hijiri Years required to become Major from Minor'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_add_pledge_for_bp IS
    '1=add, 0=not added'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_kyc_renewal_individual IS
    'Next KYC annual renewal years for individual customers'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_kyc_renewal_corporate IS
    'Next KYC annual renewal years for corporate customers'
/
-- End of DDL Script for Table DFN_NTP.M02_INSTITUTE

ALTER TABLE dfn_ntp.m02_institute
 ADD (
  m02_add_buy_pending_for_margin NUMBER (1, 0) DEFAULT 0,
  m02_add_sym_margin_for_margin NUMBER (1, 0) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_add_pledge_for_bp IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_add_buy_pending_for_margin IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_add_sym_margin_for_margin IS
    '0 - No | 1 - Yes'
/
ALTER TABLE dfn_ntp.m02_institute
 ADD (
  m02_price_type_for_margin NUMBER (1) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_price_type_for_margin IS
    '0 - Default | 1 - Last Trade | 2 - VWAP | 3 - Previous Closed | 4 - Closing Price'
/
ALTER TABLE dfn_ntp.m02_institute
 ADD (
  m02_vat_no VARCHAR2 (20)
 )
/

alter table dfn_ntp.M02_INSTITUTE
	add M02_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.M02_INSTITUTE 
 ADD (
  M02_HOLDING_TRANSATION_DISABLE NUMBER (1) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.M02_INSTITUTE.M02_HOLDING_TRANSATION_DISABLE IS '0 - Enable, 1 - Disable'
/

ALTER TABLE dfn_ntp.m02_institute
 ADD (
  m02_broker_id_m150 NUMBER (3)
 )
/

ALTER TABLE dfn_ntp.M02_INSTITUTE 
 ADD (
  M02_DEFAULT_PRODUCT NUMBER (5, 0)
 )
/

ALTER TABLE dfn_ntp.M02_INSTITUTE 
RENAME COLUMN M02_DEFAULT_PRODUCT TO M02_DEFAULT_PRODUCT_ID_M152
/

ALTER TABLE dfn_ntp.m02_institute
    ADD m02_primary_institute_id_m02 NUMBER(5)
/

ALTER TABLE dfn_ntp.m02_institute
ADD (
  m02_debit_maintain_margin NUMBER (1, 0) DEFAULT 0
)
/
COMMENT ON COLUMN dfn_ntp.m02_institute.m02_debit_maintain_margin IS
    '0=Not Debit even for ICM and Institutional Client'
/
CREATE INDEX dfn_ntp.idx_m02_fast
    ON dfn_ntp.m02_institute (m02_id,
                              m02_primary_institute_id_m02,
                              m02_name,
                              m02_name_lang)
/

