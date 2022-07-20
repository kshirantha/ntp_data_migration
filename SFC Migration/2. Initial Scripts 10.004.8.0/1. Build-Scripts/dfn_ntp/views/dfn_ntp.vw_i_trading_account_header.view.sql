CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_trading_account_header
(
   "tradingAccId",
   "tradingAccName",
   "isDefaultAccount",
   "exchange",
   "cashAccountId",
   "loginId",
   "routeId", 
   "status",
   "smsNotifi",
   "emailNotifi" )
AS
SELECT u07_id AS "tradingAccId",
       u07_display_name AS "tradingAccName",
       u07_is_default AS "isDefaultAccount",
       u07_exchange_code_m01 AS "exchange",
       u07_cash_account_id_u06 AS "cashAccountId",
       U10_LOGIN_ID_U09 AS "loginId",
       U07_CUSTOMER_ID_U01 AS "routeId",
	   u07_status_id_v01 AS "status",
	   U07_SMS_NOTIFICATION AS "smsNotifi",
       U07_EMAIL_NOTIFICATION AS "emailNotifi"
  FROM u07_trading_account, u10_login_trading_acc
 WHERE u07_id = U10_TRADING_ACC_ID_U07
/



