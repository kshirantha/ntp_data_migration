CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u59_trad_acc_fix_logins
(
    u59_trading_acc_id_u07,
    u59_fix_login_id_m67
)
AS
    SELECT u59_trading_acc_id_u07, u59_fix_login_id_m67
      FROM u59_trading_acc_fix_logins
/