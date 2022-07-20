CREATE OR REPLACE FORCE VIEW dfn_ntp.t02_transaction_automation
(
    t02_cash_balance,
    t02_amnt_in_stl_currency,
    t02_cash_block_adjst,
    t02_cashtxn_id
)
AS
    SELECT TRIM (TO_CHAR (t02_cash_balance, '999,999,999.99'))
               AS t02_cash_balance,
           t02_amnt_in_stl_currency,
           t02_cash_block_adjst,
           t02_cashtxn_id
      FROM t02_transaction_log
     WHERE t02_amnt_in_stl_currency <> 0
/