-- Foreign Key for  DFN_NTP.V31_RESTRICTION


  ALTER TABLE dfn_ntp.v31_restriction ADD CONSTRAINT fk_v31_m127_reason_type FOREIGN KEY (v31_reason_type)
   REFERENCES dfn_ntp.m127_reason_types (m127_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.V31_RESTRICTION
