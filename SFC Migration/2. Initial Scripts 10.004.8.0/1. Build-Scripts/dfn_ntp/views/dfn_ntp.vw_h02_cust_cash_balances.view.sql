CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_h02_cust_cash_balances
(
    h02_cash_account_id_u06,
    h02_date,
    u06_display_name_u01,
    u06_display_name,
    u06_institute_id_m02,
    h02_currency_code_m03,
    h02_opening_balance,
    h02_deposits,
    h02_withdrawals,
    h02_net_buy,
    h02_net_sell,
    h02_net_commission,
    h02_net_charges_refunds,
    h02_closing_balance
)
AS
      SELECT h02.h02_cash_account_id_u06,
             h02.h02_date,
             u06.u06_display_name_u01,
             u06.u06_display_name,
             u06.u06_institute_id_m02,
             h02.h02_currency_code_m03,
             h02.h02_opening_balance,
             h02.h02_deposits,
             h02.h02_withdrawals,
             h02.h02_net_buy,
             h02.h02_net_sell,
             h02.h02_net_commission,
             h02.h02_net_charges_refunds,
             (  h02.h02_balance
              + h02.h02_payable_blocked
              - h02.h02_receivable_amount)
                 AS h02_closing_balance
        FROM vw_h02_cash_account_summary h02
             JOIN u01_customer u01
                 ON h02.h02_customer_id_u01 = u01.u01_id
             JOIN u06_cash_account u06
                 ON h02.h02_cash_account_id_u06 = u06.u06_id
    ORDER BY u06_display_name_u01, u06_display_name;
/
