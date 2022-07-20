-- Foreign Key for  DFN_NTP.M120_SHARIA_COMPLIANT_GROUP


  ALTER TABLE dfn_ntp.m120_sharia_compliant_group ADD CONSTRAINT fk_m120_institute_id_m02 FOREIGN KEY (m120_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.m120_sharia_compliant_group ADD CONSTRAINT fk_m120_created_by_id_u17 FOREIGN KEY (m120_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.m120_sharia_compliant_group ADD CONSTRAINT fk_m120_modified_by_id_u17 FOREIGN KEY (m120_modified_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.m120_sharia_compliant_group ADD CONSTRAINT fk_m120_sts_changed_by_id_u17 FOREIGN KEY (m120_status_changed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M120_SHARIA_COMPLIANT_GROUP
