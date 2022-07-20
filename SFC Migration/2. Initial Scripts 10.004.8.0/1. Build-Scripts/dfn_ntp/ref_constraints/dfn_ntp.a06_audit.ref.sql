-- Foreign Key for  DFN_NTP.A06_AUDIT


  ALTER TABLE dfn_ntp.a06_audit ADD CONSTRAINT a06_audit_fk1 FOREIGN KEY (a06_activity_id_m82)
   REFERENCES dfn_ntp.m82_audit_activity (m82_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.A06_AUDIT
