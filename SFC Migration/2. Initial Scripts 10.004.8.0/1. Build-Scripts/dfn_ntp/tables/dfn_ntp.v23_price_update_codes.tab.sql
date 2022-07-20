-- Table DFN_NTP.V23_PRICE_UPDATE_CODES

CREATE TABLE dfn_ntp.v23_price_update_codes
(
    v23_id            NUMBER (2, 0),
    v23_description   VARCHAR2 (50)
)
/

-- Constraints for  DFN_NTP.V23_PRICE_UPDATE_CODES


  ALTER TABLE dfn_ntp.v23_price_update_codes MODIFY (v23_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v23_price_update_codes MODIFY (v23_description NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.V23_PRICE_UPDATE_CODES
