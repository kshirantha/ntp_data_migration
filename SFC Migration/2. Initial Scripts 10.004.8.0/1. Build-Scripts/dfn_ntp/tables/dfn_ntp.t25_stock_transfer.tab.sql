CREATE TABLE dfn_ntp.t25_stock_transfer
(
    t25_id                 NUMBER (10, 0) NOT NULL,
    t25_reference          VARCHAR2 (40 BYTE) NOT NULL,
    t25_symbol             VARCHAR2 (20 BYTE) NOT NULL,
    t25_account            VARCHAR2 (10 BYTE) NOT NULL,
    t25_exchange           VARCHAR2 (10 BYTE) NOT NULL,
    t25_trans_code         VARCHAR2 (10 BYTE),
    t25_member_code        VARCHAR2 (30 BYTE),
    t25_nin                VARCHAR2 (100 BYTE),
    t25_price              NUMBER (18, 5),
    t25_owned_quantity     NUMBER (18, 0),
    t25_avl_quantity       NUMBER (18, 0),
    t25_pledged_quantity   NUMBER (18, 0),
    t25_value              NUMBER (18, 5),
    t25_added_by           VARCHAR2 (20 BYTE),
    t25_posted_by          VARCHAR2 (20 BYTE),
    t25_approved_by        VARCHAR2 (20 BYTE),
    t25_effective_date     DATE,
    t25_transaction_date   DATE,
    t25_current_date       DATE,
    t25_last_updated       DATE,
    t25_status             NUMBER (1, 0),
    t25_source_ref         VARCHAR2 (40 BYTE),
    t25_trans_sub_code     VARCHAR2 (10 BYTE),
    t25_account_ref        VARCHAR2 (20 BYTE) DEFAULT NULL,
    t25_order_id           VARCHAR2 (40 BYTE) DEFAULT NULL,
    t25_trade_match_id     VARCHAR2 (30 BYTE) DEFAULT NULL,
    t25_custom_type        VARCHAR2 (50 BYTE) DEFAULT 1,
    t25_institute_id_m02   NUMBER (3, 0) DEFAULT 1,
    t25_symbol_id_m20      NUMBER (10, 0)
)
/


COMMENT ON COLUMN dfn_ntp.t25_stock_transfer.t25_reference IS
    'PK Transaction reference'
/
COMMENT ON COLUMN dfn_ntp.t25_stock_transfer.t25_status IS
    '0-NotProcessed, 1-Processed, 2-Canceled'
/
COMMENT ON COLUMN dfn_ntp.t25_stock_transfer.t25_trans_code IS
    'Transaction Code (100 = Stock Transfer , 350 = Pledge)'
/

ALTER TABLE dfn_ntp.T25_STOCK_TRANSFER 
 ADD (
  T25_REJECT_REASON VARCHAR2 (4000 BYTE)
 )
/

ALTER TABLE dfn_ntp.T25_STOCK_TRANSFER 
 MODIFY (
  T25_STATUS NUMBER (5, 0)

 )
/

ALTER TABLE dfn_ntp.T25_STOCK_TRANSFER 
 ADD (
  T25_CUSTODIAN_ID_M26 NUMBER (10)
 )
/

CREATE INDEX dfn_ntp.idx_t25_id
    ON dfn_ntp.t25_stock_transfer (t25_id ASC)
/
