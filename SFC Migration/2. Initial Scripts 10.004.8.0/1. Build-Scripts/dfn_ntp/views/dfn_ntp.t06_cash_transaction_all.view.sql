CREATE OR REPLACE FORCE VIEW dfn_ntp.t06_cash_transaction_all
(
    t06_id,
    t06_cash_acc_id_u06,
    t06_code,
    t06_date,
    t06_from_cust_id_u01,
    t06_narration,
    t06_payment_method,
    t06_txn_code_m03,
    t06_amt_in_txn_currency,
    t06_settle_currency_rate_m04,
    t06_cheque_no,
    t06_cheque_date,
    t06_settlement_date,
    t06_beneficiary_id_u08,
    t06_other_cash_acc_id_u06,
    t06_entered_by_id_u17,
    t06_entered_date,
    t06_last_changed_by_id_u17,
    t06_last_changed_date,
    t06_cash_log_acc_id_u30,
    t06_status_id,
    t06_bank_id_m93,
    t06_acc_name,
    t06_branch,
    t06_type_id,
    t06_chk_printed_by,
    t06_chk_printed_date,
    t06_extrnl_ref,
    t06_req_media,
    t06_location,
    t06_auto_generate,
    t06_available_buy_power,
    t06_online_ft,
    t06_ft_status,
    t06_message_type,
    t06_stp_type,
    t06_stp_status,
    t06_stp_narration,
    t06_cust_bank_acc_id,
    t06_settlement_key,
    t06_txn_type,
    t06_reversed_by_id_u17,
    t06_reversed_date,
    t06_payment_initiated_time,
    t06_settle_currency_code_m03,
    t06_amt_in_settle_currency,
    t06_related_txn_id,
    t06_overdrawn_amt,
    t06_poa_id_u47,
    t06_exchange_fee,
    t06_broker_fee,
    t06_thirdparty_fee,
    t06_to_cash_acc_id,
    t06_client_channel_id_v29,
    t06_sub_login_id_u09,
    t06_sub_login_name,
    t06_b2b_txn_id_m97,
    t06_bypass_txn_restriction,
    t06_third_party_txn_id,
    t06_is_live,
    t06_no_of_approval,
    t06_current_approval_level,
    t06_deposit_bank_id_m16,
    t06_deposit_bank_no,
    t06_function_id_m88,
    t06_reject_reason,
    t06_exg_vat,
    t06_brk_vat,
    t06_institute_id_m02,
    t06_symbol_code_m20,
    t06_symbol_id_m20,
    t06_ref_id,
    t06_ref_master_id,
    t06_ref_type,
    t06_is_allow_overdraw,
    t06_exg_discount,
    t06_brk_discount,
    t06_system_approval,
    t06_narration_lang
)
AS
    SELECT t06_id,
           t06_cash_acc_id_u06,
           t06_code,
           t06_date,
           t06_from_cust_id_u01,
           t06_narration,
           t06_payment_method,
           t06_txn_code_m03,
           t06_amt_in_txn_currency,
           t06_settle_currency_rate_m04,
           t06_cheque_no,
           t06_cheque_date,
           t06_settlement_date,
           t06_beneficiary_id_u08,
           t06_other_cash_acc_id_u06,
           t06_entered_by_id_u17,
           t06_entered_date,
           t06_last_changed_by_id_u17,
           t06_last_changed_date,
           t06_cash_log_acc_id_u30,
           t06_status_id,
           t06_bank_id_m93,
           t06_acc_name,
           t06_branch,
           t06_type_id,
           t06_chk_printed_by,
           t06_chk_printed_date,
           t06_extrnl_ref,
           t06_req_media,
           t06_location,
           t06_auto_generate,
           t06_available_buy_power,
           t06_online_ft,
           t06_ft_status,
           t06_message_type,
           t06_stp_type,
           t06_stp_status,
           t06_stp_narration,
           t06_cust_bank_acc_id,
           t06_settlement_key,
           t06_txn_type,
           t06_reversed_by_id_u17,
           t06_reversed_date,
           t06_payment_initiated_time,
           t06_settle_currency_code_m03,
           t06_amt_in_settle_currency,
           t06_related_txn_id,
           t06_overdrawn_amt,
           t06_poa_id_u47,
           t06_exchange_fee,
           t06_broker_fee,
           t06_thirdparty_fee,
           t06_to_cash_acc_id,
           t06_client_channel_id_v29,
           t06_sub_login_id_u09,
           t06_sub_login_name,
           t06_b2b_txn_id_m97,
           t06_bypass_txn_restriction,
           t06_third_party_txn_id,
           t06_is_live,
           t06_no_of_approval,
           t06_current_approval_level,
           t06_deposit_bank_id_m16,
           t06_deposit_bank_no,
           t06_function_id_m88,
           t06_reject_reason,
           t06_exg_vat,
           t06_brk_vat,
           t06_institute_id_m02,
           t06_symbol_code_m20,
           t06_symbol_id_m20,
           t06_ref_id,
           t06_ref_master_id,
           t06_ref_type,
           t06_is_allow_overdraw,
           t06_exg_discount,
           t06_brk_discount,
           t06_system_approval,
           t06_narration_lang
      FROM dfn_ntp.t06_cash_transaction
    UNION ALL
    SELECT t06_id,
           t06_cash_acc_id_u06,
           t06_code,
           t06_date,
           t06_from_cust_id_u01,
           t06_narration,
           t06_payment_method,
           t06_txn_code_m03,
           t06_amt_in_txn_currency,
           t06_settle_currency_rate_m04,
           t06_cheque_no,
           t06_cheque_date,
           t06_settlement_date,
           t06_beneficiary_id_u08,
           t06_other_cash_acc_id_u06,
           t06_entered_by_id_u17,
           t06_entered_date,
           t06_last_changed_by_id_u17,
           t06_last_changed_date,
           t06_cash_log_acc_id_u30,
           t06_status_id,
           t06_bank_id_m93,
           t06_acc_name,
           t06_branch,
           t06_type_id,
           t06_chk_printed_by,
           t06_chk_printed_date,
           t06_extrnl_ref,
           t06_req_media,
           t06_location,
           t06_auto_generate,
           t06_available_buy_power,
           t06_online_ft,
           t06_ft_status,
           t06_message_type,
           t06_stp_type,
           t06_stp_status,
           t06_stp_narration,
           t06_cust_bank_acc_id,
           t06_settlement_key,
           t06_txn_type,
           t06_reversed_by_id_u17,
           t06_reversed_date,
           t06_payment_initiated_time,
           t06_settle_currency_code_m03,
           t06_amt_in_settle_currency,
           t06_related_txn_id,
           t06_overdrawn_amt,
           t06_poa_id_u47,
           t06_exchange_fee,
           t06_broker_fee,
           t06_thirdparty_fee,
           t06_to_cash_acc_id,
           t06_client_channel_id_v29,
           t06_sub_login_id_u09,
           t06_sub_login_name,
           t06_b2b_txn_id_m97,
           t06_bypass_txn_restriction,
           t06_third_party_txn_id,
           t06_is_live,
           t06_no_of_approval,
           t06_current_approval_level,
           t06_deposit_bank_id_m16,
           t06_deposit_bank_no,
           t06_function_id_m88,
           t06_reject_reason,
           t06_exg_vat,
           t06_brk_vat,
           t06_institute_id_m02,
           t06_symbol_code_m20,
           t06_symbol_id_m20,
           t06_ref_id,
           t06_ref_master_id,
           t06_ref_type,
           t06_is_allow_overdraw,
           t06_exg_discount,
           t06_brk_discount,
           t06_system_approval,
           t06_narration_lang
      FROM dfn_arc.t06_cash_transaction
/