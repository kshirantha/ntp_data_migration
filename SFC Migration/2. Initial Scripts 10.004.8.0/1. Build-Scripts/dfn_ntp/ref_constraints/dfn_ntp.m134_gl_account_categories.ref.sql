ALTER TABLE dfn_ntp.m134_gl_account_categories ADD CONSTRAINT fk_m134_account_type_id_m133 FOREIGN KEY (m134_account_type_id_m133)
   REFERENCES dfn_ntp.m133_gl_account_types (m133_id) ENABLE
/
