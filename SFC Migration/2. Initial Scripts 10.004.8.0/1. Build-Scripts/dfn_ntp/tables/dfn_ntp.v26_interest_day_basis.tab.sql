-- Table DFN_NTP.V26_INTEREST_DAY_BASIS

CREATE TABLE dfn_ntp.v26_interest_day_basis
(
    v26_id            NUMBER (2, 0),
    v26_description   VARCHAR2 (50),
    v26_upper_value   NUMBER (10, 0),
    v26_lower_value   NUMBER (10, 0)
)
/

-- Constraints for  DFN_NTP.V26_INTEREST_DAY_BASIS


  ALTER TABLE dfn_ntp.v26_interest_day_basis MODIFY (v26_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v26_interest_day_basis MODIFY (v26_description NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.V26_INTEREST_DAY_BASIS

ALTER TABLE dfn_ntp.v26_interest_day_basis ADD CONSTRAINT pk_v26_id
  PRIMARY KEY (
  v26_id
)
/
