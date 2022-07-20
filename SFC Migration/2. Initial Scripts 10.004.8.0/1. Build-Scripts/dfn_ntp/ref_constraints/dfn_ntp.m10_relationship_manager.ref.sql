-- Foreign Key for  DFN_NTP.M10_RELATIONSHIP_MANAGER


  ALTER TABLE dfn_ntp.m10_relationship_manager ADD CONSTRAINT fkm10_relati980087 FOREIGN KEY (m10_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M10_RELATIONSHIP_MANAGER
