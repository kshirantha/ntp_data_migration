CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_bulk_pledges
(
    t20_ref_no,
    t20_entered_date,
    total_pledge_qty,
    t20_entered_by_id_u17,
    entered_by,
    t20_status_id_v01,
    status,
    t20_send_to_exchange,
    send_to_exchange,
    t20_pledge_type,
    pledge_type,
    t20_trading_acc_id_u07,
    u07_display_name,
    u01_id,
    u01_customer_no,
    u01_full_name,
    u01_external_ref_no,
    u01_institute_id_m02,
    t20_current_approval_level,
    t20_no_of_approval,
    t20_pledgee,
    t20_pledgor,
    t20_pledgor_ac_no,
    t20_nin,
    t20_pledge_call_member,
    t20_pledge_call_ac_no,
    t20_pledge_value,
    t20_narration,
    t20_exchange_fee,
    t20_broker_fee,
    t20_send_to_exchange_result,
    t20_custodian_id
)
AS
      SELECT t20.t20_ref_no,
             MAX (t20.t20_entered_date) AS t20_entered_date,
             SUM (t20.t20_qty) AS total_pledge_qty,
             MAX (t20_entered_by_id_u17) AS t20_entered_by_id_u17,
             MAX (u17l.u17_full_name) AS entered_by,
             t20_status_id_v01,
             status_list.v01_description AS status,
             MAX (t20_send_to_exchange) AS t20_send_to_exchange,
             CASE
                 WHEN MAX (t20.t20_send_to_exchange) = 0 THEN 'Internal'
                 WHEN MAX (t20.t20_send_to_exchange) = 1 THEN 'Exchange'
             END
                 AS send_to_exchange,
             t20_pledge_type,
             CASE
                 WHEN t20.t20_pledge_type = '8' THEN 'IN'
                 WHEN t20.t20_pledge_type = '9' THEN 'OUT'
             END
                 AS pledge_type,
             t20_trading_acc_id_u07,
             MAX (u07_display_name) AS u07_display_name,
             MAX (u01.u01_id) AS u01_id,
             MAX (u01.u01_customer_no) AS u01_customer_no,
             MAX (u01.u01_full_name) AS u01_full_name,
             MAX (u01.u01_external_ref_no) AS u01_external_ref_no,
             MAX (u01.u01_institute_id_m02) AS u01_institute_id_m02,
             MAX (t20_current_approval_level) AS t20_current_approval_level,
             MAX (t20_no_of_approval) AS t20_no_of_approval,
             MAX (t20_pledgee) AS t20_pledgee,
             MAX (t20_pledgor) AS t20_pledgor,
             MAX (t20_pledgor_ac_no) AS t20_pledgor_ac_no,
             MAX (t20_nin) AS t20_nin,
             MAX (t20_pledge_call_member) AS t20_pledge_call_member,
             MAX (t20_pledge_call_ac_no) AS t20_pledge_call_ac_no,
             MAX (t20_pledge_value) AS t20_pledge_value,
             MAX (t20_narration) AS t20_narration,
             MAX (t20_exchange_fee) AS t20_exchange_fee,
             MAX (t20_broker_fee) AS t20_broker_fee,
             MAX (t20_send_to_exchange_result) AS t20_send_to_exchange_result,
             MAX (t20_custodian_id) AS t20_custodian_id
        FROM t20_pending_pledge t20
             LEFT JOIN u07_trading_account u07
                 ON t20.t20_trading_acc_id_u07 = u07.u07_id AND t20.t20_ref_no IS NOT NULL
             LEFT JOIN u01_customer u01
                 ON u07.u07_customer_id_u01 = u01.u01_id
             LEFT JOIN vw_status_list status_list
                 ON t20.t20_status_id_v01 = status_list.v01_id
             LEFT JOIN u17_employee u17l
                 ON t20.t20_last_changed_by_id_u17 = u17l.u17_id
             LEFT JOIN u17_employee u17e
                 ON t20.t20_entered_by_id_u17 = u17e.u17_id
    GROUP BY t20_ref_no,
             t20_status_id_v01,
             t20_pledge_type,
             t20_trading_acc_id_u07,
             v01_description
/
