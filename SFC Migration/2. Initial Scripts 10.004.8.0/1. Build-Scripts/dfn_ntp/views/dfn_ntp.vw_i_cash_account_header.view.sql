CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_cash_account_header
(
    "cashAccId",
    "cashAccName",
    "curr",
    "isMar",
    "loginId",
    "invAccNo",
    "routeId",
    "mutualFundAcc"
)
AS
    SELECT u06_id AS "cashAccId",
           u06_display_name AS "cashAccName",
           u06_currency_code_m03 AS "curr",
           u06_margin_enabled AS "isMar",
           u30_login_id_u09 AS "loginId",
           u06_investment_account_no AS "invAccNo",
           u06_customer_id_u01 AS "routeId",
           u06_mutual_fund_account AS "mutualFundAcc"
      FROM u06_cash_account, u30_login_cash_acc
     WHERE u06_id = u30_cash_acc_id_u06
/