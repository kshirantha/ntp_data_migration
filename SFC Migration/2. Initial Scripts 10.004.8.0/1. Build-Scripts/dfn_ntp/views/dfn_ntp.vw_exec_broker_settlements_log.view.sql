CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_exec_broker_settlements_log
(
    t79_id,
    t79_id_t83,
    t79_institute_id_m02,
    t79_custodian_id_m26,
    t79_cash_acc_id_m185,
    t79_txn_id_m97,
    t79_txn_code_m97,
    t79_amnt_in_stl_currency,
    t79_amnt_in_txn_currency,
    t79_fx_rate,
    t79_txn_date,
    t79_txn_currency_code_m03,
    t79_stl_currency_code_m03,
    t79_created_by_u17,
    t79_created_date,
    t79_status_id_v01,
    t79_status_change_by_u17,
    t79_status_change_date,
    t79_custom_type,
    created_by_name,
    status_changed_by_name,
    status,
    m185_accountno,
    m26_name,
    t79_current_approval_level
)
AS
    SELECT a.t79_id,
           a.t79_id_t83,
           a.t79_institute_id_m02,
           a.t79_custodian_id_m26,
           a.t79_cash_acc_id_m185,
           a.t79_txn_id_m97,
           a.t79_txn_code_m97,
           a.t79_amnt_in_stl_currency,
           a.t79_amnt_in_txn_currency,
           a.t79_fx_rate,
           a.t79_txn_date,
           a.t79_txn_currency_code_m03,
           a.t79_stl_currency_code_m03,
           a.t79_created_by_u17,
           a.t79_created_date,
           a.t79_status_id_v01,
           a.t79_status_change_by_u17,
           a.t79_status_change_date,
           a.t79_custom_type,
           u17_created_by.u17_full_name AS created_by_name,
           u17_status_changed.u17_full_name AS status_changed_by_name,
           status_list.v01_description AS status,
           m185.m185_accountno,
           m26.m26_name,
           t79_current_approval_level
      FROM t79_custody_excb_cash_acnt_log a
           JOIN m185_custody_excb_cash_account m185
               ON a.t79_cash_acc_id_m185 = m185.m185_id
           JOIN m26_executing_broker m26
               ON a.t79_custodian_id_m26 = m26.m26_id
           LEFT JOIN u17_employee u17_created_by
               ON a.t79_created_by_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_status_changed
               ON a.t79_status_change_by_u17 = u17_status_changed.u17_id
           LEFT JOIN vw_status_list status_list
               ON a.t79_status_id_v01 = status_list.v01_id
     WHERE t79_id_t83 IS NOT NULL
/
