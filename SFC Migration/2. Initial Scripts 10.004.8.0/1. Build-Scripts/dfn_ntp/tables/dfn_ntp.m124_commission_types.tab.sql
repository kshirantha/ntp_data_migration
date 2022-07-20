-- Table DFN_NTP.M124_COMMISSION_TYPES

CREATE TABLE dfn_ntp.m124_commission_types
(
    m124_id                 NUMBER (10, 0),
    m124_value              NUMBER (2, 0),
    m124_description        VARCHAR2 (100),
    m124_type               NUMBER (1, 0) DEFAULT 0,
    m124_category           NUMBER (1, 0) DEFAULT 1,
    m124_description_lang   VARCHAR2 (100)
)
/

-- Constraints for  DFN_NTP.M124_COMMISSION_TYPES


  ALTER TABLE dfn_ntp.m124_commission_types ADD CONSTRAINT m124_pk PRIMARY KEY (m124_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m124_commission_types ADD CONSTRAINT m124_value_uk UNIQUE (m124_value)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m124_commission_types MODIFY (m124_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m124_commission_types MODIFY (m124_value NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m124_commission_types MODIFY (m124_description NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M124_COMMISSION_TYPES

COMMENT ON COLUMN dfn_ntp.m124_commission_types.m124_type IS
    '0 - Commission | 1 - VAT | 2 - Both'
/
COMMENT ON COLUMN dfn_ntp.m124_commission_types.m124_category IS
    '1 - Commission Configuration | 2 - Fees Configuration'
/
-- End of DDL Script for Table DFN_NTP.M124_COMMISSION_TYPES
