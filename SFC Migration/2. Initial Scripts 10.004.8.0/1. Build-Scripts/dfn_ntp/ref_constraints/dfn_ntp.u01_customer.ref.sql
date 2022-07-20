-- Foreign Key for  DFN_NTP.U01_CUSTOMER


  ALTER TABLE dfn_ntp.u01_customer ADD CONSTRAINT fku01_custom16081 FOREIGN KEY (u01_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.u01_customer ADD CONSTRAINT fku01_custom650803 FOREIGN KEY (u01_birth_country_id_m05)
   REFERENCES dfn_ntp.m05_country (m05_id) ENABLE
/

  ALTER TABLE dfn_ntp.u01_customer ADD CONSTRAINT fku01_custom883515 FOREIGN KEY (u01_birth_city_id_m06)
   REFERENCES dfn_ntp.m06_city (m06_id) ENABLE
/

  ALTER TABLE dfn_ntp.u01_customer ADD CONSTRAINT fku01_custom896320 FOREIGN KEY (u01_signup_location_id_m07)
   REFERENCES dfn_ntp.m07_location (m07_id) ENABLE
/

  ALTER TABLE dfn_ntp.u01_customer ADD CONSTRAINT fku01_custom313603 FOREIGN KEY (u01_service_location_id_m07)
   REFERENCES dfn_ntp.m07_location (m07_id) ENABLE
/

  ALTER TABLE dfn_ntp.u01_customer ADD CONSTRAINT fku01_custom151634 FOREIGN KEY (u01_relationship_mngr_id_m10)
   REFERENCES dfn_ntp.m10_relationship_manager (m10_id) ENABLE
/

  ALTER TABLE dfn_ntp.u01_customer ADD CONSTRAINT fk_m05 FOREIGN KEY (u01_nationality_id_m05)
   REFERENCES dfn_ntp.m05_country (m05_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U01_CUSTOMER
