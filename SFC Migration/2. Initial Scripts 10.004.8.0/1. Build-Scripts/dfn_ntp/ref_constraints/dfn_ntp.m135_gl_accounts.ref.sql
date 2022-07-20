-- Foreign Key for  DFN_NTP.M135_GL_ACCOUNTS


  ALTER TABLE dfn_ntp.m135_gl_accounts ADD CONSTRAINT fk_m135_acc_cat_id_m134 FOREIGN KEY (m135_acc_cat_id_m134)
   REFERENCES dfn_ntp.m134_gl_account_categories (m134_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M135_GL_ACCOUNTS
