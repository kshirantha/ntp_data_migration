-- Table DFN_NTP.V11_SYMBOL_SETTLE_CATEGORY

CREATE TABLE dfn_ntp.v11_symbol_settle_category
(
    v11_id                           NUMBER (18, 0),
    v11_description                  VARCHAR2 (50),
    v11_default_buy_tplus            NUMBER (2, 0) DEFAULT 0,
    v11_default_sell_tplus           NUMBER (2, 0) DEFAULT 0,
    v11_default_holding_buy_tplus    NUMBER (2, 0) DEFAULT 0,
    v11_default_holding_sell_tplus   NUMBER (2, 0) DEFAULT 0
)
/



-- End of DDL Script for Table DFN_NTP.V11_SYMBOL_SETTLE_CATEGORY
