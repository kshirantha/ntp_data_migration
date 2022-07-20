-- Table DFN_NTP.R06_CASH_ACCOUNT

CREATE TABLE dfn_ntp.r06_cash_account
(
    cash_account_id_u06       NUMBER (10, 0),
    create_date               DATE,
    institute_id_m02          NUMBER (3, 0),
    customer_id_u01           NUMBER (10, 0),
    currency_code_m03         CHAR (3),
    balance                   NUMBER (25, 10) DEFAULT 0,
    blocked                   NUMBER (25, 10) DEFAULT 0,
    open_buy_blocked          NUMBER (25, 10) DEFAULT 0,
    payable_blocked           NUMBER (25, 10) DEFAULT 0,
    manual_trade_blocked      NUMBER (25, 10) DEFAULT 0,
    manual_full_blocked       NUMBER (25, 10) DEFAULT 0,
    manual_transfer_blocked   NUMBER (25, 10) DEFAULT 0,
    receivable_amount         NUMBER (25, 10) DEFAULT 0,
    currency_id_m03           NUMBER (5, 0),
    margin_enabled            NUMBER (5, 0) DEFAULT 0,
    pending_deposit           NUMBER (25, 10) DEFAULT 0,
    pending_withdraw          NUMBER (25, 10) DEFAULT 0,
    primary_od_limit          NUMBER (25, 10),
    primary_start             DATE,
    primary_expiry            DATE,
    secondary_od_limit        NUMBER (25, 10),
    secondary_start           DATE,
    secondary_expiry          DATE,
    investment_account_no     VARCHAR2 (75),
    daily_withdraw_limit      NUMBER (18, 5) DEFAULT 0,
    daily_cum_withdraw_amt    NUMBER (18, 5) DEFAULT 0,
    margin_due                NUMBER (18, 5),
    margin_block              NUMBER (18, 5),
    margin_product_id_u23     NUMBER (5, 0),
    net_receivable            NUMBER (25, 10) DEFAULT 0,
    opening_balance           NUMBER (25, 10),
    deposits                  NUMBER (25, 10),
    withdrawals               NUMBER (25, 10),
    net_buy                   NUMBER (25, 10),
    net_sell                  NUMBER (25, 10),
    net_charges_refunds       NUMBER (25, 10),
    net_commission            NUMBER (25, 10)
)
/



-- End of DDL Script for Table DFN_NTP.R06_CASH_ACCOUNT
