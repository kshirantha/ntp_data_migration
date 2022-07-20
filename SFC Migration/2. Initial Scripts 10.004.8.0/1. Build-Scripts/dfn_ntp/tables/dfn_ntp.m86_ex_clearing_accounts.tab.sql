CREATE TABLE dfn_ntp.m86_ex_clearing_accounts
(
    m86_id                         NUMBER (10, 0),
    m86_account_type               VARCHAR2 (100 BYTE),
    m86_account_number             VARCHAR2 (100 BYTE),
    m86_is_default                 NUMBER (1, 0) DEFAULT 0,
    m86_institute_id_m02           NUMBER (10, 0),
    m86_created_by_id_u17          NUMBER (10, 0),
    m86_created_date               DATE DEFAULT SYSDATE,
    m86_modified_by_id_u17         NUMBER (10, 0),
    m86_modified_date              DATE DEFAULT SYSDATE,
    m86_exchange_code_m01          VARCHAR2 (10 BYTE),
    m86_exchange_id_m01            NUMBER (10, 0),
    m86_custom_type                VARCHAR2 (10 BYTE),
    m86_status_id_v01              NUMBER (2, 0),
    m86_status_changed_date        DATE,
    m86_status_changed_by_id_u17   NUMBER (10, 0)
)
/

COMMENT ON COLUMN dfn_ntp.m86_ex_clearing_accounts.m86_is_default IS
    '0 - No | 1 - Yes'
/
