-- Foreign Key for  DFN_NTP.U41_NOTIFICATION_CONFIGURATION


  ALTER TABLE dfn_ntp.u41_notification_configuration ADD CONSTRAINT fk_u41_institution_id_m02_id FOREIGN KEY (u41_institution_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U41_NOTIFICATION_CONFIGURATION
