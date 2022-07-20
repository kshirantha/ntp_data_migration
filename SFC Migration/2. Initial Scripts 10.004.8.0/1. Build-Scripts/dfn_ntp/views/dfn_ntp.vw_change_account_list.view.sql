CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_change_account_list
(
    t502_id,
    customer_nin,
    from_customer,
    from_security_acc,
    targer_cash_account,
    target_customer,
    initiated_by,
    changed_by,
    t502_from_customer_id_u01,
    t502_from_trading_acc_id_u07,
    t502_from_cash_acc_id_u06,
    t502_target_cash_acc_id_u06,
    t502_status_id_v01,
    t502_institute_id_m02,
    entered_date,
    changed_date,
    current_approval_level,
    status_description,
    v01_description_lang,
    from_u07_exchange_account_no,
    target_u07_id,
    target_u07_exchange_account_no,
    target_customer_nin
)
AS
    SELECT t502.t502_id,
           u01.u01_default_id_no AS customer_nin,
           u01.u01_full_name AS from_customer,
           NVL (NVL (u07.u07_external_ref_no, u07.u07_display_name),
                u07.u07_exchange_code_m01 || ' - ' || u07.u07_id)
               AS from_security_acc,
           NVL (u06.u06_external_ref_no, u06.u06_investment_account_no)
               AS targer_cash_account,
           u01_target.u01_full_name AS target_customer,
           u17entered_by.u17_full_name AS initiated_by,
           u17changed_by.u17_full_name AS changed_by,
           u01.u01_id AS t502_from_customer_id_u01,
           t502_from_trading_acc_id_u07,
           t502_from_cash_acc_id_u06,
           t502_target_cash_acc_id_u06,
           t502_status_id_v01,
           t502_institute_id_m02,
           t502_entered_date AS entered_date,
           t502_last_changed_date AS changed_date,
           t502_current_approval_level AS current_approval_level,
           t502_status.v01_description AS status_description,
           t502_status.v01_description_lang,
           u07.u07_exchange_account_no AS from_u07_exchange_account_no,
           u07_target.u07_id AS target_u07_id,
           u07_target.u07_exchange_account_no
               AS target_u07_exchange_account_no,
           u07_target.u07_default_id_no_u01 AS target_customer_nin
      FROM t502_change_account_requests_c t502,
           u07_trading_account u07,
           u06_cash_account u06,
           u01_customer u01,
           u17_employee u17entered_by,
           u17_employee u17changed_by,
           v01_system_master_data t502_status,
           u01_customer u01_target,
           u07_trading_account u07_target
     WHERE     t502.t502_from_trading_acc_id_u07 = u07.u07_id
           AND t502.t502_target_cash_acc_id_u06 = u06.u06_id
           AND u06.u06_customer_id_u01 = u01_target.u01_id
           AND t502.t502_entered_by_id_u17 = u17entered_by.u17_id
           AND t502.t502_last_changed_by_id_u17 = u17changed_by.u17_id(+)
           AND t502_status.v01_type = 4
           AND t502.t502_status_id_v01 = t502_status.v01_id
           AND u07.u07_customer_id_u01 = u01.u01_id
           AND t502.t502_target_cash_acc_id_u06 =
                   u07_target.u07_cash_account_id_u06(+)
/