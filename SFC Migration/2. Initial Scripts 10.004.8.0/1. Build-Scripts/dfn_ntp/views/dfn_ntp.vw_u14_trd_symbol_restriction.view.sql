CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u14_trd_symbol_restriction
(
    u14_id,
    u14_trd_acnt_id_u07,
    u07_display_name,
    u14_symbol_id_m20,
    m20_symbol_code,
    u14_restriction_id_v31
)
AS
    SELECT u14.u14_id,
           u14.u14_trd_acnt_id_u07,
           u07.u07_display_name,
           u14.u14_symbol_id_m20,
           m20.m20_symbol_code,
           u14.u14_restriction_id_v31
      FROM u14_trading_symbol_restriction u14
           JOIN u07_trading_account u07
               ON u14.u14_trd_acnt_id_u07 = u07.u07_id
           JOIN m20_symbol m20
               ON u14.u14_symbol_id_m20 = m20.m20_id
/