DECLARE
    l_broker_id              NUMBER;
    l_institute_id           NUMBER;
    l_primary_institute_id   NUMBER;
    l_use_new_key            NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT NVL (MAX (m02_id), 0)
      INTO l_institute_id
      FROM dfn_ntp.m02_institute;

    l_use_new_key := fn_use_new_key ('M02_INSTITUTE');

    FOR i
        IN (SELECT m05.*,
                   m03.m03_id AS display_curr_id,
                   m02_map.new_institute_id
              FROM mubasher_oms.m05_branches@mubasher_db_link m05,
                   dfn_ntp.m03_currency m03,
                   m02_institute_mappings m02_map
             WHERE     m05.m05_display_currency = m03.m03_code(+)
                   AND m05.m05_branch_id > 0
                   AND m05.m05_branch_id = m02_map.old_institute_id(+))
    LOOP
        IF i.new_institute_id IS NULL
        THEN
            l_institute_id :=
                CASE
                    WHEN l_use_new_key = 0 THEN i.m05_branch_id
                    ELSE l_institute_id + 1
                END;

            INSERT INTO m02_institute_mappings
                 VALUES (i.m05_branch_id, l_institute_id);

            INSERT
              INTO dfn_ntp.m02_institute (m02_id,
                                          m02_address,
                                          m02_code,
                                          m02_email,
                                          m02_fax,
                                          m02_name,
                                          m02_name_lang,
                                          m02_telephone,
                                          m02_off_mrkt_orders_allowed,
                                          m02_add_rcvbl_for_bp,
                                          m02_use_exg_com_discount,
                                          m02_primary_contact,
                                          m02_branch_status,
                                          m02_created_by_id_u17,
                                          m02_created_date,
                                          m02_approved_by_id_u17,
                                          m02_approved_date,
                                          m02_account_activation_period,
                                          m02_account_suspension_period,
                                          m02_account_deletion_period,
                                          m02_maker_checker_status,
                                          m02_is_local,
                                          m02_price_block_type_id_m55,
                                          m02_price_block_perc,
                                          m02_password_history_count,
                                          m02_minimum_password_length,
                                          m02_pwd_complexity_lvl_id_m96,
                                          m02_password_expiry_period,
                                          m02_overdraw,
                                          m02_print_price_login_in_pin,
                                          m02_pwd_expiry_warning_days,
                                          m02_exchange_book_keepers_enab,
                                          m02_broker_code,
                                          m02_pwd_lowercase_required,
                                          m02_pwd_uppercase_required,
                                          m02_pwd_numbers_required,
                                          m02_pwd_specialchars_required,
                                          m02_gen_use_pwd_comp_lvl_users,
                                          m02_gen_use_pwd_comp_lvl_cust,
                                          m02_cus_pwd_complex_lvl_id_m96,
                                          m02_cus_minimum_pwd_length,
                                          m02_cus_pwd_lowercase_required,
                                          m02_cus_pwd_uppercase_required,
                                          m02_cus_pwd_numbers_required,
                                          m02_cus_pwd_specials_required,
                                          m02_cus_pwd_expiry_period,
                                          m02_cus_pwd_expiry_warningdays,
                                          m02_cus_acct_activation_period,
                                          m02_cus_acct_suspension_period,
                                          m02_cus_acct_deletion_period,
                                          m02_cus_pwd_history_count,
                                          m02_is_root_institution,
                                          m02_website_url,
                                          m02_product_name,
                                          m02_product_name_arb,
                                          m02_address_lang,
                                          m02_define_com_grp_for_sub_ac,
                                          m02_display_currency_code_m03,
                                          m02_bypass_buying_power,
                                          m02_max_margin,
                                          m02_margin_blocked,
                                          m02_margin_utilized,
                                          m02_max_day_limit,
                                          m02_day_limit_blocked,
                                          m02_day_limit_utilized,
                                          m02_currency_code_m03,
                                          m02_change_pwd_on_fir_log,
                                          m02_mubasher_exec_id,
                                          m02_swift_enabled,
                                          m02_allow_small_orders,
                                          m02_deposit_sms_allow,
                                          m02_login_url,
                                          m02_allow_multiple_id_types,
                                          m02_overdrawn_interest_rate,
                                          m02_bp_buypass_manual_order,
                                          m02_validate_price_sub_channel,
                                          m02_enable_cust_rebate_calc,
                                          m02_max_backsearch_months,
                                          m02_trade_settle_curr_restric,
                                          m02_cash_transation_disable,
                                          m02_enable_sharia_compliant,
                                          m02_validate_exp_date_min_diff,
                                          m02_issue_exp_min_days_diff,
                                          m02_send_cma_deta_updat_remind,
                                          m02_cma_details_remind_days,
                                          m02_send_primry_id_exp_remind,
                                          m02_primry_id_exp_remind_days,
                                          m02_modified_by_id_u17,
                                          m02_modified_date,
                                          m02_hotline,
                                          m02_agreement_check_date,
                                          m02_is_check_agreement,
                                          m02_trans_approve_disable,
                                          m02_min_req_coverage_ratio,
                                          m02_group_bp_enable,
                                          m02_daily_withdrawal_limit,
                                          m02_daily_withd_lmt_cur_cd_m03,
                                          m02_status_id_v01,
                                          m02_status_changed_by_id_u17,
                                          m02_status_changed_date,
                                          m02_pwd_max_same_adj_chars,
                                          m02_cust_pwd_max_same_adj_chrs,
                                          m02_pwd_not_contain_login_name,
                                          m02_cust_pwd_not_contain_lgn_n,
                                          m02_cust_login_trading_pwd_dif,
                                          m02_pwd_max_repeated_chars,
                                          m02_cust_pwd_max_repeated_char,
                                          m02_pwd_start_should_char,
                                          m02_cust_pwd_start_should_char,
                                          m02_maximum_password_length,
                                          m02_cust_maximum_pwd_length,
                                          m02_stmt_purge_period,
                                          m02_primary_security_acc,
                                          m02_secondary_security_acc,
                                          m02_display_minus_buying_power,
                                          m02_sec_comm_grp_allowed,
                                          m02_enable_cash_due_cleared,
                                          m02_due_settle_enabled,
                                          m02_enable_hold_due_cleared,
                                          m02_enable_pend_stl_utilize,
                                          m02_display_unique_order,
                                          m02_disable_portf_self_trade,
                                          m02_disclaimer,
                                          m02_disclaimer_ar,
                                          m02_cust_detail_in_tmptbl_days,
                                          m02_max_intl_backsearch_months,
                                          m02_toll_free_number,
                                          m02_apply_min_discount,
                                          m02_daily_withd_lmt_cur_id_m03,
                                          m02_display_currency_id_m03,
                                          m02_underage_to_minor_years,
                                          m02_minor_to_major_years,
                                          m02_report_logo_path,
                                          m02_add_pledge_for_bp,
                                          m02_kyc_renewal_individual,
                                          m02_kyc_renewal_corporate,
                                          m02_add_buy_pending_for_margin,
                                          m02_add_sym_margin_for_margin,
                                          m02_price_type_for_margin,
                                          m02_vat_no,
                                          m02_custom_type,
                                          m02_holding_transation_disable,
                                          m02_broker_id_m150,
                                          m02_default_product_id_m152,
                                          m02_primary_institute_id_m02,
                                          m02_debit_maintain_margin)
            VALUES (
                       l_institute_id, --m02_id
                       i.m05_address, --m02_address
                       i.m05_branch_code, --m02_code
                       i.m05_email, --m02_email
                       i.m05_fax, --m02_fax
                       i.m05_branch_name, --m02_name
                       i.m05_arabic_name, --m02_name_lang
                       i.m05_telephone, --m02_telephone
                       i.m05_offmkt_orders, --m02_off_mrkt_orders_allowed
                       1, --m02_add_rcvbl_for_bp
                       0, --m02_use_exg_com_discount
                       i.m05_manager_name, --m02_primary_contact
                       i.m05_branch_status, --m02_branch_status
                       NVL (i.m05_created_by, 0), --m02_created_by_id_u17 | Updated Later from 999 Script
                       NVL (i.m05_created_date, SYSDATE), --m02_created_date
                       i.m05_approved_by, --m02_approved_by_id_u17 | Updated Later from 999 Script
                       i.m05_approved_date, --m02_approved_date
                       i.m05_account_activation_period, --m02_account_activation_period
                       i.m05_account_suspension_period, --m02_account_suspension_period
                       i.m05_account_deletion_period, --m02_account_deletion_period
                       i.m05_maker_checker_status, --m02_maker_checker_status
                       i.m05_is_local, --m02_is_local
                       i.m05_price_block_type, --m02_price_block_type_id_m55
                       i.m05_price_block_perc, --m02_price_block_perc
                       i.m05_password_history_count, --m02_password_history_count
                       i.m05_minimum_password_length, --m02_minimum_password_length
                       i.m05_password_complexity_level, --m02_pwd_complexity_lvl_id_m96
                       i.m05_password_expiry_period, --m02_password_expiry_period
                       i.m05_overdraw, --m02_overdraw
                       i.m05_print_price_login_in_pin, --m02_print_price_login_in_pin
                       i.m05_pwd_expiry_warning_days, --m02_pwd_expiry_warning_days
                       i.m05_exchange_book_keepers_enab, --m02_exchange_book_keepers_enab
                       i.m05_broker_code, --m02_broker_code
                       CASE
                           WHEN i.m05_pwd_lowercase_required = 0 THEN 3
                           ELSE i.m05_pwd_lowercase_required
                       END, --m02_pwd_lowercase_required
                       CASE
                           WHEN i.m05_pwd_uppercase_required = 0 THEN 3
                           ELSE i.m05_pwd_uppercase_required
                       END, --m02_pwd_uppercase_required
                       CASE
                           WHEN i.m05_pwd_numbers_required = 0 THEN 3
                           ELSE i.m05_pwd_numbers_required
                       END, --m02_pwd_numbers_required
                       CASE
                           WHEN i.m05_pwd_specialchars_required = 0 THEN 3
                           ELSE i.m05_pwd_specialchars_required
                       END, --m02_pwd_specialchars_required
                       i.m05_gen_use_pwd_comp_lvl_users, --m02_gen_use_pwd_comp_lvl_users
                       i.m05_gen_use_pwd_comp_lvl_cust, --m02_gen_use_pwd_comp_lvl_cust
                       i.m05_cus_pwd_complexity_level, --m02_cus_pwd_complex_lvl_id_m96
                       i.m05_cus_minimum_pwd_length, --m02_cus_minimum_pwd_length
                       CASE
                           WHEN i.m05_cus_pwd_lowercase_required = 0 THEN 3
                           ELSE i.m05_cus_pwd_lowercase_required
                       END, --m02_cus_pwd_lowercase_required
                       CASE
                           WHEN i.m05_cus_pwd_uppercase_required = 0 THEN 3
                           ELSE i.m05_cus_pwd_uppercase_required
                       END, --m02_cus_pwd_uppercase_required
                       CASE
                           WHEN i.m05_cus_pwd_numbers_required = 0 THEN 3
                           ELSE i.m05_cus_pwd_numbers_required
                       END, --m02_cus_pwd_numbers_required
                       CASE
                           WHEN i.m05_cus_pwd_specials_required = 0 THEN 3
                           ELSE i.m05_cus_pwd_specials_required
                       END, --m02_cus_pwd_specials_required
                       i.m05_cus_pwd_expiry_period, --m02_cus_pwd_expiry_period
                       i.m05_cus_pwd_expiry_warningdays, --m02_cus_pwd_expiry_warningdays
                       i.m05_cus_acct_activation_period, --m02_cus_acct_activation_period
                       i.m05_cus_acct_suspension_period, --m02_cus_acct_suspension_period
                       i.m05_cus_acct_deletion_period, --m02_cus_acct_deletion_period
                       i.m05_cus_pwd_history_count, --m02_cus_pwd_history_count
                       i.m05_is_root_institution, --m02_is_root_institution
                       i.m05_website_url, --m02_website_url
                       i.m05_product_name, --m02_product_name
                       i.m05_product_name_arb, --m02_product_name_arb
                       i.m05_arabic_address, --m02_address_lang
                       i.m05_define_com_grp_for_sub_ac, --m02_define_com_grp_for_sub_ac
                       i.m05_display_currency, --m02_display_currency_code_m03
                       i.m05_bypass_buying_power, --m02_bypass_buying_power
                       i.m05_max_margin, --m02_max_margin
                       i.m05_margin_blocked, --m02_margin_blocked
                       i.m05_margin_utilized, --m02_margin_utilized
                       i.m05_max_day_limit, --m02_max_day_limit
                       i.m05_day_limit_blocked, --m02_day_limit_blocked
                       i.m05_day_limit_utilized, --m02_day_limit_utilized
                       i.m05_currency, --m02_currency_code_m03
                       i.m05_change_pwd_on_fir_log, --m02_change_pwd_on_fir_log
                       i.m05_mubasher_exec_id, --m02_mubasher_exec_id
                       i.m05_swift_enabled, --m02_swift_enabled
                       i.m05_allow_small_orders, --m02_allow_small_orders
                       i.m05_deposit_sms_allow, --m02_deposit_sms_allow
                       i.m05_login_url, --m02_login_url
                       i.m05_allow_multiple_id_types, --m02_allow_multiple_id_types
                       i.m05_overdrawn_interest_rate, --m02_overdrawn_interest_rate
                       i.m05_bp_buypass_manual_order, --m02_bp_buypass_manual_order
                       i.m05_validate_price_sub_channel, --m02_validate_price_sub_channel
                       i.m05_enable_cust_rebate_calc, --m02_enable_cust_rebate_calc
                       3, --m02_max_backsearch_months
                       i.m05_trade_settle_curr_restric, --m02_trade_settle_curr_restric
                       i.m05_cash_transation_disable, --m02_cash_transation_disable
                       0, --m02_enable_sharia_compliant
                       0, --m02_validate_exp_date_min_diff
                       90, --m02_issue_exp_min_days_diff
                       0, --m02_send_cma_deta_updat_remind
                       60, --m02_cma_details_remind_days
                       0, --m02_send_primry_id_exp_remind
                       90, --m02_primry_id_exp_remind_days
                       NULL, --m02_modified_by_id_u17
                       NULL, --m02_modified_date
                       NULL, --m02_hotline
                       NULL, --m02_agreement_check_date
                       0, --m02_is_check_agreement
                       i.m05_trans_approve_disable, --m02_trans_approve_disable
                       0, --m02_min_req_coverage_ratio
                       0, --m02_group_bp_enable
                       0, --m02_daily_withdrawal_limit
                       i.m05_display_currency, -- m02_daily_withd_lmt_cur_cd_m03
                       2, --m02_status_id_v01
                       0, --m02_status_changed_by_id_u17
                       SYSDATE, --m02_status_changed_date
                       2, --m02_pwd_max_same_adj_chars
                       2, --m02_cust_pwd_max_same_adj_chrs
                       1, --m02_pwd_not_contain_login_name
                       1, --m02_cust_pwd_not_contain_lgn_n
                       1, --m02_cust_login_trading_pwd_dif
                       3, --m02_pwd_max_repeated_chars
                       3, --m02_cust_pwd_max_repeated_char
                       1, --m02_pwd_start_should_char
                       1, --m02_cust_pwd_start_should_char
                       16, --m02_maximum_password_length
                       16, --m02_cust_maximum_pwd_length
                       90, --m02_stmt_purge_period
                       NULL, --m02_primary_security_acc
                       NULL, --m02_secondary_security_acc
                       0, --m02_display_minus_buying_power
                       0, --m02_sec_comm_grp_allowed
                       0, --m02_enable_cash_due_cleared
                       0, --m02_due_settle_enabled
                       0, --m02_enable_hold_due_cleared
                       0, --m02_enable_pend_stl_utilize
                       1, --m02_display_unique_order
                       0, --m02_disable_portf_self_trade
                       NULL, --m02_disclaimer
                       NULL, --m02_disclaimer_ar
                       0, --m02_cust_detail_in_tmptbl_days
                       1, --m02_max_intl_backsearch_months
                       i.m05_telephone, --m02_toll_free_number
                       0, --m02_apply_min_discount
                       i.display_curr_id, --m02_daily_withd_lmt_cur_id_m03
                       i.display_curr_id, --m02_display_currency_id_m03
                       NULL, --m02_underage_to_minor_years
                       NULL, --m02_minor_to_major_years
                       NULL, --m02_report_logo_path
                       0, --m02_add_pledge_for_bp
                       NULL, -- m02_kyc_renewal_individual
                       NULL, -- m02_kyc_renewal_corporate
                       0, -- m02_add_buy_pending_for_margin,
                       0, -- m02_add_sym_margin_for_margin,
                       0, -- m02_price_type_for_margin,
                       i.m05_vat_no, -- m02_vat_no
                       '1', -- m02_custom_type,
                       0, -- m02_holding_transation_disable,
                       l_broker_id, -- m02_broker_id_m150
                       NULL, -- m02_default_product_id_m152,
                       NULL, -- m02_primary_institute_id_m02
                       0 -- m02_debit_maintain_margin | Not Available
                        );
        ELSE
            UPDATE dfn_ntp.m02_institute m02
               SET m02_address = i.m05_address, --m02_address
                   m02_code = i.m05_branch_code, --m02_code
                   m02_email = i.m05_email, --m02_email
                   m02_fax = i.m05_fax, --m02_fax
                   m02_name = i.m05_branch_name, --m02_name
                   m02_name_lang = i.m05_arabic_name, --m02_name_lang
                   m02_telephone = i.m05_telephone, --m02_telephone
                   m02_off_mrkt_orders_allowed = i.m05_offmkt_orders, --m02_off_mrkt_orders_allowed
                   m02_add_rcvbl_for_bp = 1, --m02_add_rcvbl_for_bp
                   m02_use_exg_com_discount = 0, --m02_use_exg_com_discount
                   m02_primary_contact = i.m05_manager_name, --m02_primary_contact
                   m02_branch_status = i.m05_branch_status, --m02_branch_status
                   m02_approved_by_id_u17 = i.m05_approved_by, --m02_approved_by_id_u17 | Updated Later from 999 Script
                   m02_approved_date = i.m05_approved_date, --m02_approved_date
                   m02_account_activation_period =
                       i.m05_account_activation_period, --m02_account_activation_period
                   m02_account_suspension_period =
                       i.m05_account_suspension_period, --m02_account_suspension_period
                   m02_account_deletion_period = i.m05_account_deletion_period, --m02_account_deletion_period
                   m02_maker_checker_status = i.m05_maker_checker_status, --m02_maker_checker_status
                   m02_is_local = i.m05_is_local, --m02_is_local
                   m02_price_block_type_id_m55 = i.m05_price_block_type, --m02_price_block_type_id_m55
                   m02_price_block_perc = i.m05_price_block_perc, --m02_price_block_perc
                   m02_password_history_count = i.m05_password_history_count, --m02_password_history_count
                   m02_minimum_password_length = i.m05_minimum_password_length, --m02_minimum_password_length
                   m02_pwd_complexity_lvl_id_m96 =
                       i.m05_password_complexity_level, --m02_pwd_complexity_lvl_id_m96
                   m02_password_expiry_period = i.m05_password_expiry_period, --m02_password_expiry_period
                   m02_overdraw = i.m05_overdraw, --m02_overdraw
                   m02_print_price_login_in_pin =
                       i.m05_print_price_login_in_pin, --m02_print_price_login_in_pin
                   m02_pwd_expiry_warning_days = i.m05_pwd_expiry_warning_days, --m02_pwd_expiry_warning_days
                   m02_exchange_book_keepers_enab =
                       i.m05_exchange_book_keepers_enab, --m02_exchange_book_keepers_enab
                   m02_broker_code = i.m05_broker_code, --m02_broker_code
                   m02_pwd_lowercase_required =
                       CASE
                           WHEN i.m05_pwd_lowercase_required = 0 THEN 3
                           ELSE i.m05_pwd_lowercase_required
                       END, --m02_pwd_lowercase_required
                   m02_pwd_uppercase_required =
                       CASE
                           WHEN i.m05_pwd_uppercase_required = 0 THEN 3
                           ELSE i.m05_pwd_uppercase_required
                       END, --m02_pwd_uppercase_required
                   m02_pwd_numbers_required =
                       CASE
                           WHEN i.m05_pwd_numbers_required = 0 THEN 3
                           ELSE i.m05_pwd_numbers_required
                       END, --m02_pwd_numbers_required
                   m02_pwd_specialchars_required =
                       CASE
                           WHEN i.m05_pwd_specialchars_required = 0 THEN 3
                           ELSE i.m05_pwd_specialchars_required
                       END, --m02_pwd_specialchars_required
                   m02_gen_use_pwd_comp_lvl_users =
                       i.m05_gen_use_pwd_comp_lvl_users, --m02_gen_use_pwd_comp_lvl_users
                   m02_gen_use_pwd_comp_lvl_cust =
                       i.m05_gen_use_pwd_comp_lvl_cust, --m02_gen_use_pwd_comp_lvl_cust
                   m02_cus_pwd_complex_lvl_id_m96 = 0, --m02_cus_pwd_complex_lvl_id_m96
                   m02_cus_minimum_pwd_length = i.m05_cus_minimum_pwd_length, --m02_cus_minimum_pwd_length
                   m02_cus_pwd_lowercase_required =
                       CASE
                           WHEN i.m05_cus_pwd_lowercase_required = 0 THEN 3
                           ELSE i.m05_cus_pwd_lowercase_required
                       END, --m02_cus_pwd_lowercase_required
                   m02_cus_pwd_uppercase_required =
                       CASE
                           WHEN i.m05_cus_pwd_uppercase_required = 0 THEN 3
                           ELSE i.m05_cus_pwd_uppercase_required
                       END, --m02_cus_pwd_uppercase_required
                   m02_cus_pwd_numbers_required =
                       CASE
                           WHEN i.m05_cus_pwd_numbers_required = 0 THEN 3
                           ELSE i.m05_cus_pwd_numbers_required
                       END, --m02_cus_pwd_numbers_required
                   m02_cus_pwd_specials_required =
                       CASE
                           WHEN i.m05_cus_pwd_specials_required = 0 THEN 3
                           ELSE i.m05_cus_pwd_specials_required
                       END, --m02_cus_pwd_specials_required
                   m02_cus_pwd_expiry_period = i.m05_cus_pwd_expiry_period, --m02_cus_pwd_expiry_period
                   m02_cus_pwd_expiry_warningdays =
                       i.m05_cus_pwd_expiry_warningdays, --m02_cus_pwd_expiry_warningdays
                   m02_cus_acct_activation_period =
                       i.m05_cus_acct_activation_period, --m02_cus_acct_activation_period
                   m02_cus_acct_suspension_period =
                       i.m05_cus_acct_suspension_period, --m02_cus_acct_suspension_period
                   m02_cus_acct_deletion_period =
                       i.m05_cus_acct_deletion_period, --m02_cus_acct_deletion_period
                   m02_cus_pwd_history_count = i.m05_cus_pwd_history_count, --m02_cus_pwd_history_count
                   m02_is_root_institution = i.m05_is_root_institution, --m02_is_root_institution
                   m02_website_url = i.m05_website_url, --m02_website_url
                   m02_product_name = i.m05_product_name, --m02_product_name
                   m02_product_name_arb = i.m05_product_name_arb, --m02_product_name_arb
                   m02_address_lang = i.m05_arabic_address, --m02_address_lang
                   m02_define_com_grp_for_sub_ac =
                       i.m05_define_com_grp_for_sub_ac, --m02_define_com_grp_for_sub_ac
                   m02_display_currency_code_m03 = i.m05_display_currency, --m02_display_currency_code_m03
                   m02_bypass_buying_power = i.m05_bypass_buying_power, --m02_bypass_buying_power
                   m02_max_margin = i.m05_max_margin, --m02_max_margin
                   m02_margin_blocked = i.m05_margin_blocked, --m02_margin_blocked
                   m02_margin_utilized = i.m05_margin_utilized, --m02_margin_utilized
                   m02_max_day_limit = i.m05_max_day_limit, --m02_max_day_limit
                   m02_day_limit_blocked = i.m05_day_limit_blocked, --m02_day_limit_blocked
                   m02_day_limit_utilized = i.m05_day_limit_utilized, --m02_day_limit_utilized
                   m02_currency_code_m03 = i.m05_currency, --m02_currency_code_m03
                   m02_change_pwd_on_fir_log = i.m05_change_pwd_on_fir_log, --m02_change_pwd_on_fir_log
                   m02_mubasher_exec_id = i.m05_mubasher_exec_id, --m02_mubasher_exec_id
                   m02_swift_enabled = i.m05_swift_enabled, --m02_swift_enabled
                   m02_allow_small_orders = i.m05_allow_small_orders, --m02_allow_small_orders
                   m02_deposit_sms_allow = i.m05_deposit_sms_allow, --m02_deposit_sms_allow
                   m02_login_url = i.m05_login_url, --m02_login_url
                   m02_allow_multiple_id_types = i.m05_allow_multiple_id_types, --m02_allow_multiple_id_types
                   m02_overdrawn_interest_rate = i.m05_overdrawn_interest_rate, --m02_overdrawn_interest_rate
                   m02_bp_buypass_manual_order = i.m05_bp_buypass_manual_order, --m02_bp_buypass_manual_order
                   m02_validate_price_sub_channel =
                       i.m05_validate_price_sub_channel, --m02_validate_price_sub_channel
                   m02_enable_cust_rebate_calc = i.m05_enable_cust_rebate_calc, --m02_enable_cust_rebate_calc
                   m02_max_backsearch_months = 3, --m02_max_backsearch_months
                   m02_trade_settle_curr_restric =
                       i.m05_trade_settle_curr_restric, --m02_trade_settle_curr_restric
                   m02_cash_transation_disable = i.m05_cash_transation_disable, --m02_cash_transation_disable
                   m02_enable_sharia_compliant = 0, --m02_enable_sharia_compliant
                   m02_validate_exp_date_min_diff = 0, --m02_validate_exp_date_min_diff
                   m02_issue_exp_min_days_diff = 90, --m02_issue_exp_min_days_diff
                   m02_send_cma_deta_updat_remind = 0, --m02_send_cma_deta_updat_remind
                   m02_cma_details_remind_days = 60, --m02_cma_details_remind_days
                   m02_send_primry_id_exp_remind = 0, --m02_send_primry_id_exp_remind
                   m02_primry_id_exp_remind_days = 90, --m02_primry_id_exp_remind_days
                   m02_modified_by_id_u17 = 0, --m02_modified_by_id_u17
                   m02_modified_date = SYSDATE, --m02_modified_date
                   m02_hotline = NULL, --m02_hotline
                   m02_agreement_check_date = NULL, --m02_agreement_check_date
                   m02_is_check_agreement = 0, --m02_is_check_agreement
                   m02_trans_approve_disable = i.m05_trans_approve_disable, --m02_trans_approve_disable
                   m02_min_req_coverage_ratio = 0, --m02_min_req_coverage_ratio
                   m02_group_bp_enable = 0, --m02_group_bp_enable
                   m02_daily_withdrawal_limit = 0, --m02_daily_withdrawal_limit
                   m02_daily_withd_lmt_cur_cd_m03 = i.m05_display_currency, -- m02_daily_withd_lmt_cur_cd_m03
                   m02_status_id_v01 = 2, --m02_status_id_v01
                   m02_status_changed_by_id_u17 = 0, --m02_status_changed_by_id_u17
                   m02_status_changed_date = SYSDATE, --m02_status_changed_date
                   m02_pwd_max_same_adj_chars = 2, --m02_pwd_max_same_adj_chars
                   m02_cust_pwd_max_same_adj_chrs = 2, --m02_cust_pwd_max_same_adj_chrs
                   m02_pwd_not_contain_login_name = 1, --m02_pwd_not_contain_login_name
                   m02_cust_pwd_not_contain_lgn_n = 1, --m02_cust_pwd_not_contain_lgn_n
                   m02_cust_login_trading_pwd_dif = 1, --m02_cust_login_trading_pwd_dif
                   m02_pwd_max_repeated_chars = 3, --m02_pwd_max_repeated_chars
                   m02_cust_pwd_max_repeated_char = 3, --m02_cust_pwd_max_repeated_char
                   m02_pwd_start_should_char = 1, --m02_pwd_start_should_char
                   m02_cust_pwd_start_should_char = 1, --m02_cust_pwd_start_should_char
                   m02_maximum_password_length = 16, --m02_maximum_password_length
                   m02_cust_maximum_pwd_length = 16, --m02_cust_maximum_pwd_length
                   m02_stmt_purge_period = 90, --m02_stmt_purge_period
                   m02_primary_security_acc = NULL, --m02_primary_security_acc
                   m02_secondary_security_acc = NULL, --m02_secondary_security_acc
                   m02_display_minus_buying_power = 0, --m02_display_minus_buying_power
                   m02_sec_comm_grp_allowed = 0, --m02_sec_comm_grp_allowed
                   m02_enable_cash_due_cleared = 0, --m02_enable_cash_due_cleared
                   m02_due_settle_enabled = 0, --m02_due_settle_enabled
                   m02_enable_hold_due_cleared = 0, --m02_enable_hold_due_cleared
                   m02_enable_pend_stl_utilize = 0, --m02_enable_pend_stl_utilize
                   m02_display_unique_order = 1, --m02_display_unique_order
                   m02_disable_portf_self_trade = 0, --m02_disable_portf_self_trade
                   m02_disclaimer = NULL, --m02_disclaimer
                   m02_disclaimer_ar = NULL, --m02_disclaimer_ar
                   m02_cust_detail_in_tmptbl_days = 0, --m02_cust_detail_in_tmptbl_days
                   m02_max_intl_backsearch_months = 1, --m02_max_intl_backsearch_months
                   m02_toll_free_number = NULL, --m02_toll_free_number
                   m02_apply_min_discount = 0, --m02_apply_min_discount
                   m02_daily_withd_lmt_cur_id_m03 = i.display_curr_id, --m02_daily_withd_lmt_cur_id_m03
                   m02_display_currency_id_m03 = i.display_curr_id, --m02_display_currency_id_m03
                   m02_underage_to_minor_years = NULL, --m02_underage_to_minor_years
                   m02_minor_to_major_years = NULL, --m02_minor_to_major_years
                   m02_report_logo_path = NULL, --m02_report_logo_path
                   m02_add_pledge_for_bp = 0, --m02_add_pledge_for_bp
                   m02_kyc_renewal_individual = NULL, -- m02_kyc_renewal_individual
                   m02_kyc_renewal_corporate = NULL, -- m02_kyc_renewal_corporate
                   m02_add_buy_pending_for_margin = 0, -- m02_add_buy_pending_for_margin,
                   m02_add_sym_margin_for_margin = 0, -- m02_add_sym_margin_for_margin,
                   m02_price_type_for_margin = 0, -- m02_price_type_for_margin,
                   m02_vat_no = i.m05_vat_no, -- m02_vat_no
                   m02_custom_type = '1', -- m02_custom_type,
                   m02_holding_transation_disable = 0, -- m02_holding_transation_disable,
                   m02_broker_id_m150 = l_broker_id, -- m02_broker_id_m150
                   m02_default_product_id_m152 = NULL, -- m02_default_product_id_m152,
                   m02_primary_institute_id_m02 = NULL, -- m02_primary_institute_id_m02
                   m02_debit_maintain_margin = 0 -- m02_debit_maintain_margin | Not Available
             WHERE m02.m02_id = i.new_institute_id;
        END IF;
    END LOOP;

    --  Extract Root Institution and Set Primary Institution ID

    SELECT MAX (m02_map.new_institute_id)
      INTO l_primary_institute_id
      FROM mubasher_oms.m05_branches@mubasher_db_link m05,
           m02_institute_mappings m02_map
     WHERE     m05.m05_branch_id = m02_map.old_institute_id
           AND m05_is_root_institution = 1;

    IF l_primary_institute_id IS NULL
    THEN
        SELECT MIN (m02_map.new_institute_id)
          INTO l_primary_institute_id
          FROM mubasher_oms.m05_branches@mubasher_db_link m05,
               m02_institute_mappings m02_map
         WHERE m05.m05_branch_id = m02_map.old_institute_id;
    END IF;

    UPDATE dfn_ntp.m02_institute m02
       SET m02.m02_primary_institute_id_m02 = l_primary_institute_id
     WHERE m02.m02_broker_id_m150 = l_broker_id;
END;
/
