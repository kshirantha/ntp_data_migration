-- Foreign Key for  DFN_NTP.M139_GL_COLUMN_DESTRIBUTION


  ALTER TABLE dfn_ntp.m139_gl_column_destribution ADD CONSTRAINT fk_m139_data_source_id_m137 FOREIGN KEY (m139_data_source_id_m137)
   REFERENCES dfn_ntp.m137_gl_event_data_sources (m137_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M139_GL_COLUMN_DESTRIBUTION
