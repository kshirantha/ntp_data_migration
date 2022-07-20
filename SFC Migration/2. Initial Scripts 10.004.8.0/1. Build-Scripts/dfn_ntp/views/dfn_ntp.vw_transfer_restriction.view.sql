CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_transfer_restriction
(
    u11_cash_account_id_u06,
    restriction
)
AS
      SELECT u11_cash_account_id_u06, 'Transfer' AS restriction
        FROM u11_cash_restriction
       WHERE u11_restriction_type_id_v31 = 11
    GROUP BY u11_cash_account_id_u06
/
