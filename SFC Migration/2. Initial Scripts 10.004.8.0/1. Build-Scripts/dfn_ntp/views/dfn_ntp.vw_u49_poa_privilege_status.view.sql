CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u49_poa_privilege_status
(
    u07_id,
    u52_id,
    u07_institute_id_m02,
    u07_customer_id_u01,
    u07_cash_account_id_u06,
    u07_exchange_code_m01,
    u07_display_name,
    pending_restriction,
    pending_restriction_text
)
AS
    SELECT a.u07_id,
           u52.u52_id,
           a.u07_institute_id_m02,
           a.u07_customer_id_u01,
           a.u07_cash_account_id_u06,
           a.u07_exchange_code_m01,
           a.u07_display_name,
           CASE WHEN u52.u52_trading_account_id_u07 IS NULL THEN 0 ELSE 1 END
               AS pending_restriction,
           CASE
               WHEN u52.u52_trading_account_id_u07 IS NULL THEN ''
               ELSE 'Yes'
           END
               AS pending_restriction_text
      FROM u07_trading_account a
           JOIN u47_power_of_attorney u47
               ON u47.u47_customer_id_u01 = a.u07_customer_id_u01
           LEFT JOIN (SELECT *
                        FROM u52_poa_trad_privilege_pending
                       WHERE u52_status_id_v01 = 1) u52
               ON     a.u07_id = u52.u52_trading_account_id_u07
                  AND u47.u47_id = u52.u52_poa_id_u47;
/
