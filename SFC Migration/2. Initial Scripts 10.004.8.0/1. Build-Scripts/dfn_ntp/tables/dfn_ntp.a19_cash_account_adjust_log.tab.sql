CREATE TABLE dfn_ntp.a19_cash_account_adjust_log
(
    a19_date                      DATE,
    a19_trade_processing_id_t17   VARCHAR2 (22),
    a19_history_date_h02          DATE,
    a19_cash_account_id_h02_u06   NUMBER (25, 10),
    a19_old_cash_balance          NUMBER (25, 10),
    a19_new_cash_balance          NUMBER (25, 10),
    a19_old_opening_balance       NUMBER (25, 10),
    a19_new_opening_balance       NUMBER (25, 10),
    a19_old_payable_blocked       NUMBER (25, 10),
    a19_new_payable_blocked       NUMBER (25, 10),
    a19_old_receivable_amount     NUMBER (25, 10),
    a19_new_receivable_amount     NUMBER (25, 10),
    a19_old_net_sell              NUMBER (25, 10),
    a19_new_net_sell              NUMBER (25, 10),
    a19_old_net_buy               NUMBER (25, 10),
    a19_new_net_buy               NUMBER (25, 10),
    a19_old_net_commission        NUMBER (25, 10),
    a19_new_net_commission        NUMBER (25, 10)
)

/
