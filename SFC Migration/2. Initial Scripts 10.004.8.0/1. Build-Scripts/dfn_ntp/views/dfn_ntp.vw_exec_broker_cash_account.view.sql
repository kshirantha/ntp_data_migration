CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_exec_broker_cash_account
(
    m72_id,
    m72_accountno,
    m72_exec_broker_id_m26,
    m72_account_type,
    m72_currency_code_m03,
    m72_balance,
    m72_blocked_amount,
    m72_od_limit,
    m72_od_approved_by_id_u17,
    m72_od_approved_date,
    m72_created_by_id_u17,
    created_by_full_name,
    m72_created_date,
    m72_lastupdated_by_id_u17,
    last_updated_by_full_name,
    m72_lastupdated_date,
    m72_status_id_v01,
    status,
    m72_status_changed_by_id_u17,
    status_changed_by_full_name,
    m72_status_changed_date,
    m72_pending_withdr,
    m72_pending_depost,
    m72_swift_acc,
    m72_agent_acc_no,
    m72_currency_id_m03,
    m72_is_default,
    is_default
)
AS
    ( (SELECT a.m72_id,
              a.m72_accountno,
              a.m72_exec_broker_id_m26,
              a.m72_account_type,
              a.m72_currency_code_m03,
              a.m72_balance,
              a.m72_blocked_amount,
              a.m72_od_limit,
              a.m72_od_approved_by_id_u17,
              a.m72_od_approved_date,
              a.m72_created_by_id_u17,
              u17_created_by.u17_full_name AS created_by_full_name,
              a.m72_created_date,
              a.m72_lastupdated_by_id_u17,
              u17_last_updated_by.u17_full_name AS last_updated_by_full_name,
              a.m72_lastupdated_date,
              a.m72_status_id_v01,
              status_list.v01_description AS status,
              a.m72_status_changed_by_id_u17,
              u17_status_changed_by.u17_full_name
                  AS status_changed_by_full_name,
              a.m72_status_changed_date,
              a.m72_pending_withdr,
              a.m72_pending_depost,
              a.m72_swift_acc,
              a.m72_agent_acc_no,
              a.m72_currency_id_m03,
              a.m72_is_default,
              CASE a.m72_is_default WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
                  AS is_default
         FROM m72_exec_broker_cash_account a
              LEFT JOIN u17_employee u17_created_by
                  ON a.m72_created_by_id_u17 = u17_created_by.u17_id
              LEFT JOIN u17_employee u17_last_updated_by
                  ON a.m72_lastupdated_by_id_u17 = u17_last_updated_by.u17_id
              LEFT JOIN u17_employee u17_status_changed_by
                  ON a.m72_status_changed_by_id_u17 =
                         u17_status_changed_by.u17_id
              LEFT JOIN vw_status_list status_list
                  ON a.m72_status_id_v01 = status_list.v01_id))
/