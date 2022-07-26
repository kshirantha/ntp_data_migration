CREATE TABLE dfn_ntp.h11_holding_summary_log
(
    h11_trading_acnt_id_u07   NUMBER (10, 0),
    h11_exchange_code_m01     VARCHAR2 (10 BYTE),
    h11_symbol_id_m20         NUMBER (10, 0),
    h11_date                  DATE,
    h11_custodian_id_m26      NUMBER (10, 0),
    h11_holding_block         NUMBER (18, 0) DEFAULT 0,
    h11_sell_pending          NUMBER (18, 0),
    h11_buy_pending           NUMBER (18, 0),
    h11_weighted_avg_price    NUMBER (18, 5),
    h11_avg_price             NUMBER (18, 5),
    h11_weighted_avg_cost     NUMBER (18, 5),
    h11_avg_cost              NUMBER (18, 5),
    h11_receivable_holding    NUMBER (18, 0) DEFAULT 0,
    h11_payable_holding       NUMBER (18, 0) DEFAULT 0,
    h11_symbol_code_m20       VARCHAR2 (10 BYTE),
    h11_realized_gain_lost    NUMBER (18, 5),
    h11_currency_code_m03     VARCHAR2 (5 BYTE),
    h11_price_inst_type       NUMBER (5, 0),
    h11_pledge_qty            NUMBER (18, 0) DEFAULT 0,
    h11_last_trade_price      NUMBER (18, 5) DEFAULT 0,
    h11_vwap                  NUMBER (18, 5) DEFAULT 0,
    h11_market_price          NUMBER (18, 5) DEFAULT 0,
    h11_previous_closed       NUMBER (18, 5) DEFAULT 0,
    h11_todays_closed         NUMBER (18, 5) DEFAULT 0,
    h11_manual_block          NUMBER (18, 0) DEFAULT 0,
    h11_net_holding           NUMBER (18, 0) DEFAULT 0,
    h11_custodian_code_m26    VARCHAR2 (50 BYTE)
)
/
