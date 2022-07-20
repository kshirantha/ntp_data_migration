CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cash_restriction_summary
(
    u11_cash_account_id_u06,
    restriction
)
AS
      SELECT u11_cash_account_id_u06,
             DECODE (MAX (deposit) - MAX (withdraw),
                     0, 'Deposit & Withdraw',
                     1, 'Deposit',
                     -1, 'Withdraw')
                 AS restriction
        FROM (SELECT u11_cash_account_id_u06, 1 AS deposit, 0 AS withdraw
                FROM u11_cash_restriction
               WHERE u11_restriction_type_id_v31 = 9
              UNION ALL
              SELECT u11_cash_account_id_u06, 0 AS deposit, 1 AS withdraw
                FROM u11_cash_restriction
               WHERE u11_restriction_type_id_v31 = 10)
    GROUP BY u11_cash_account_id_u06
/
