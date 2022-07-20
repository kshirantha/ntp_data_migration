CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_tradingacc_for_dealer
(
    dealerid,
    tradinggroup,
    tradingaccid
)
AS
    SELECT DISTINCT
           m51_employee_trading_groups.m51_employee_id_u17 AS dealerid,
           m51_employee_trading_groups.m51_trading_group_id_m08
               AS tradinggroup,
           u07_trading_account.u07_id AS tradingaccid
      FROM     u07_trading_account
           INNER JOIN
               m51_employee_trading_groups
           ON u07_trading_account.u07_trading_group_id_m08 =
                  m51_employee_trading_groups.m51_trading_group_id_m08;
/
