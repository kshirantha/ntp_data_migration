CREATE OR REPLACE FORCE VIEW dfn_ntp.u06_cash_account_automation
(
    u06_id,
    u06_balance,
    u06_blocked,
    u06_investment_account_no,
    u06_pending_deposit
)
AS
    SELECT u06_id,
           TRIM (TO_CHAR (u06_balance, '999,999,999.99')) AS u06_balance,
           TRIM (TO_CHAR (u06_blocked, '999,999,999.99')) AS u06_blocked,
           u06_investment_account_no,
           TRIM (TO_CHAR (u06_pending_deposit, '999,999,999.99'))
               AS u06_pending_deposit
      FROM u06_cash_account
/