CREATE OR REPLACE FORCE VIEW dfn_ntp.t12_pending_stock_requests
(
    t12_id,
    t12_trading_acc_id_u07,
    t12_exchange_code_m01,
    t12_symbol_code_m20,
    t12_quantity,
    t12_avgcost,
    t12_customer_id_u01,
    t12_txn_type,
    t12_txn_type_id,
    status,
    t12_status_id_v01,
    t12_timestamp,
    t12_seller_memebr_code,
    t12_current_approval_level,
    u17_full_name,
    t12_last_changed_date,
    m20_short_description,
    m20_vwap,
    u07_display_name,
    u01_id,
    u01_customer_no,
    u01_full_name,
    u01_default_id_no,
    m26_name,
    t12_exng_fee,
    t12_brk_fee,
    t12_exg_vat,
    t12_brk_vat,
    t12_inst_id_m02,
    u07_exchange_account_no,
    t12_bulk_master_id_t61,
    t12_txn_category,
    u07_cash_account_id_u06,
    u07_exchange_id_m01,
    u07_customer_id_u01,
    u07_display_name_u01,
    u07_customer_no_u01,
    u07_exchange_account_no_buyer,
    t12_poa_id_u47,
    t12_channel_id_v29,
    t12_custodian_id_m26,
    t12_movement_type,
    t12_symbol_id_m20,
    m20_long_description,
    m20_instrument_type_code_v09,
    m20_isincode,
    t12_exg_discount,
    t12_brk_discount,
    t12_narration,
    u07_id,
    u07_status_id_v01,
    t12_buyer_trading_ac_id_u07,
    u01_external_ref_no
)
AS
    SELECT TO_CHAR (t12.t12_id) AS t12_id, -- change due to javascript max length issue
           t12.t12_trading_acc_id_u07,
           t12.t12_exchange_code_m01,
           t12.t12_symbol_code_m20,
           t12.t12_quantity,
           t12.t12_avgcost,
           t12.t12_customer_id_u01,
           CASE
               WHEN t12.t12_txn_type = 1 THEN 'Stock Deposit'
               WHEN t12.t12_txn_type = 2 THEN 'Stock Withdraw'
               WHEN t12.t12_txn_type = 3 THEN 'Bonus Issue'
               WHEN t12.t12_txn_type = 4 THEN 'Stock Adjustment'
               WHEN t12.t12_txn_type = 5 THEN 'Stock Split'
               WHEN t12.t12_txn_type = 6 THEN 'Split'
               WHEN t12.t12_txn_type = 7 THEN 'Stock Transfer'
               WHEN t12.t12_txn_type = 13 THEN 'Rights Subscription'
               WHEN t12.t12_txn_type = 14 THEN 'Rights Conversion'
               WHEN t12.t12_txn_type = 15 THEN 'Rights Reversal'
           END AS t12_txn_type,
           t12.t12_txn_type AS t12_txn_type_id,
           status.v01_description AS status,
           t12.t12_status_id_v01,
           t12.t12_timestamp,
           t12.t12_seller_memebr_code,
           t12.t12_current_approval_level,
           u17.u17_full_name,
           t12.t12_last_changed_date,
           m20.m20_short_description,
           m20.m20_vwap,
           u07.u07_display_name,
           u01.u01_id,
           u01.u01_customer_no,
           u01.u01_full_name,
           u01.u01_default_id_no,
           m26_custody.m26_name,
           t12.t12_exng_fee,
           t12.t12_brk_fee,
           t12.t12_exg_vat,
           t12.t12_brk_vat,
           t12.t12_inst_id_m02,
           u07.u07_exchange_account_no,
           t12_bulk_master_id_t61,
           t12_txn_category,
           u07.u07_cash_account_id_u06,
           u07.u07_exchange_id_m01,
           buyer.u07_customer_id_u01,
           buyer.u07_display_name_u01,
           buyer.u07_customer_no_u01,
           buyer.u07_exchange_account_no AS u07_exchange_account_no_buyer,
           t12_poa_id_u47,
           t12_channel_id_v29,
           t12_custodian_id_m26,
           t12_movement_type,
           t12_symbol_id_m20,
           m20.m20_long_description,
           m20.m20_instrument_type_code_v09,
           m20.m20_isincode,
           t12.t12_exg_discount,
           t12.t12_brk_discount,
           t12_narration,
           u07.u07_id,
           u07.u07_status_id_v01,
           t12_buyer_trading_ac_id_u07,
           u01.u01_external_ref_no
    FROM t12_share_transaction_all t12,
         u17_employee u17,
         u01_customer u01,
         m20_symbol m20,
         u07_trading_account u07,
         vw_status_list status,
         vw_m26_custody m26_custody,
         u07_trading_account buyer
    WHERE     t12.t12_last_changed_by_id_u17 = u17.u17_id(+)
          AND t12.t12_customer_id_u01 = u01.u01_id(+)
          AND t12.t12_symbol_id_m20 = m20.m20_id(+)
          AND t12.t12_trading_acc_id_u07 = u07.u07_id(+)
          AND t12.t12_status_id_v01 = status.v01_id
          AND t12.t12_buyer_trading_ac_id_u07 = buyer.u07_id(+)
          AND t12.t12_custodian_id_m26 = m26_custody.m26_id
/