ALTER TABLE dfn_ntp.m174_data_loader_field_map
    ADD CONSTRAINT fk_m174_template_id_m173 FOREIGN KEY
            (m174_template_id_m173)
             REFERENCES dfn_ntp.m173_data_loader_template (m173_id)
/
