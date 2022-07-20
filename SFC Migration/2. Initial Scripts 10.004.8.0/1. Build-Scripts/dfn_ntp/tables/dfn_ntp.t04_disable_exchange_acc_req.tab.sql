CREATE TABLE dfn_ntp.t04_disable_exchange_acc_req
(
    t04_id                       NUMBER (18, 0) NOT NULL,
    t04_trading_acc_id_u07       NUMBER (18, 0),
    t04_exchange_code_m01        VARCHAR2 (10 BYTE),
    t04_no_of_approval           NUMBER (2, 0),
    t04_is_approval_completed    NUMBER (1, 0),
    t04_current_approval_level   NUMBER (2, 0),
    t04_next_status              NUMBER (3, 0),
    t04_created_date             DATE,
    t04_last_updated_date        DATE,
    t04_status_id_v01            NUMBER (5, 0),
    t04_created_by_id_u17        NUMBER (10, 0),
    t04_last_updated_by_id_u17   NUMBER (10, 0),
    t04_reject_reason            VARCHAR2 (2000 BYTE),
    t04_approved_reason          VARCHAR2 (2000 BYTE),
    t04_reason                   VARCHAR2 (2000 BYTE),
    t04_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1,
    t04_institute_id_m02         NUMBER (3, 0) DEFAULT 1,
    t04_exchange_id_m01          NUMBER (10, 0)
)
/