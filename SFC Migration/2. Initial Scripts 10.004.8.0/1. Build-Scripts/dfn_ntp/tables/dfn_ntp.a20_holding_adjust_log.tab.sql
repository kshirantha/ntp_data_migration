CREATE TABLE dfn_ntp.a20_holding_adjust_log
(
    a20_date                        DATE,
    a20_trade_processing_id_t17     VARCHAR2 (22),
    a20_symbol_id_h02_m20           NUMBER (10, 0),
    a20_custodian_id_m26            NUMBER (10, 0),
    a20_h01_exchange_code_h01_m01   VARCHAR2 (10 BYTE),
    a20_history_date_h01            DATE,
    a20_trading_acnt_id_h01_u07     NUMBER (10, 0),
    a20_old_net_holding             NUMBER (25, 0),
    a20_new_net_holding             NUMBER (25, 0),
    a20_old_receivable_holding      NUMBER (25, 0),
    a20_new_receivable_holding      NUMBER (25, 0),
    a20_old_payable_holding         NUMBER (25, 0),
    a20_new_payable_holding         NUMBER (25, 0)
)
/

