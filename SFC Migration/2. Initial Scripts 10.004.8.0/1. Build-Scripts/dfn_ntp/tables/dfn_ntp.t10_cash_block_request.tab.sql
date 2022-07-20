CREATE TABLE dfn_ntp.t10_cash_block_request
(
    t10_id                       NUMBER (10, 0) NOT NULL,
    t10_cash_account_id_u06      NUMBER (10, 0) NOT NULL,
    t10_amount_blocked           NUMBER (18, 5) NOT NULL,
    t10_from_date                DATE,
    t10_to_date                  DATE,
    t10_reason_for_block         VARCHAR2 (1000 BYTE),
    t10_type                     NUMBER (1, 0) DEFAULT 1,
    t10_no_of_approval           NUMBER (2, 0),
    t10_is_approval_completed    NUMBER (1, 0) DEFAULT 0,
    t10_current_approval_level   NUMBER (2, 0),
    t10_next_status              NUMBER (3, 0),
    t10_status                   NUMBER (3, 0),
    t10_created_date             DATE,
    t10_created_by               NUMBER (10, 0),
    t10_last_updated_date        DATE,
    t10_last_updated_by          NUMBER (10, 0),
    t10_comment                  VARCHAR2 (2000 BYTE),
    t10_delete_status            NUMBER (3, 0),
    t10_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1,
    t10_institute_id_m02         NUMBER (3, 0) DEFAULT 1
)
/


COMMENT ON COLUMN dfn_ntp.t10_cash_block_request.t10_cash_account_id_u06 IS
    'FK U06'
/
COMMENT ON COLUMN dfn_ntp.t10_cash_block_request.t10_id IS 'PK T10'
/
COMMENT ON COLUMN dfn_ntp.t10_cash_block_request.t10_type IS
    '1 - Cash Transfer Block | 2 - Cash Block'
/