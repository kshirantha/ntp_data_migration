CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_user_reg_cash_accounts
(
    "cashAccId",
    "cashAccName",
    "curr",
    "marginStatus",
    "customerNo",
    "invAccNo",
    "routeId"
)
AS
    SELECT u06_id AS "cashAccId",
           u06_display_name AS "cashAccName",
           u06_currency_code_m03 AS "curr",
           u06_margin_enabled AS "marginStatus",
           u06_customer_no_u01 AS "customerNo",
           u06_investment_account_no AS "invAccNo",
           u06_customer_id_u01 AS "routeId"
      FROM u06_cash_account
/