CREATE TABLE dfn_ntp.u12_trading_restriction
(
    u12_id                        NUMBER (10, 0),
    u12_restriction_type_id_v31   NUMBER (5, 0) NOT NULL,
    u12_trading_account_id_u07    NUMBER (10, 0) NOT NULL,
    u12_narration                 VARCHAR2 (200 BYTE),
    u12_narration_lang            VARCHAR2 (200 BYTE),
    u12_restriction_source        NUMBER (1, 0) DEFAULT 0,
    u12_custom_type               VARCHAR2 (50 BYTE) DEFAULT 1
)
/



COMMENT ON COLUMN dfn_ntp.u12_trading_restriction.u12_restriction_source IS
    '0- Manual , 1 - Customer_ID_Expired ,| 2 - CMA_Details_Expired | 3 - Inactive | 4 - Dormant| 5 - Account Closure | 7 - Underage_to_Minor | 8 - Minor_to_Major'
/
COMMENT ON COLUMN dfn_ntp.u12_trading_restriction.u12_restriction_type_id_v31 IS
    'FK from V31'
/
COMMENT ON COLUMN dfn_ntp.u12_trading_restriction.u12_trading_account_id_u07 IS
    'FK from U07'
/