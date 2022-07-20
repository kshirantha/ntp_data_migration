CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_block_amount_details
(
    transaction_id,
    reference,
    cash_acc_id,
    transaction_date,
    value_date,
    transaction_code,
    description,
    transaction_amount,
    status,
    status_id,
    available_balance,
    created_date,
    created_by,
    last_updated_date,
    last_updated_by
)
AS
    SELECT t11.t11_trns_id || '' AS transaction_id,
           t11.t11_cash_trns_id_t06 || '' AS reference,
           t11.t11_id_u06 AS cash_acc_id,
           t11.t11_trns_date AS transaction_date,
           t11.t11_value_date AS value_date,
           t11.t11_trans_code AS transaction_code,
           TO_CHAR (t11.t11_trans_description) AS description,
           ABS (t11.t11_trans_amount) AS transaction_amount,
           status.v01_description AS status,
           t11.t11_status AS status_id,
           t11.t11_balance_u06 AS available_balance,
           t11.t11_created_date AS created_date,
           u17_created_by.u17_full_name AS created_by,
           t11.t11_status_change_date AS last_updated_date,
           u17_status_changed_by.u17_full_name AS last_updated_by
      FROM t11_block_amount_details t11
           JOIN u17_employee u17_created_by
               ON t11.t11_created_by = u17_created_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON t11.t11_status_change_by = u17_status_changed_by.u17_id
           JOIN vw_status_list status
               ON t11.t11_status = status.v01_id
     WHERE t11.t11_status <> 2
    UNION ALL
    SELECT t01.t01_cl_ord_id AS transaction_id,
           t01.t01_cl_ord_id AS reference,
           u06.u06_id AS cash_acc_id,
           t01.t01_date_time AS transaction_date,
           t01.t01_date_time AS value_date,
           CASE t01.t01_side WHEN 1 THEN 'Buy' WHEN 2 THEN 'Sell' END
               AS trans_code,
           CASE t01.t01_side
               WHEN 1 THEN 'Buy Order'
               WHEN 2 THEN 'Sell Order'
           END
               AS description,
           ABS (t01.t01_block_amount) AS transaction_amount,
           '' AS status,
           NULL AS status_id,
           u06.u06_balance AS available_balance,
           t01.t01_date_time AS created_date,
           NULL AS created_by,
           t01.t01_last_updated_date_time AS status_changed_date,
           NULL AS status_changed_by
      FROM t01_order_all t01, u06_cash_account u06
     WHERE t01.t01_cash_acc_id_u06 = u06.u06_id AND t01.t01_block_amount > 0
/
