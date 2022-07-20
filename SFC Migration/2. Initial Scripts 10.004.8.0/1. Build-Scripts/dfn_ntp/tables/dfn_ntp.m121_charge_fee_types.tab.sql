-- Table DFN_NTP.M121_CHARGE_FEE_TYPES

CREATE TABLE dfn_ntp.m121_charge_fee_types
(
    m121_id                NUMBER (5, 0),
    m121_charge_code_m97   VARCHAR2 (10),
    m121_description       VARCHAR2 (100)
)
/

-- Constraints for  DFN_NTP.M121_CHARGE_FEE_TYPES


  ALTER TABLE dfn_ntp.m121_charge_fee_types ADD CONSTRAINT pk_m121_charge_fee_types PRIMARY KEY (m121_id)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.M121_CHARGE_FEE_TYPES

alter table dfn_ntp.M121_CHARGE_FEE_TYPES
	add M121_CUSTOM_TYPE varchar2(50) default 1
/

DROP TABLE dfn_ntp.m121_charge_fee_types
/