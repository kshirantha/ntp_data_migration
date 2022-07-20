-- Table DFN_NTP.V25_PAYMENT_TYPES

CREATE TABLE dfn_ntp.v25_payment_types
(
    v25_id            NUMBER (2, 0),
    v25_description   VARCHAR2 (50),
    v25_duration      NUMBER (2, 0)
)
/

-- Constraints for  DFN_NTP.V25_PAYMENT_TYPES


  ALTER TABLE dfn_ntp.v25_payment_types MODIFY (v25_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v25_payment_types MODIFY (v25_description NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.V25_PAYMENT_TYPES
