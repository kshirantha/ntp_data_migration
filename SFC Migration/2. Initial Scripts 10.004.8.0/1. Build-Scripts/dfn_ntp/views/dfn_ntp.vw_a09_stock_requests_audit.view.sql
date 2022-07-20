CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_a09_stock_requests_audit
(
    t12_id,
    a09_status_id_v01,
    a09_action_by_id_u17,
    a09_action_date,
    u17_full_name,
    v01_description,
    v01_description_lang
)
AS
      SELECT t12.t12_id,
             a09.a09_status_id_v01,
             a09.a09_action_by_id_u17,
             a09.a09_action_date,
             u17.u17_full_name,
             status.v01_description,
             status.v01_description_lang
        FROM t12_share_transaction_all t12
             INNER JOIN a09_function_approval_log_all a09
                 ON     t12.t12_id = a09.a09_request_id
                    AND t12.t12_function_id_m88 = a09.a09_function_id_m88
             INNER JOIN u17_employee u17
                 ON a09.a09_action_by_id_u17 = u17.u17_id
             INNER JOIN vw_status_list status
                 ON a09.a09_status_id_v01 = status.v01_id
/