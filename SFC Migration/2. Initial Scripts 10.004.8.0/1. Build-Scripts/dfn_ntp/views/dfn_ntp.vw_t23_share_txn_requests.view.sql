CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t23_share_txn_requests
(
    t23_id,
    t23_batch_id,
    t23_type,
    type_desc,
    t23_exchange_id_m01,
    m01_exchange_code,
    t23_trading_acc_id_u07,
    t23_custodian_id_m26,
    m26_sid,
    t23_reference,
    v33_description,
    t23_position_date,
    u07_customer_no_u01,
    u07_display_name_u01,
    u07_institute_id_m02,
    t23_exchange_acc_no,
    t23_symbol_id_m20,
    t23_file_symbol,
    m20_short_description,
    t23_last_trade_price,
    t23_status_id_v01,
    v01_description,
    old_balance,
    current_balance,
    difference,
    other_symbol_id,
    other_symbol_code,
    t23_upload_date,
    t23_changed_date,
    t23_processed_date,
    t23_processed_by_id_u17,
    processed_by,
    t23_status_changed_date,
    t23_status_changed_by_id_u17,
    status_changed_by,
    t23_no_of_approval,
    t23_is_approval_completed,
    t23_current_approval_level,
    t23_next_status,
    t23_reject_reason,
    t23_failed_reason,
    t23_primary_institute_id_m02
)
AS
      SELECT t23.t23_id,
             t23.t23_batch_id,
             t23.t23_type,
             DECODE (t23.t23_type,
                     1, 'Corporate Actions',
                     2, 'Weekly Reconciliation',
                     3, 'IPO Holding Upload')
                 AS type_desc,
             t23.t23_exchange_id_m01,
             m01.m01_exchange_code,
             t23.t23_trading_acc_id_u07,
             t23.t23_custodian_id_m26,
             m26.m26_sid,
             t23.t23_reference,
             v33.v33_description,
             t23.t23_position_date,
             u07.u07_customer_no_u01,
             u07.u07_display_name_u01,
             u07.u07_institute_id_m02,
             t23.t23_exchange_acc_no,
             t23.t23_symbol_id_m20,
             t23.t23_file_symbol,
             m20.m20_short_description,
             t23.t23_last_trade_price,
             t23.t23_status_id_v01,
             status.v01_description,
             t23.t23_file_current_balance - t23.t23_current_balance_difference
                 AS old_balance,
             t23.t23_file_current_balance AS current_balance,
             t23.t23_current_balance_difference AS difference,
             t23.t23_other_symbol_id_m20 AS other_symbol_id,
             m20_other.m20_symbol_code AS other_symbol_code,
             t23.t23_upload_date,
             t23.t23_changed_date,
             t23.t23_processed_date,
             t23.t23_processed_by_id_u17,
             u17.u17_full_name AS processed_by,
             t23.t23_status_changed_date,
             t23.t23_status_changed_by_id_u17,
             u17_status_changed.u17_full_name AS status_changed_by,
             t23.t23_no_of_approval,
             t23.t23_is_approval_completed,
             t23.t23_current_approval_level,
             t23.t23_next_status,
             t23.t23_reject_reason,
             t23.t23_failed_reason,
             t23.t23_primary_institute_id_m02
        FROM t23_share_txn_requests t23
             JOIN u07_trading_account u07
                 ON t23.t23_trading_acc_id_u07 = u07.u07_id
             JOIN m20_symbol m20
                 ON t23.t23_symbol_id_m20 = m20.m20_id
             JOIN m01_exchanges m01
                 ON t23.t23_exchange_id_m01 = m01.m01_id
             JOIN vw_status_list status
                 ON t23.t23_status_id_v01 = status.v01_id
             JOIN m26_executing_broker m26
                 ON t23.t23_custodian_id_m26 = m26.m26_id
             LEFT JOIN v33_corporate_action_types v33
                 ON t23.t23_reference = v33.v33_id AND t23.t23_type = 1
             LEFT JOIN m20_symbol m20_other
                 ON t23.t23_other_symbol_id_m20 = m20_other.m20_id
             JOIN u17_employee u17
                 ON t23.t23_processed_by_id_u17 = u17.u17_id
             LEFT JOIN u17_employee u17_status_changed
                 ON t23.t23_status_changed_by_id_u17 =
                        u17_status_changed.u17_id
    ORDER BY t23.t23_id DESC
/