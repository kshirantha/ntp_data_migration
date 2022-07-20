CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_ams_stock_transaction
(
    transactionid,
    createddate,
    stockname,
    portfoliono,
    marketid,
    stockcode,
    quantity,
    status,
    transactiontype,
    approveddate,
    cancelledby,
    cancelleddate,
    sellerexchaccountno,
    buyerexchaccountno,
    sellermembercode,
    sellernin,
    buyermembercode,
    buyernin,
    movementtype,
    narration,
    rejectedreason,
    t24_exchange_vat,
    t24_broker_vat,
    total_vat
)
AS
    SELECT t12_id AS transactionid,
           t12_timestamp AS createddate,
           m20.m20_long_description AS stockname,
           u07_exchange_account_no AS portfoliono,
           t12_exchange_code_m01 AS marketid,
           t12_symbol_code_m20 AS stockcode,
           t12_quantity AS quantity,
           v01.v01_description AS status,
           m97.m97_description AS transactiontype,
           a09_approve_2.a09_action_date AS approveddate,
           u17_cancel.u17_full_name AS cancelledby,
           a09_cancel.a09_action_date AS cancelleddate,
           t12_seller_exchange_ac AS sellerexchaccountno,
           t12_buyer_exchange_ac AS buyerexchaccountno,
           t12_seller_memebr_code AS sellermembercode,
           t12_seller_nin AS sellernin,
           t12_buyer_member_code AS buyermembercode,
           t12_buyer_nin AS buyernin,
           CASE
               WHEN UPPER (t12.t12_movement_type) = 'U'
               THEN
                   'Off Market Trade'
               WHEN UPPER (t12.t12_movement_type) = 'A'
               THEN
                   'Others'
               WHEN UPPER (t12.t12_movement_type) = 'M'
               THEN
                   'Murabaha Movement'
           END
               AS movementtype,
           t12_narration AS narration,
           t12_reject_reason AS rejectedreason,
           t12_brk_vat AS t24_exchange_vat,
           t12_brk_vat AS t24_broker_vat,
           (t12.t12_brk_vat + t12.t12_brk_vat) AS total_vat
      FROM t12_share_transaction t12
           INNER JOIN v01_system_master_data v01
               ON v01.v01_id = t12.t12_status_id_v01 AND v01_type = 4
           INNER JOIN m97_transaction_codes m97
               ON t12.t12_code_m97 = m97.m97_code
           INNER JOIN u07_trading_account u07
               ON u07.u07_id = t12.t12_trading_acc_id_u07
           INNER JOIN m20_symbol m20
               ON     t12.t12_symbol_code_m20 = m20.m20_symbol_code
                  AND t12_exchange_code_m01 = m20.m20_price_exchange_code_m01
           LEFT OUTER JOIN a09_function_approval_log_all a09_approve_2
               ON     a09_approve_2.a09_request_id = t12_id
                  AND a09_approve_2.a09_status_id_v01 = 2
           LEFT OUTER JOIN u17_employee approve_2
               ON approve_2.u17_id = a09_approve_2.a09_action_by_id_u17
           LEFT OUTER JOIN a09_function_approval_log_all a09_cancel
               ON     a09_cancel.a09_request_id = t12_id
                  AND a09_cancel.a09_status_id_v01 = 19
           LEFT OUTER JOIN u17_employee u17_cancel
               ON u17_cancel.u17_id = a09_cancel.a09_action_by_id_u17
/
