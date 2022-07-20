-- Table DFN_NTP.R24_HOLDING_ACCOUNT

CREATE TABLE dfn_ntp.r24_holding_account
(
    trading_acnt_id_u07   NUMBER (18, 0),
    exchange_code_m01     VARCHAR2 (10),
    symbol_id_m20         NUMBER (10, 0),
    create_date           DATE,
    custodian_id_m26      NUMBER (10, 0),
    holding_block         NUMBER (18, 0),
    sell_pending          NUMBER (18, 0),
    buy_pending           NUMBER (18, 0),
    weighted_avg_price    NUMBER (18, 5),
    avg_price             NUMBER (18, 5),
    weighted_avg_cost     NUMBER (18, 5),
    avg_cost              NUMBER (18, 5),
    receivable_holding    NUMBER (18, 0),
    payable_holding       NUMBER (18, 0),
    symbol_code_m20       VARCHAR2 (10),
    realized_gain_lost    NUMBER (18, 5),
    currency_code_m03     VARCHAR2 (5),
    price_inst_type       NUMBER (5, 0),
    pledge_qty            NUMBER (18, 0),
    manual_block          NUMBER (18, 5),
    net_holding           NUMBER (18, 0),
    last_trade_price      NUMBER (18, 0),
    vwap                  VARCHAR2 (10),
    market_price          VARCHAR2 (18),
    previous_closed       VARCHAR2 (18),
    todays_closed         VARCHAR2 (18)
)
/

-- Constraints for  DFN_NTP.R24_HOLDING_ACCOUNT


  ALTER TABLE dfn_ntp.r24_holding_account MODIFY (trading_acnt_id_u07 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r24_holding_account MODIFY (exchange_code_m01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r24_holding_account MODIFY (symbol_id_m20 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r24_holding_account MODIFY (custodian_id_m26 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.R24_HOLDING_ACCOUNT
