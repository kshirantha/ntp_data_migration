CREATE TABLE dfn_ntp.t85_negotiated_deal
(
    t85_id                          NUMBER (18, 0) NOT NULL,
    t85_type                        NUMBER (1, 0) DEFAULT 2,
    t85_report_id                   VARCHAR2 (20 CHAR),
    t85_remote_report_id            VARCHAR2 (20 CHAR),
    t85_buyer_customer_no_u01       NUMBER (10, 0),
    t85_buyer_trading_acc_id_u07    NUMBER (10, 0),
    t85_seller_customer_no_u01      NUMBER (10, 0),
    t85_seller_trading_acc_id_u07   NUMBER (10, 0),
    t85_report_txn_type             NUMBER (2, 0) DEFAULT 0,
    t85_report_type                 NUMBER (2, 0) DEFAULT 0,
    t85_symbol                      VARCHAR2 (20 CHAR),
    t85_exchange                    VARCHAR2 (20 CHAR),
    t85_price                       NUMBER (18, 2),
    t85_quantity                    NUMBER (18, 0),
    t85_transaction_time            DATE,
    t85_settlement_date             DATE,
    t85_trader_id                   VARCHAR2 (20 CHAR),
    t85_created_date                DATE,
    t85_ord_side                    NUMBER (1, 0),
    t85_direction                   NUMBER (1, 0) DEFAULT 1,
    t85_trade_match_id              VARCHAR2 (18 CHAR),
    t85_text                        VARCHAR2 (4000 CHAR),
    t85_txn_reference               VARCHAR2 (50 CHAR),
    t85_user_id_u17                 NUMBER (10, 0),
    t85_other_broker_id_m105        NUMBER (10, 0),
    t85_confirmation_period         NUMBER (5, 0),
    t85_contra_trader_id            VARCHAR2 (20 BYTE),
    t85_contra_trading_acc_no       VARCHAR2 (50 BYTE)
)
/


CREATE UNIQUE INDEX dfn_ntp.idx_t85_report_id
    ON dfn_ntp.t85_negotiated_deal (t85_report_id ASC)
/

CREATE UNIQUE INDEX dfn_ntp.idx_t85_remote_report_id
    ON dfn_ntp.t85_negotiated_deal (t85_remote_report_id ASC)
/

CREATE INDEX dfn_ntp.idx_buy_cust_id
    ON dfn_ntp.t85_negotiated_deal (t85_buyer_customer_no_u01 ASC)
/

CREATE INDEX dfn_ntp.idx_t85_buy_trd_acc_id
    ON dfn_ntp.t85_negotiated_deal (t85_buyer_trading_acc_id_u07 ASC)
/

CREATE INDEX dfn_ntp.idx_t85_sel_cust_id
    ON dfn_ntp.t85_negotiated_deal (t85_seller_customer_no_u01 ASC)
/

CREATE INDEX dfn_ntp.idx_t85_sel_trd_acc_id
    ON dfn_ntp.t85_negotiated_deal (t85_seller_trading_acc_id_u07 ASC)
/


ALTER TABLE dfn_ntp.t85_negotiated_deal
ADD CONSTRAINT t85_pk PRIMARY KEY (t85_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t85_negotiated_deal.t85_direction IS
    '1 = Initiator, 2 = Acceptor'
/
COMMENT ON COLUMN dfn_ntp.t85_negotiated_deal.t85_id IS 'Primary Key'
/
COMMENT ON COLUMN dfn_ntp.t85_negotiated_deal.t85_report_txn_type IS
    '0 = New,1 = Cancel,2 = Replace'
/
COMMENT ON COLUMN dfn_ntp.t85_negotiated_deal.t85_report_type IS
    '0 = Submit,1 = Alleged (confirmed),3 = Decline,6 = Trade Report Cancel,8 = Defaulted (timed out),10 = Pended (trade awaiting approval)'
/
COMMENT ON COLUMN dfn_ntp.t85_negotiated_deal.t85_trader_id IS 'tag 50'
/
COMMENT ON COLUMN dfn_ntp.t85_negotiated_deal.t85_txn_reference IS
    'Exchange Side reference.'
/
COMMENT ON COLUMN dfn_ntp.t85_negotiated_deal.t85_type IS
    '1 = Two side, 2 = Crossing'
/


ALTER TABLE dfn_ntp.t85_negotiated_deal
 MODIFY (
  t85_buyer_customer_no_u01 VARCHAR2 (50),
  t85_seller_customer_no_u01 VARCHAR2 (50)

 )
/