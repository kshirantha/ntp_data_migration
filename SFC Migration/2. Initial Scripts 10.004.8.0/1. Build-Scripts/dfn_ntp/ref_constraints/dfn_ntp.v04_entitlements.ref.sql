-- Foreign Key for  DFN_NTP.V04_ENTITLEMENTS


  ALTER TABLE dfn_ntp.v04_entitlements ADD CONSTRAINT v04_depends_on_v04 FOREIGN KEY (v04_id)
   REFERENCES dfn_ntp.v04_entitlements (v04_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.v04_entitlements ADD CONSTRAINT v04_sensitive_level_v02 FOREIGN KEY (v04_sensitive_level_id_v02)
   REFERENCES dfn_ntp.v02_ent_sensitive_levels (v02_id) ENABLE NOVALIDATE
/
-- End of REF DDL Script for Table DFN_NTP.V04_ENTITLEMENTS
