CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_order_status_requests
(
    t62_customer_id_u01,
    t62_institution_id_m02,
    t62_exec_id,
    t62_exchange_code_m01,
    t62_symbol_id_m20,
    t62_symbol_code_m20,
    m20_short_description,
    t62_cl_ord_id,
    t62_cum_quantity,
    t62_status_id_v30,
    current_status,
    previous_status,
    t62_leaves_qty,
    t62_date_time,
    t62_ord_no,
    t62_last_updated_date_time,
    t62_quantity,
    t62_requested_by_id_u17,
    requested_by,
    t62_request_type,
    request_type,
    t62_narration,
    currency
)
AS
    SELECT t62.t62_customer_id_u01,
           t62.t62_institution_id_m02,
           t62.t62_exec_id,
           t62.t62_exchange_code_m01,
           t62.t62_symbol_id_m20,
           t62.t62_symbol_code_m20,
           m20.m20_short_description,
           t62.t62_cl_ord_id,
           t62.t62_cum_quantity,
           t62.t62_status_id_v30,
           current_status.v30_description AS current_status,
           previous_status.v30_description AS previous_status,
           t62.t62_leaves_qty,
           t62.t62_date_time,
           t62.t62_ord_no,
           t62.t62_last_updated_date_time,
           t62.t62_quantity,
           t62.t62_requested_by_id_u17,
           u17.u17_full_name AS requested_by,
           t62.t62_request_type,
           CASE
               WHEN t62.t62_request_type = 1 THEN 'Request'
               WHEN t62.t62_request_type = 2 THEN 'Response'
           END
               AS request_type,
           t62.t62_narration,
           t01.t01_settle_currency AS currency
      FROM t62_order_status_requests t62
           INNER JOIN v30_order_status current_status
               ON t62.t62_status_id_v30 = current_status.v30_status_id
           LEFT JOIN v30_order_status previous_status
               ON t62.t62_prev_status_id_v30 = previous_status.v30_status_id
           LEFT JOIN m20_symbol m20
               ON m20.m20_id = t62.t62_symbol_id_m20
           INNER JOIN u17_employee u17
               ON u17_id = t62_requested_by_id_u17
           INNER JOIN t01_order_all t01
               ON t62.t62_cl_ord_id = t01.t01_cl_ord_id
/
