-- Foreign Key for  DFN_NTP.T27_GL_BATCHES


  ALTER TABLE dfn_ntp.t27_gl_batches ADD CONSTRAINT fk_t27_institute_id_m02 FOREIGN KEY (t27_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.t27_gl_batches ADD CONSTRAINT fk_t27_event_cat_id_m136 FOREIGN KEY (t27_event_cat_id_m136)
   REFERENCES dfn_ntp.m136_gl_event_categories (m136_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.T27_GL_BATCHES
