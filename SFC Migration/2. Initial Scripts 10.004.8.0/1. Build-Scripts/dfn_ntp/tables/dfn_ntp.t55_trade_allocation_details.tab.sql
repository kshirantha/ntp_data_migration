-- Table DFN_NTP.T55_TRADE_ALLOCATION_DETAILS

CREATE TABLE dfn_ntp.t55_trade_allocation_details
    (t55_id                         NUMBER(18,0) ,
    t55_u07_id                     NUMBER(18,0) ,
    t55_pre_allocated_qty          NUMBER(18,0),
    t55_blocked_amount             NUMBER(18,5),
    t55_t01_clordid                NUMBER(18,0),
    t55_post_allocated_qty         NUMBER(18,0),
    t55_post_allocated_price       NUMBER(18,5),
    t55_order_no                   NUMBER(18,0),
    t55_u07_accountno              VARCHAR2(15 BYTE),
    t55_customer_id                NUMBER(15,0),
    t55_pre_trade_commission       NUMBER(18,5),
    t55_side                       NUMBER(1,0) DEFAULT 1 NOT NULL,
    t55_blocked_qty                NUMBER(18,0) DEFAULT 0,
    t55_status                     NUMBER(5,0),
    t55_allocation_type            NUMBER(5,0))
/

-- Constraints for T55_TRADE_ALLOCATION_DETAILS

ALTER TABLE dfn_ntp.t55_trade_allocation_details
ADD CONSTRAINT t55_trade_allocation_pk PRIMARY KEY (t55_id, t55_u07_id)
USING INDEX
/

-- Comments for T55_TRADE_ALLOCATION_DETAILS

COMMENT ON COLUMN dfn_ntp.t55_trade_allocation_details.t55_blocked_qty IS 'sell blocked qty'
/
COMMENT ON COLUMN dfn_ntp.t55_trade_allocation_details.t55_id IS 'pk from t19'
/
COMMENT ON COLUMN dfn_ntp.t55_trade_allocation_details.t55_order_no IS 'order no of offline order'
/
COMMENT ON COLUMN dfn_ntp.t55_trade_allocation_details.t55_pre_trade_commission IS 'pre trade commission'
/
COMMENT ON COLUMN dfn_ntp.t55_trade_allocation_details.t55_t01_clordid IS 'pk from t01'
/

-- End of DDL Script for Table DFN_NTP.T55_TRADE_ALLOCATION_DETAILS
