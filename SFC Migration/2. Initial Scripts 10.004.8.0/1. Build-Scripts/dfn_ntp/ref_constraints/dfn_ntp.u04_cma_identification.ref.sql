-- Foreign Key for  DFN_NTP.U04_CMA_IDENTIFICATION


  ALTER TABLE dfn_ntp.u04_cma_identification ADD CONSTRAINT fku04_cma_id982294 FOREIGN KEY (u04_identity_type_id_m15)
   REFERENCES dfn_ntp.m15_identity_type (m15_id) ENABLE
/

  ALTER TABLE dfn_ntp.u04_cma_identification ADD CONSTRAINT fku04_cma_id145782 FOREIGN KEY (u04_issue_location_id_m14)
   REFERENCES dfn_ntp.m14_issue_location (m14_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U04_CMA_IDENTIFICATION
