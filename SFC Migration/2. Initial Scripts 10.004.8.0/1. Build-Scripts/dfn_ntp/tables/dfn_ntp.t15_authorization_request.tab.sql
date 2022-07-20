CREATE TABLE dfn_ntp.t15_authorization_request
(
    t15_id                       NUMBER (18, 0) NOT NULL,
    t15_cash_account_id_u06      NUMBER (18, 0),
    t15_exchange_id_m01          NUMBER (18, 0),
    t15_trading_account_id_u07   NUMBER (18, 0),
    t15_member_code              VARCHAR2 (30 BYTE),
    t15_customer_id_u01          NUMBER (20, 0) NOT NULL,
    t15_closure_reason           VARCHAR2 (2000 BYTE),
    t15_sent_to_exchange         NUMBER (1, 0) DEFAULT 0 NOT NULL,
    t15_reject_reason            VARCHAR2 (2000 BYTE),
    t15_approved_reason          VARCHAR2 (2000 BYTE),
    t15_no_of_approval           NUMBER (2, 0),
    t15_is_approval_completed    NUMBER (1, 0),
    t15_current_approval_level   NUMBER (2, 0),
    t15_next_status              NUMBER (3, 0),
    t15_created_date             DATE,
    t15_last_updated_date        DATE,
    t15_status_id_v01            NUMBER (5, 0),
    t15_comment                  VARCHAR2 (2000 BYTE),
    t15_created_by_id_u17        NUMBER (10, 0),
    t15_last_updated_by_id_u17   NUMBER (10, 0),
    t15_acc_org_status_id_v01    NUMBER (20, 0),
    t15_exchange_account_no      VARCHAR2 (50 BYTE),
    t15_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1,
    t15_test_custom              VARCHAR2 (50 BYTE),
    t15_test_country             VARCHAR2 (50 BYTE)
)
/


ALTER TABLE dfn_ntp.t15_authorization_request
ADD CONSTRAINT t15_pk PRIMARY KEY (t15_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t15_authorization_request.t15_acc_org_status_id_v01 IS
    'original status of the account'
/
COMMENT ON COLUMN dfn_ntp.t15_authorization_request.t15_approved_reason IS
    'l2 approved reason'
/
COMMENT ON COLUMN dfn_ntp.t15_authorization_request.t15_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.t15_authorization_request.t15_member_code IS
    'code given to broker by exchange'
/