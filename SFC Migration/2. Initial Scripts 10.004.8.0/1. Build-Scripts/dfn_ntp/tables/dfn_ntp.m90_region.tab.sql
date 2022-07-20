-- Table DFN_NTP.M90_REGION

CREATE TABLE dfn_ntp.m90_region
(
    m90_id          NUMBER (5, 0),
    m90_name        VARCHAR2 (50),
    m90_name_lang   VARCHAR2 (50)
)
/

-- Constraints for  DFN_NTP.M90_REGION


  ALTER TABLE dfn_ntp.m90_region ADD CONSTRAINT pk_m90 PRIMARY KEY (m90_id)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.M90_REGION
