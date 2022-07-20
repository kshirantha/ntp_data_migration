-- Table DFN_NTP.H01_HOLDING_SUMMARY

CREATE TABLE dfn_ntp.h01_holding_summary
(
    h01_trading_acnt_id_u07   NUMBER (10, 0),
    h01_exchange_code_m01     VARCHAR2 (10),
    h01_symbol_id_m20         NUMBER (10, 0),
    h01_date                  DATE,
    h01_custodian_id_m26      NUMBER (10, 0),
    h01_holding_block         NUMBER (18, 0) DEFAULT 0,
    h01_sell_pending          NUMBER (18, 0),
    h01_buy_pending           NUMBER (18, 0),
    h01_weighted_avg_price    NUMBER (18, 5),
    h01_avg_price             NUMBER (18, 5),
    h01_weighted_avg_cost     NUMBER (18, 5),
    h01_avg_cost              NUMBER (18, 5),
    h01_receivable_holding    NUMBER (18, 0) DEFAULT 0,
    h01_payable_holding       NUMBER (18, 0) DEFAULT 0,
    h01_symbol_code_m20       VARCHAR2 (10),
    h01_realized_gain_lost    NUMBER (18, 5),
    h01_currency_code_m03     VARCHAR2 (5),
    h01_price_inst_type       NUMBER (5, 0),
    h01_pledge_qty            NUMBER (18, 0) DEFAULT 0,
    h01_last_trade_price      NUMBER (18, 5),
    h01_vwap                  NUMBER (18, 5),
    h01_market_price          NUMBER (18, 5),
    h01_previous_closed       NUMBER (18, 5),
    h01_todays_closed         NUMBER (18, 5),
    h01_manual_block          NUMBER (18, 0) DEFAULT 0,
    h01_net_holding           NUMBER (18, 0) DEFAULT 0,
    h01_custodian_code_m26    VARCHAR2 (50),
    PRIMARY KEY
        (h01_trading_acnt_id_u07,
         h01_date,
         h01_exchange_code_m01,
         h01_symbol_id_m20,
         h01_custodian_id_m26)
        ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/



-- Indexes for  DFN_NTP.H01_HOLDING_SUMMARY


CREATE INDEX dfn_ntp.idx_h01_composite
    ON dfn_ntp.h01_holding_summary (h01_trading_acnt_id_u07,
                                    h01_exchange_code_m01,
                                    h01_symbol_id_m20,
                                    h01_custodian_id_m26)
/

CREATE INDEX dfn_ntp.idx_h01_date
    ON dfn_ntp.h01_holding_summary (h01_date)
/

-- Comments for  DFN_NTP.H01_HOLDING_SUMMARY

COMMENT ON COLUMN dfn_ntp.h01_holding_summary.h01_price_inst_type IS
    'Price Instrument Type'
/
-- End of DDL Script for Table DFN_NTP.H01_HOLDING_SUMMARY

ALTER TABLE dfn_ntp.h01_holding_summary
 MODIFY (
  h01_last_trade_price DEFAULT 0,
  h01_vwap DEFAULT 0,
  h01_market_price DEFAULT 0,
  h01_previous_closed DEFAULT 0,
  h01_todays_closed DEFAULT 0
 )
/

DROP INDEX dfn_ntp.idx_h01_composite
/

CREATE INDEX dfn_ntp.idx_h01_composite
    ON dfn_ntp.h01_holding_summary (h01_trading_acnt_id_u07 ASC,
                                    h01_date ASC,                                    
                                    h01_symbol_id_m20 ASC,
                                    h01_custodian_id_m26 ASC)
/

ALTER TABLE dfn_ntp.h01_holding_summary
 ADD (
  h01_short_holdings NUMBER (18, 0) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.h01_holding_summary
 ADD (
  h01_net_receivable NUMBER (18, 0)
 )
/

ALTER TABLE dfn_ntp.h01_holding_summary
 ADD (
  h01_is_history_adjusted NUMBER (1),
  h01_trade_processing_id_t17 VARCHAR2 (22)
 )
/
COMMENT ON COLUMN dfn_ntp.h01_holding_summary.h01_is_history_adjusted IS
    'Adjusted by Trade Processing'
/

ALTER TABLE dfn_ntp.h01_holding_summary 
 ADD (
  h01_primary_institute_id_m02 NUMBER (5)
 )
/

ALTER TABLE dfn_ntp.H01_HOLDING_SUMMARY 
 ADD (
  h01_subscribed_qty NUMBER (18, 0),
  h01_pending_subscribe_qty NUMBER (18, 0)
 )
/

ALTER TABLE dfn_ntp.h01_holding_summary
    MODIFY (h01_symbol_code_m20 VARCHAR2 (25 BYTE))
/

ALTER TABLE dfn_ntp.h01_holding_summary
 ADD (
  h01_is_archive_ready NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/
COMMENT ON COLUMN dfn_ntp.h01_holding_summary.h01_is_archive_ready IS
    'flag to check before archive'
/





ALTER TABLE dfn_ntp.h01_holding_summary
 MODIFY (
  h01_symbol_code_m20 VARCHAR2 (50 BYTE)

 )
/

CREATE INDEX dfn_ntp.idx_h01_symbol_id_m20
    ON dfn_ntp.h01_holding_summary (h01_symbol_id_m20)
/
