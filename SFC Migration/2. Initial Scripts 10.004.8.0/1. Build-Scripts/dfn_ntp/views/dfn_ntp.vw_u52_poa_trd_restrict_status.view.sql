CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u52_poa_trd_restrict_status
(
    u07_id,
    u52_id,
    u52_poa_id_u47,
    u52_trading_account_id_u07,
    u52_status_id_v01,
    status_description,
    u52_status_changed_by_id_u17,
    u52_status_changed_date,
    u07_display_name,
    u07_exchange_account_no,
    u07_exchange_code_m01,
    u07_customer_id_u01
)
AS
    SELECT u07.u07_id,
           u52.u52_id,
           u52.u52_poa_id_u47,
           u52.u52_trading_account_id_u07,
           u52.u52_status_id_v01,
           status_list.v01_description AS status_description,
           u52.u52_status_changed_by_id_u17,
           u52.u52_status_changed_date,
           u07.u07_display_name,
           u07.u07_exchange_account_no,
           u07.u07_exchange_code_m01,
           u07.u07_customer_id_u01
      FROM u52_poa_trad_privilege_pending u52
           JOIN u07_trading_account u07
               ON u52.u52_trading_account_id_u07 = u07.u07_id
           LEFT JOIN vw_status_list status_list
               ON u52.u52_status_id_v01 = status_list.v01_id;
/
