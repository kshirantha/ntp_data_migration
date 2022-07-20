ALTER TABLE dfn_ntp.m137_gl_event_data_sources ADD CONSTRAINT fk_m137_event_cat_id_m136 FOREIGN KEY (m137_event_cat_id_m136)
   REFERENCES dfn_ntp.m136_gl_event_categories (m136_id) ENABLE
/
