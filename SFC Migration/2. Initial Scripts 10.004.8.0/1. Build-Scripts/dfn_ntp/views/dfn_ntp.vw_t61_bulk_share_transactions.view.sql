CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t61_bulk_share_transactions
(
    t61_id,
    t61_transaction_type,
    t61_institute_id_m02,
    t61_movement_type,
    t61_seller_trading_ac_id_u07,
    t61_buyer_trading_ac_id_u07,
    t61_seller_member_code,
    t61_seller_exchange_ac,
    t61_buyer_member_code,
    t61_buyer_exchange_ac,
    t61_created_by_id_u17,
    t61_created_date,
    t61_narration,
    t61_status_id_v01,
    t61_status_changed_date,
    t61_status_changed_by_id_u17,
    t61_custom_type,
    t61_allow_cash_overdraw,
    status,
    status_lang,
    created_by_full_name,
    status_changed_by_full_name,
    allow_cash_overdraw,
    is_send_to_exchange,
    u01_id,
    u01_customer_no,
    u07_display_name,
    u07_display_name_buyer,
    u01_full_name
)
AS
    SELECT a.t61_id,
           'Security Transfer-Bulk' AS t61_transaction_type,
           a.t61_institute_id_m02,
           a.t61_movement_type,
           a.t61_seller_trading_ac_id_u07,
           a.t61_buyer_trading_ac_id_u07,
           a.t61_seller_member_code,
           a.t61_seller_exchange_ac,
           a.t61_buyer_member_code,
           a.t61_buyer_exchange_ac,
           a.t61_created_by_id_u17,
           a.t61_created_date,
           a.t61_narration,
           a.t61_status_id_v01,
           a.t61_status_changed_date,
           a.t61_status_changed_by_id_u17,
           a.t61_custom_type,
           a.t61_allow_cash_overdraw,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           CASE WHEN t61_allow_cash_overdraw = 1 THEN 'Yes' ELSE 'No' END
               AS allow_cash_overdraw,
           CASE WHEN t61_send_to_exchange = 1 THEN 'Yes' ELSE 'No' END
               AS is_send_to_exchange,
           u01_id,
           u01_customer_no,
           u07.u07_display_name,
           u07_buy.u07_display_name AS u07_display_name_buyer,
           u01.u01_full_name
      FROM t61_bulk_share_transactions a
           JOIN u07_trading_account u07
               ON a.t61_seller_trading_ac_id_u07 = u07.u07_id
           JOIN u07_trading_account u07_buy
               ON a.t61_buyer_trading_ac_id_u07 = u07_buy.u07_id
           JOIN u01_customer u01 ON u01.u01_id = u07.u07_customer_id_u01
           JOIN vw_status_list status_list
               ON a.t61_status_id_v01 = status_list.v01_id
           JOIN u17_employee u17_created_by
               ON a.t61_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON a.t61_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
/