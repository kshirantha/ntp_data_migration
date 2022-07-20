CREATE TABLE dfn_ntp.m98_institution_txn_codes
(
    m98_id                         NUMBER (5, 0) NOT NULL,
    m98_transaction_code_id_m97    NUMBER (5, 0) NOT NULL,
    m98_transaction_code_m97       VARCHAR2 (10 BYTE) NOT NULL,
    m98_institution_id_m02         NUMBER (5, 0) NOT NULL,
    m98_b2b_enabled                NUMBER (1, 0) DEFAULT 0,
    m98_statement                  NUMBER (1, 0) DEFAULT 0,
    m98_created_by_id_u17          NUMBER (5, 0) NOT NULL,
    m98_created_date               DATE NOT NULL,
    m98_modified_by_id_u17         NUMBER (5, 0),
    m98_modified_date              DATE,
    m98_status_id_v01              NUMBER (5, 0) NOT NULL,
    m98_status_changed_by_id_u17   NUMBER (5, 0) NOT NULL,
    m98_status_changed_date        DATE NOT NULL,
    m98_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m98_txn_code_description_m97   VARCHAR2 (100 BYTE)
)
/

COMMENT ON COLUMN dfn_ntp.m98_institution_txn_codes.m98_b2b_enabled IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m98_institution_txn_codes.m98_statement IS
    '0 - No | 1 - Yes'
/