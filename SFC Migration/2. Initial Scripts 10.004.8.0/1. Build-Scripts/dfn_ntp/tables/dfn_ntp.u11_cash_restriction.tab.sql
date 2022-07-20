CREATE TABLE dfn_ntp.u11_cash_restriction
(
    u11_id                        NUMBER (10, 0),
    u11_restriction_type_id_v31   NUMBER (5, 0) NOT NULL,
    u11_cash_account_id_u06       NUMBER (10, 0) NOT NULL,
    u11_narration                 VARCHAR2 (200 BYTE),
    u11_narration_lang            VARCHAR2 (200 BYTE),
    u11_restriction_source        NUMBER (1, 0) DEFAULT 0,
    u11_custom_type               VARCHAR2 (50 BYTE) DEFAULT 1
)
/



COMMENT ON COLUMN dfn_ntp.u11_cash_restriction.u11_cash_account_id_u06 IS
    'FK from U06'
/
COMMENT ON COLUMN dfn_ntp.u11_cash_restriction.u11_restriction_source IS
    '0- Manual , 1 - Customer_ID_Expired ,| 2 - CMA_Details_Expired | 3 - Inactive | 4 - Dormant | 5 - Account Closure | 7 - Underage_to_Minor | 8 - Minor_to_Major'
/
COMMENT ON COLUMN dfn_ntp.u11_cash_restriction.u11_restriction_type_id_v31 IS
    'FK from V31'
/