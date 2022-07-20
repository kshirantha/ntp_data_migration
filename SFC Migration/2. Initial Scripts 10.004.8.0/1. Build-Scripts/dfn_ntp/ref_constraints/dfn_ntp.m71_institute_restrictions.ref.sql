-- Foreign Key for  DFN_NTP.M71_INSTITUTE_RESTRICTIONS


  ALTER TABLE dfn_ntp.m71_institute_restrictions ADD CONSTRAINT m71_institution_m02 FOREIGN KEY (m71_institution_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M71_INSTITUTE_RESTRICTIONS
