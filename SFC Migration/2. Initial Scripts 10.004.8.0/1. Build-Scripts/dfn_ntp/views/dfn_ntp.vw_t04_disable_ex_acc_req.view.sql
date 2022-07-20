CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t04_disable_ex_acc_req
(
    t04_id,
    t04_trading_acc_id_u07,
    t04_exchange_code_m01,
    t04_no_of_approval,
    t04_is_approval_completed,
    t04_current_approval_level,
    t04_next_status,
    t04_created_date,
    t04_last_updated_date,
    t04_created_by_id_u17,
    t04_status_id_v01,
    t04_reason,
    customer_id,
    customer_no,
    ext_customer_no,
    full_name,
    full_name_lang,
    trading_account_no,
    status_description,
    status_description_lang,
    exchange,
    investor_account_no,
    account_display_name,
    account_type,
    t04_last_updated_by_id_u17,
    created_by_name,
    t04_approved_reason,
    t04_reject_reason,
    u07_institute_id_m02
)
AS
    SELECT t04.t04_id,
           t04.t04_trading_acc_id_u07,
           t04.t04_exchange_code_m01,
           t04.t04_no_of_approval,
           t04.t04_is_approval_completed,
           t04.t04_current_approval_level,
           t04.t04_next_status,
           t04.t04_created_date,
           t04.t04_last_updated_date,
           t04.t04_created_by_id_u17,
           t04.t04_status_id_v01,
           t04.t04_reason,
           u01.u01_id AS customer_id,
           u01.u01_customer_no AS customer_no,
           u01.u01_external_ref_no AS ext_customer_no,
           u01.u01_display_name AS full_name,
           u01.u01_display_name_lang AS full_name_lang,
           u07.u07_exchange_account_no AS trading_account_no,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m01.m01_description AS exchange,
           u06.u06_investment_account_no AS investor_account_no,
           u07.u07_display_name AS account_display_name,
           CASE
               WHEN u07.u07_type = 1 THEN 'Fully Disclosed'
               WHEN u07.u07_type = 2 THEN 'Non Disclosed'
               WHEN u07.u07_type = 3 THEN 'Swap'
           END
               AS account_type,
           t04.t04_last_updated_by_id_u17,
           u17_created_by.u17_full_name AS created_by_name,
           t04.t04_approved_reason,
           t04.t04_reject_reason,
           u07_institute_id_m02
      FROM t04_disable_exchange_acc_req t04
           LEFT JOIN u17_employee u17_created_by
               ON t04.t04_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON t04.t04_status_id_v01 = status_list.v01_id
           LEFT JOIN u07_trading_account u07
               ON t04.t04_trading_acc_id_u07 = u07.u07_id
           JOIN u01_customer u01 ON u07.u07_customer_id_u01 = u01.u01_id
           JOIN u06_cash_account u06
               ON u06.u06_id = u07.u07_cash_account_id_u06
           LEFT JOIN m01_exchanges m01
               ON t04.t04_exchange_id_m01 = m01.m01_id
/