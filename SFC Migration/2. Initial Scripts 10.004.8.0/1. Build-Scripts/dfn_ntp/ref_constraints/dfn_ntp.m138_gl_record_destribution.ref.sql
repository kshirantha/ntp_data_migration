-- Foreign Key for  DFN_NTP.M138_GL_RECORD_DESTRIBUTION


  ALTER TABLE dfn_ntp.m138_gl_record_destribution ADD CONSTRAINT fk_m138_acc_cat_id_m134 FOREIGN KEY (m138_acc_cat_id_m134)
   REFERENCES dfn_ntp.m134_gl_account_categories (m134_id) ENABLE
/

  ALTER TABLE dfn_ntp.m138_gl_record_destribution ADD CONSTRAINT fk_m138_data_source_id_m137 FOREIGN KEY (m138_data_source_id_m137)
   REFERENCES dfn_ntp.m137_gl_event_data_sources (m137_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M138_GL_RECORD_DESTRIBUTION
