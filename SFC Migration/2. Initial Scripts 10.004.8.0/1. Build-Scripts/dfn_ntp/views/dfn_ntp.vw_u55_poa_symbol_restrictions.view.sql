CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u55_poa_symbol_restrictions
(
    u07_id,
    u55_id,
    u55_poa_id_u47,
    u55_symbol_id_m20,
    u55_trading_account_id_u07,
    u55_buy_restrict,
    buy_restrict,
    u55_sell_restrict,
    sell_restrict,
    u55_status_id_v01,
    u55_created_by_id_u17,
    u55_modified_by_id_u17,
    u55_status_changed_by_id_u17,
    u55_created_date,
    u55_modified_date,
    u55_status_changed_date,
    u55_symbol_code_m20,
    u07_display_name,
    u07_exchange_account_no,
    u07_exchange_code_m01,
    u07_customer_id_u01,
    status_description
)
AS
    SELECT u07.u07_id,
           u55.u55_id,
           u55.u55_poa_id_u47,
           u55.u55_symbol_id_m20,
           u55.u55_trading_account_id_u07,
           u55.u55_buy_restrict,
           CASE WHEN u55.u55_buy_restrict = 0 THEN 'No' ELSE 'Yes' END
               AS buy_restrict,
           u55.u55_sell_restrict,
           CASE WHEN u55.u55_sell_restrict = 0 THEN 'No' ELSE 'Yes' END
               AS sell_restrict,
           u55.u55_status_id_v01,
           u55.u55_created_by_id_u17,
           u55.u55_modified_by_id_u17,
           u55.u55_status_changed_by_id_u17,
           u55.u55_created_date,
           u55.u55_modified_date,
           u55.u55_status_changed_date,
           u55.u55_symbol_code_m20,
           u07.u07_display_name,
           u07.u07_exchange_account_no,
           u07.u07_exchange_code_m01,
           u07.u07_customer_id_u01,
           status_list.v01_description AS status_description
      FROM u55_poa_symbol_restrictions u55
           JOIN u07_trading_account u07
               ON u55.u55_trading_account_id_u07 = u07.u07_id
           LEFT JOIN vw_status_list status_list
               ON u55.u55_status_id_v01 = status_list.v01_id;
/
