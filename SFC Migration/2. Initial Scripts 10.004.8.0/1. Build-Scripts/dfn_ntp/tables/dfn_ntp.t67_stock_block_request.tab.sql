CREATE TABLE dfn_ntp.t67_stock_block_request
(
    t67_id                       NUMBER (10, 0) NOT NULL,
    t67_trading_account_id_u07   NUMBER (10, 0) NOT NULL,
    t67_qty_blocked              NUMBER (18, 5) NOT NULL,
    t67_from_date                DATE,
    t67_to_date                  DATE,
    t67_reason_for_block         VARCHAR2 (1000 BYTE),
    t67_status_id_v01            NUMBER (5, 0),
    t67_created_date             DATE,
    t67_created_by_id_u17        NUMBER (10, 0),
    t67_last_updated_date        DATE,
    t67_last_updated_by_id_u17   NUMBER (10, 0),
    t67_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1,
    t67_institute_id_m02         NUMBER (3, 0) DEFAULT 1,
    t67_symbol_id_m20            NUMBER (3, 0),
    t67_symbol_code_m20          VARCHAR2 (25 BYTE),
    t67_exchange_code_m01        VARCHAR2 (10 BYTE),
    t67_custodian_id_m26         NUMBER (5, 0),
    t67_no_of_approval           NUMBER (2, 0),
    t67_is_approval_completed    NUMBER (1, 0) DEFAULT 0,
    t67_current_approval_level   NUMBER (2, 0),
    t67_next_status_id_v01       NUMBER (5, 0),
    t67_delete_status_id_v01     NUMBER (5, 0),
    t67_comment                  VARCHAR2 (1000 BYTE)
)
/

ALTER TABLE dfn_ntp.t67_stock_block_request
 MODIFY (
  t67_symbol_id_m20 NUMBER (5, 0)
 )
/

ALTER TABLE dfn_ntp.t67_stock_block_request MODIFY (t67_symbol_id_m20 NUMBER (10))
/
