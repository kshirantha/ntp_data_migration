CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_payment_detail_list
(
    t501_id,
    t501_cash_transaction_id_t06,
    t501_symbol_code_m20,
    t501_record_date,
    t501_nin_number,
    t501_investor_name,
    t501_nationality,
    t501_investor_type,
    t501_account_code,
    t501_iban,
    t501_broker_code_m150,
    t501_broker_name,
    t501_current_balance,
    t501_ownership_percentage,
    t501_event_type,
    t501_entitlement_type,
    t501_payment_amount,
    t501_tax_amount,
    t501_currency_code_m03,
    t501_payment_status,
    t501_payment_date,
    t501_payment_confirm,
    t501_payment_session_id_t500,
    t501_cash_account_id_u06,
    t501_no_of_approval,
    t501_is_approval_completed,
    t501_current_approval_level,
    t501_next_status,
    t501_created_date,
    t501_last_updated_date,
    t501_status_id_v01,
    t501_comment,
    t501_created_by_id_u17,
    t501_last_updated_by_id_u17,
    t501_custom_type,
    t501_institute_id_m02,
    status,
    payment_status,
    last_updated_by
)
AS
    SELECT t501.t501_id,
           t501.t501_cash_transaction_id_t06,
           t501.t501_symbol_code_m20,
           t501.t501_record_date,
           t501.t501_nin_number,
           t501.t501_investor_name,
           t501.t501_nationality,
           t501.t501_investor_type,
           t501.t501_account_code,
           t501.t501_iban,
           t501.t501_broker_code_m150,
           t501.t501_broker_name,
           t501.t501_current_balance,
           t501.t501_ownership_percentage,
           t501.t501_event_type,
           t501.t501_entitlement_type,
           t501.t501_payment_amount,
           t501.t501_tax_amount,
           t501.t501_currency_code_m03,
           t501.t501_payment_status,
           t501.t501_payment_date,
           t501.t501_payment_confirm,
           t501.t501_payment_session_id_t500,
           t501.t501_cash_account_id_u06,
           t501.t501_no_of_approval,
           t501.t501_is_approval_completed,
           t501.t501_current_approval_level,
           t501.t501_next_status,
           t501.t501_created_date,
           t501.t501_last_updated_date,
           t501.t501_status_id_v01,
           t501.t501_comment,
           t501.t501_created_by_id_u17,
           t501.t501_last_updated_by_id_u17,
           t501.t501_custom_type,
           t501.t501_institute_id_m02,
           status_list.v01_description AS status,
           payment_status.v01_description AS payment_status,
           updated_by.u17_full_name AS last_updated_by
      FROM t501_payment_detail_c t501
           LEFT JOIN vw_status_list status_list
               ON t501.t501_status_id_v01 = status_list.v01_id
           LEFT JOIN vw_status_list payment_status
               ON t501.t501_payment_status = payment_status.v01_id
           LEFT JOIN u17_employee updated_by
               ON t501.t501_last_updated_by_id_u17 = updated_by.u17_id
/