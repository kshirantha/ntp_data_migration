CREATE TABLE dfn_ntp.u49_poa_trading_privileges
(
    u49_id                       NUMBER (5, 0),
    u49_poa_id_u47               NUMBER (10, 0) NOT NULL,
    u49_trading_account_id_u07   NUMBER (10, 0) NOT NULL,
    u49_privilege_type_id_v31    NUMBER (5, 0) NOT NULL,
    u49_narration                VARCHAR2 (200 BYTE),
    u49_narration_lang           VARCHAR2 (200 BYTE),
    u49_issue_date               DATE,
    u49_poa_expiry_date          DATE,
    u49_is_active                NUMBER (1, 0),
    u49_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1
)
/
