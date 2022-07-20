-- Table DFN_NTP.V24_INDUSTRY_CODES

CREATE TABLE dfn_ntp.v24_industry_codes
(
    v24_id            NUMBER (2, 0),
    v24_description   VARCHAR2 (50)
)
/

-- Constraints for  DFN_NTP.V24_INDUSTRY_CODES


  ALTER TABLE dfn_ntp.v24_industry_codes MODIFY (v24_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v24_industry_codes MODIFY (v24_description NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.V24_INDUSTRY_CODES
