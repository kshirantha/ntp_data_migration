CREATE TABLE dfn_ntp.h24_gl_cash_account_summary
(
    h24_date                      DATE,
    h24_cash_account_id_u06       NUMBER (10, 0) NOT NULL,
    h24_opening_balance           NUMBER (25, 10),
    h24_deposits                  NUMBER (25, 10),
    h24_withdrawals               NUMBER (25, 10),
    h24_buy                       NUMBER (25, 10),
    h24_sell                      NUMBER (25, 10),
    h24_charges                   NUMBER (25, 10),
    h24_refunds                   NUMBER (25, 10),
    h24_broker_commission         NUMBER (25, 10),
    h24_exg_commission            NUMBER (25, 10),
    h24_accrued_interest          NUMBER (18, 5),
    h24_settled_balance           NUMBER (25, 10),
    h24_blocked                   NUMBER (25, 10),
    h24_open_buy_blocked          NUMBER (25, 10),
    h24_pending_withdraw          NUMBER (25, 10),
    h24_manual_trade_blocked      NUMBER (25, 10),
    h24_manual_full_blocked       NUMBER (25, 10),
    h24_manual_transfer_blocked   NUMBER (25, 10),
    h24_payable_blocked           NUMBER (25, 10),
    h24_receivable_amount         NUMBER (25, 10)
)
/

CREATE INDEX dfn_ntp.idx_h24_date
    ON dfn_ntp.h24_gl_cash_account_summary (h24_date)
/

CREATE INDEX dfn_ntp.idx_h24_cash_account_id
    ON dfn_ntp.h24_gl_cash_account_summary (h24_cash_account_id_u06)
/

ALTER TABLE dfn_ntp.h24_gl_cash_account_summary
ADD PRIMARY KEY (h24_date, h24_cash_account_id_u06)
USING INDEX
/
