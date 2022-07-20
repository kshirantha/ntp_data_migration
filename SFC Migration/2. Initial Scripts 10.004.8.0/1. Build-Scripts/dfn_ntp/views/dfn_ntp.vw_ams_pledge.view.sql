CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_ams_pledge
(
    enterdate,
    exchange,
    symbol,
    pledgequantity,
    rejecteddate,
    approved1date,
    approved2date,
    id,
    t20_status_id_v01,
    status,
    t20_send_to_exchange,
    sentto_exchange,
    send_to_exchange_result,
    t20_pledge_type,
    pledge_type,
    mubasherno,
    custname,
    branch_id,
    pledgee,
    pledgor,
    exchangeaccountno,
    pledgecallmember,
    pledgecallaccno,
    nin,
    custexternalno,
    chargeamount,
    narration,
    rejectreason,
    enteredby,
    approved1by,
    approved2by,
    rejectedby,
    t17_pledge_req_status,
    restriction_type,
    t17_exchange_vat,
    t17_broker_vat,
    total_vat
)
AS
    SELECT t20_entered_date AS enterdate,
           t20_exchange AS exchange,
           t20_symbol AS symbol,
           t20_qty AS pledgequantity,
           a09_reject.a09_action_date AS rejecteddate,
           a09_approve_1.a09_action_date AS approved1date,
           a09_approve_2.a09_action_date AS approved2date,
           t20_id AS id,
           t20_status_id_v01 t17_status,
           v01.v01_description AS status,
           t20.t20_send_to_exchange,
           CASE
               WHEN t20.t20_send_to_exchange = 0 THEN 'NO'
               WHEN t20.t20_send_to_exchange = 1 THEN 'YES'
           END
               AS sentto_exchange,
           t20.t20_send_to_exchange_result AS send_to_exchange_result,
           t20.t20_pledge_type,
           CASE
               WHEN t20.t20_pledge_type = 8 THEN 'PLEDGE IN'
               WHEN t20.t20_pledge_type = 9 THEN 'PLEDGE OUT'
               ELSE 'PLEDGE CALL'
           END
               AS pledge_type,
           u01.u01_customer_no AS mubasherno,
           u01_display_name AS custname,
           u01.u01_institute_id_m02 AS branch_id,
           t20_pledgee AS pledgee,
           t20_pledgor AS pledgor,
           t20_pledgor_ac_no AS exchangeaccountno,
           t20_pledge_call_member AS pledgecallmember,
           t20_pledge_call_ac_no AS pledgecallaccno,
           t20_nin AS nin,
           u01_customer_no AS custexternalno,
           (t20_exchange_fee + t20_broker_fee) AS chargeamount,
           t20_narration AS narration,
           t20_reject_reason AS rejectreason,
           ent.u17_full_name AS enteredby,
           approve_1.u17_full_name AS approved1by,
           approve_2.u17_full_name AS approved2by,
           reject.u17_full_name AS rejectedby,
           t20_pledge_txn_type AS t17_pledge_req_status,
           CASE
               WHEN t20.t20_pledge_txn_type = 0 THEN 'Quantity Only'
               WHEN t20.t20_pledge_txn_type = 1 THEN 'Symbol Only'
               WHEN t20.t20_pledge_txn_type = 2 THEN 'Entire Security A/C'
           END
               AS restriction_type,
           t20_exg_vat AS t17_exchange_vat,
           t20_brk_vat AS t17_broker_vat,
           (t20_exg_vat + t20_brk_vat) AS total_vat
      FROM t20_pending_pledge t20
           INNER JOIN v01_system_master_data v01
               ON t20_status_id_v01 = v01.v01_id AND v01_type = 4
           INNER JOIN u01_customer u01
               ON u01.u01_id = t20.t20_customer_id_u01
           LEFT OUTER JOIN a09_function_approval_log_all a09_approve_1
               ON     a09_approve_1.a09_request_id = t20_id
                  AND a09_approve_1.a09_status_id_v01 = 101
           LEFT OUTER JOIN u17_employee approve_1
               ON approve_1.u17_id = a09_approve_1.a09_action_by_id_u17
           LEFT OUTER JOIN a09_function_approval_log_all a09_approve_2
               ON     a09_approve_2.a09_request_id = t20_id
                  AND a09_approve_2.a09_status_id_v01 = 2
           LEFT OUTER JOIN u17_employee approve_2
               ON approve_2.u17_id = a09_approve_2.a09_action_by_id_u17
           LEFT OUTER JOIN u17_employee ent
               ON ent.u17_id = t20_entered_by_id_u17
           LEFT OUTER JOIN a09_function_approval_log_all a09_reject
               ON     a09_reject.a09_request_id = t20_id
                  AND a09_approve_2.a09_status_id_v01 = 3
           LEFT OUTER JOIN u17_employee reject
               ON reject.u17_id = a09_reject.a09_action_by_id_u17
/
