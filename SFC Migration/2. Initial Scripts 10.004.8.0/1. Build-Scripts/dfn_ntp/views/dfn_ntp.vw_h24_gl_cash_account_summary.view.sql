CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_h24_gl_cash_account_summary
(
    h24_date,
    h24_cash_account_id_u06,
    h24_opening_balance,
    h24_deposits,
    h24_withdrawals,
    h24_buy,
    h24_sell,
    h24_charges,
    h24_refunds,
    h24_broker_commission,
    h24_exg_commission,
    h24_accrued_interest,
    h24_settled_balance,
    h24_blocked,
    h24_open_buy_blocked,
    h24_pending_withdraw,
    h24_manual_trade_blocked,
    h24_manual_full_blocked,
    h24_manual_transfer_blocked,
    h24_payable_blocked,
    h24_receivable_amount
)
AS
    SELECT h00.h00_date AS h24_date,
           h24.h24_cash_account_id_u06,
           h24.h24_opening_balance,
           h24.h24_deposits,
           h24.h24_withdrawals,
           h24.h24_buy,
           h24.h24_sell,
           h24.h24_charges,
           h24.h24_refunds,
           h24.h24_broker_commission,
           h24.h24_exg_commission,
           h24.h24_accrued_interest,
           h24.h24_settled_balance,
           h24.h24_blocked,
           h24.h24_open_buy_blocked,
           h24.h24_pending_withdraw,
           h24.h24_manual_trade_blocked,
           h24.h24_manual_full_blocked,
           h24.h24_manual_transfer_blocked,
           h24.h24_payable_blocked,
           h24.h24_receivable_amount
      FROM h24_gl_cash_account_summary h24
           JOIN u06_cash_account u06
               ON h24.h24_cash_account_id_u06 = u06.u06_id
           JOIN h00_dates h00
               ON h24.h24_date =
                      fn_get_latest_h02_date (u06.u06_id, h00.h00_date)
/
