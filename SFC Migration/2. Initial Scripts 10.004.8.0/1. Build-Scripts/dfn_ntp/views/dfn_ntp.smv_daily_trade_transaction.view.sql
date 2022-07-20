CREATE OR REPLACE FORCE VIEW dfn_ntp.smv_daily_trade_transaction
(
    order_no,
    serial_no,
    transaction_date,
    order_type,
    delivery_channel,
    transaction_status,
    transaction_type,
    expiry_date,
    quantity,
    price,
    time_type,
    fill_term,
    fill_term_minimum,
    disclosed_volume,
    fees_before_discount,
    fees_amount,
    trading_amount,
    order_amount,
    rejection_reason,
    created_date,
    client_branch_id,
    average_product_cost,
    created_by_user_id,
    user_branch_id,
    market_fees_amount,
    market_fees_before_discount,
    broker_fees_amount,
    broker_fees_before_discount,
    transaction_fees_amount,
    value_date,
    transaction_source,
    service_charge,
    cash_account,
    client_id,
    settlement_account_no,
    product_id,
    side,
    orion_processing_status,
    account_no,
    remote_ord_id
)
AS
    SELECT TO_NUMBER (t01_ord_no) AS order_no,
           TO_NUMBER (t01_cl_ord_id) AS serial_no,
           TO_DATE (TO_CHAR (t02_txn_time, 'DD-Mon-YYYY hh24:mi:ss'),
                    'DD-Mon-YYYY hh24:mi:ss')
               AS transaction_date,
           CASE
               WHEN t01_ord_type_id_v06 = 1 AND t01_side = 2 THEN '51' --Market & Sell
               WHEN t01_ord_type_id_v06 = 1 AND t01_side = 1 THEN '02' --Market & Buy
               WHEN t01_ord_type_id_v06 = 2 AND t01_side = 1 THEN '01' --Limit & Buy
               WHEN t01_ord_type_id_v06 = 2 AND t01_side = 2 THEN '50' --Limit & Sell
               ELSE '0'
           END
               AS order_type,
           t01_ord_channel_id_v29 AS delivery_channel,
           6 AS transaction_status,
           3 AS transaction_type,
           NVL (t01_expiry_date, t01_db_created_date) AS expiry_date,
           t02_last_shares AS quantity,
           t02_last_price AS price,
           CASE
               WHEN t01_tif_id_v10 = 0 THEN '1' --Day
               WHEN t01_tif_id_v10 = 7 THEN '2' --End of Week
               WHEN t01_tif_id_v10 = 8 THEN '3' --End of Month
               WHEN t01_tif_id_v10 = 6 THEN '4' --Good Till Date
               WHEN t01_tif_id_v10 = 4 THEN '5' --Fill or Kill
               WHEN t01_tif_id_v10 = 2 THEN '6' --At the Opening
               WHEN t01_tif_id_v10 = 3 THEN '7' --FAR
               WHEN t01_tif_id_v10 = 1 THEN '8' --Good Till Cancel
               ELSE NULL
           END
               AS time_type,
           1 AS fill_term,
           t01_min_quantity AS fill_term_minimum,
           NULL AS disclosed_volume,
           ABS (t02_ord_value_adjst) AS fees_before_discount,
           ABS (t02_amnt_in_stl_currency) AS fees_amount,
           ABS (t02_ord_value_adjst) AS trading_amount,
           ABS (t02_amnt_in_stl_currency) AS order_amount,
           t01_reject_reason AS rejection_reason,
           t01_db_created_date AS created_date,
           t01_institution_id_m02 AS client_branch_id,
           ROUND (t01_avgcost, 5) AS average_product_cost,
           TO_CHAR (t01_dealer_id_u17) AS created_by_user_id,
           NULL AS user_branch_id,
           t02_exg_commission AS market_fees_amount,
           NULL AS market_fees_before_discount,
           (t02_commission_adjst - t02_exg_commission) AS broker_fees_amount,
           NULL AS broker_fees_before_discount,
           NULL AS transaction_fees_amount,
           t02_cash_settle_date AS value_date,
           NULL AS transaction_source,
           NULL AS service_charge,
           u06_external_ref_no AS cash_account,
           u01_external_ref_no AS client_id,
           u06_external_ref_no AS settlement_account_no,
           t01_symbol_code_m20 AS product_id,
           t01_side AS side,
           'A' AS orion_processing_status,
           SUBSTR (u07_display_name, 6) AS account_no,
           t01_remote_cl_ord_id AS remote_ord_id -- This column is not Integrated. Additional column used for comparing old and new systems. Integration does not break with this additional column
      FROM vw_t01_order_summary_daily
     WHERE     t02_txn_time BETWEEN TRUNC (SYSDATE - 1)
                                AND TRUNC (SYSDATE) + 0.99999
           AND t02_custodian_id_m26 = 1
/