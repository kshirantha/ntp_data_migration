CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_user_reg_trading_account
(
    "tradingAccId",
    "tradingAccName",
    "isDefaultAccount",
    "exchange",
    "cashAccountId",
    "customerNo",
    "routeId"
)
AS
    SELECT u07_id AS "tradingAccId",
           u07_display_name AS "tradingAccName",
           u07_is_default AS "isDefaultAccount",
           u07_exchange_code_m01 AS "exchange",
           u07_cash_account_id_u06 AS "cashAccountId",
           u07_customer_no_u01 AS "customerNo",
           u07_customer_id_u01 AS "routeId"
      FROM u07_trading_account
/