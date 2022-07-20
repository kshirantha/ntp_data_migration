CREATE TABLE dfn_ntp.t61_bulk_share_transactions
(
    t61_id                         VARCHAR2 (30 BYTE) NOT NULL,
    t61_transaction_type           NUMBER (18, 0) NOT NULL,
    t61_institute_id_m02           NUMBER (5, 0),
    t61_movement_type              VARCHAR2 (2 BYTE),
    t61_seller_trading_ac_id_u07   NUMBER (18, 5) NOT NULL,
    t61_buyer_trading_ac_id_u07    NUMBER (18, 5) NOT NULL,
    t61_seller_member_code         VARCHAR2 (25 BYTE),
    t61_seller_exchange_ac         VARCHAR2 (30 BYTE),
    t61_buyer_member_code          VARCHAR2 (25 BYTE),
    t61_buyer_exchange_ac          VARCHAR2 (30 BYTE),
    t61_created_by_id_u17          NUMBER (5, 0) NOT NULL,
    t61_created_date               DATE DEFAULT SYSDATE NOT NULL,
    t61_narration                  VARCHAR2 (50 BYTE),
    t61_status_id_v01              NUMBER (5, 0) DEFAULT 0 NOT NULL,
    t61_status_changed_date        DATE DEFAULT NULL,
    t61_status_changed_by_id_u17   NUMBER (5, 0),
    t61_custom_type                VARCHAR2 (50 BYTE),
    t61_allow_cash_overdraw        NUMBER (1, 0)
)
/



COMMENT ON COLUMN dfn_ntp.t61_bulk_share_transactions.t61_allow_cash_overdraw IS
    '1 - true, 0 - false'
/

ALTER TABLE  dfn_ntp.t61_bulk_share_transactions
 ADD (
  t61_send_to_exchange NUMBER (1) DEFAULT 0
 )
/