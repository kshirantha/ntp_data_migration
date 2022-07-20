CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t15_account_closure_req
(
    t15_id,
    t15_cash_account_id_u06,
    t15_trading_account_id_u07,
    t15_member_code,
    u06_display_name,
    u07_display_name,
    u01_id,
    u01_customer_no,
    u01_external_ref_no,
    u01_display_name,
    u01_display_name_lang,
    u01_investor_id,
    t15_status_id_v01,
    approval_status,
    u06_investment_account_no,
    created_by,
    t15_created_date,
    t15_closure_reason,
    t15_reject_reason,
    t15_sent_to_exchange,
    t15_approved_reason,
    t15_no_of_approval,
    t15_current_approval_level,
    t15_exchange_account_no,
    u07_institute_id_m02
)
AS
    SELECT t15.t15_id,
           t15.t15_cash_account_id_u06,
           t15.t15_trading_account_id_u07,
           t15.t15_member_code,
           u06.u06_display_name,
           u07.u07_display_name,
           u01.u01_id,
           u01.u01_customer_no,
           u01.u01_external_ref_no,
           u01.u01_display_name,
           u01.u01_display_name_lang,
           u01.u01_investor_id,
           t15.t15_status_id_v01,
           status.v01_description AS approval_status,
           u06.u06_investment_account_no,
           u17_created_by.u17_full_name AS created_by,
           t15.t15_created_date,
           t15.t15_closure_reason,
           t15_reject_reason,
           t15.t15_sent_to_exchange,
           t15.t15_approved_reason,
           t15.t15_no_of_approval,
           t15.t15_current_approval_level,
           t15.t15_exchange_account_no,
           u07.u07_institute_id_m02
      FROM t15_authorization_request t15,
           u07_trading_account u07,
           u06_cash_account u06,
           u01_customer u01,
           vw_status_list status,
           u17_employee u17_created_by,
           u17_employee u17_modified_by
     WHERE     t15.t15_trading_account_id_u07 = u07.u07_id(+)
           AND t15.t15_cash_account_id_u06 = u06.u06_id(+)
           AND t15.t15_customer_id_u01 = u01.u01_id(+)
           AND t15.t15_status_id_v01 = status.v01_id
           AND t15.t15_created_by_id_u17 = u17_created_by.u17_id
           AND t15.t15_last_updated_by_id_u17 = u17_modified_by.u17_id
/