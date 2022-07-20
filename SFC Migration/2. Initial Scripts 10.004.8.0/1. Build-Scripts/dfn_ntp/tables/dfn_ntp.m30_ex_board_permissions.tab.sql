CREATE TABLE dfn_ntp.m30_ex_board_permissions
(
    m30_id                       NUMBER (10, 0) NOT NULL,
    m30_code_m54                 VARCHAR2 (10 BYTE),
    m30_exg_brd_status_id_v19    NUMBER (2, 0),
    m30_exchange_code_m01        VARCHAR2 (10 BYTE),
    m30_exchange_id_m01          NUMBER (10, 0),
    m30_cancel_order_allowed     NUMBER (1, 0),
    m30_amend_order_allowed      NUMBER (1, 0),
    m30_create_order_allowed     NUMBER (1, 0),
    m30_exchange_status_id_m59   NUMBER (10, 0),
    m30_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1
)
/
