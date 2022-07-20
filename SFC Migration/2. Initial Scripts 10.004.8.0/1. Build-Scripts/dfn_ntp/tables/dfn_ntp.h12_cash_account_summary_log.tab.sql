CREATE TABLE dfn_ntp.h12_cash_account_summary_log
(
    h12_cash_account_id_u06       NUMBER (10, 0) NOT NULL,
    h12_date                      DATE,
    h12_customer_id_u01           NUMBER (10, 0) NOT NULL,
    h12_currency_code_m03         CHAR (3 BYTE) NOT NULL,
    h12_balance                   NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h12_blocked                   NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h12_open_buy_blocked          NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h12_payable_blocked           NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h12_manual_trade_blocked      NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h12_manual_full_blocked       NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h12_manual_transfer_blocked   NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h12_receivable_amount         NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h12_currency_id_m03           NUMBER (5, 0),
    h12_margin_enabled            NUMBER (5, 0) DEFAULT 0,
    h12_pending_deposit           NUMBER (25, 10) DEFAULT 0,
    h12_pending_withdraw          NUMBER (25, 10) DEFAULT 0,
    h12_primary_od_limit          NUMBER (25, 10),
    h12_primary_start             DATE,
    h12_primary_expiry            DATE,
    h12_secondary_od_limit        NUMBER (25, 10),
    h12_secondary_start           DATE,
    h12_secondary_expiry          DATE,
    h12_investment_account_no     VARCHAR2 (75 BYTE),
    h12_daily_withdraw_limit      NUMBER (18, 5) DEFAULT 0,
    h12_daily_cum_withdraw_amt    NUMBER (18, 5) DEFAULT 0,
    h12_margin_due                NUMBER (18, 5),
    h12_margin_block              NUMBER (18, 5),
    h12_margin_product_id_u23     NUMBER (5, 0),
    h12_net_receivable            NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h12_opening_balance           NUMBER (25, 10),
    h12_deposits                  NUMBER (25, 10),
    h12_withdrawals               NUMBER (25, 10),
    h12_net_buy                   NUMBER (25, 10),
    h12_net_sell                  NUMBER (25, 10),
    h12_net_charges_refunds       NUMBER (25, 10),
    h12_net_commission            NUMBER (25, 10),
    h12_accrued_interest          NUMBER (18, 5) DEFAULT 0,
    PRIMARY KEY (h12_cash_account_id_u06, h12_date)
)
/



CREATE INDEX dfn_ntp.idx_h12_cash_account_id
    ON dfn_ntp.h12_cash_account_summary_log (h12_cash_account_id_u06 ASC)
    NOPARALLEL
    LOGGING
/

CREATE INDEX dfn_ntp.idx_h12_date
    ON dfn_ntp.h12_cash_account_summary_log (h12_date ASC)
    NOPARALLEL
    LOGGING
/


COMMENT ON COLUMN dfn_ntp.h12_cash_account_summary_log.h12_manual_full_blocked IS
    'Manual block for withdrawal'
/
COMMENT ON COLUMN dfn_ntp.h12_cash_account_summary_log.h12_manual_trade_blocked IS
    'Manual block for buy/sell'
/
COMMENT ON COLUMN dfn_ntp.h12_cash_account_summary_log.h12_margin_enabled IS
    '0 - No, 1 - Yes, 2 - Expired'
/
