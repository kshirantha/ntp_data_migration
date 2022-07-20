-- Foreign Key for  DFN_NTP.M44_INSTITUTION_ENTITLEMENTS


  ALTER TABLE dfn_ntp.m44_institution_entitlements ADD CONSTRAINT m44_institution_id_m02_id FOREIGN KEY (m44_institution_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m44_institution_entitlements ADD CONSTRAINT m44_entitlement_id_v04_id FOREIGN KEY (m44_entitlement_id_v04)
   REFERENCES dfn_ntp.v04_entitlements (v04_id) ENABLE NOVALIDATE
/
-- End of REF DDL Script for Table DFN_NTP.M44_INSTITUTION_ENTITLEMENTS
