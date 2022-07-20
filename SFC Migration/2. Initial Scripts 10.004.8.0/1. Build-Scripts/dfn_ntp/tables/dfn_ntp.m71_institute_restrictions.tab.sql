-- Table DFN_NTP.M71_INSTITUTE_RESTRICTIONS

CREATE TABLE dfn_ntp.m71_institute_restrictions
(
    m71_restriction_id       NUMBER (10, 0),
    m71_institution_id_m02   NUMBER (10, 0),
    m71_type                 NUMBER (1, 0),
    m71_stock_trading        NUMBER (1, 0) DEFAULT 0,
    m71_stock_transaction    NUMBER (1, 0) DEFAULT 0,
    m71_stock_transfer       NUMBER (1, 0) DEFAULT 0,
    m71_pledge               NUMBER (1, 0) DEFAULT 0,
    m71_cash_transactions    NUMBER (1, 0) DEFAULT 0,
    m71_cash_transfer        NUMBER (1, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.M71_INSTITUTE_RESTRICTIONS


  ALTER TABLE dfn_ntp.m71_institute_restrictions ADD CONSTRAINT m71_pk PRIMARY KEY (m71_restriction_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m71_institute_restrictions MODIFY (m71_restriction_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m71_institute_restrictions MODIFY (m71_institution_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m71_institute_restrictions MODIFY (m71_type NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M71_INSTITUTE_RESTRICTIONS

COMMENT ON COLUMN dfn_ntp.m71_institute_restrictions.m71_restriction_id IS
    'pk'
/
COMMENT ON COLUMN dfn_ntp.m71_institute_restrictions.m71_institution_id_m02 IS
    'fk from M02'
/
COMMENT ON COLUMN dfn_ntp.m71_institute_restrictions.m71_type IS
    '1 - Customer_ID_Expired ,| 2 - CMA_Details_Expired | 3 - Inactive | 4 - Dormant | 5 - Account Closure | 7 - Underage_to_Minor | 8 - Minor_to_Major'
/
COMMENT ON COLUMN dfn_ntp.m71_institute_restrictions.m71_stock_trading IS
    '0 - None,1 - Buy,2 - Sell,3 - Both'
/
COMMENT ON COLUMN dfn_ntp.m71_institute_restrictions.m71_stock_transaction IS
    '0 - None,1 - Withdrawal,2 - Deposit,3 - Deposit and Withdrawal'
/
COMMENT ON COLUMN dfn_ntp.m71_institute_restrictions.m71_stock_transfer IS
    '0 - No,1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m71_institute_restrictions.m71_pledge IS
    '0 - None,1 - Pledge In,2 - Pledge Out,3 - Both'
/
COMMENT ON COLUMN dfn_ntp.m71_institute_restrictions.m71_cash_transactions IS
    '0 - None,1 - Withdrawal,2 - Deposit,3 - Deposit and Withdrawal'
/
COMMENT ON COLUMN dfn_ntp.m71_institute_restrictions.m71_cash_transfer IS
    '0 - None, 1 - Offline, 2 - Online, 3 - Both'
/
-- End of DDL Script for Table DFN_NTP.M71_INSTITUTE_RESTRICTIONS

alter table dfn_ntp.M71_INSTITUTE_RESTRICTIONS
	add M71_CUSTOM_TYPE varchar2(50) default 1
/
