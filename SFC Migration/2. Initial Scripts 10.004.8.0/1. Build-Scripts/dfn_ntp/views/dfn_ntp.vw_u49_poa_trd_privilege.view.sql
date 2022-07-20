CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u49_poa_trd_privilege
(
    u49_id,
    u49_privilege_type_id_v31,
    u49_poa_id_u47,
    u49_trading_account_id_u07,
    u49_narration,
    u49_narration_lang,
    u49_issue_date,
    u49_poa_expiry_date,
    v31_name,
    v31_name_lang,
    u07_display_name
)
AS
    SELECT u49.u49_id,
           u49.u49_privilege_type_id_v31,
           u49.u49_poa_id_u47,
           u49.u49_trading_account_id_u07,
           u49.u49_narration,
           u49.u49_narration_lang,
           u49.u49_issue_date,
           u49.u49_poa_expiry_date,
           v31.v31_name,
           v31.v31_name_lang,
           u07.u07_display_name
      FROM u49_poa_trading_privileges u49
           JOIN v31_restriction v31
               ON u49.u49_privilege_type_id_v31 = v31.v31_id
           JOIN u07_trading_account u07
               ON u49.u49_trading_account_id_u07 = u07.u07_id;
/
