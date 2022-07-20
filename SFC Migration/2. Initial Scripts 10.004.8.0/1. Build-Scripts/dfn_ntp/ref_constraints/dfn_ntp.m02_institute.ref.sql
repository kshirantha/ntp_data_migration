-- Foreign Key for  DFN_NTP.M02_INSTITUTE


  ALTER TABLE dfn_ntp.m02_institute ADD CONSTRAINT m02_price_block_type_m55 FOREIGN KEY (m02_price_block_type_id_m55)
   REFERENCES dfn_ntp.m55_price_block_types (m55_id) ENABLE
/

  ALTER TABLE dfn_ntp.m02_institute ADD CONSTRAINT m02_cus_pwd_complex_level_m96 FOREIGN KEY (m02_cus_pwd_complex_lvl_id_m96)
   REFERENCES dfn_ntp.m56_password_complexity_levels (m56_id) ENABLE
/

  ALTER TABLE dfn_ntp.m02_institute ADD CONSTRAINT m02_pwd_complexity_level_m96 FOREIGN KEY (m02_pwd_complexity_lvl_id_m96)
   REFERENCES dfn_ntp.m56_password_complexity_levels (m56_id) ENABLE
/

  ALTER TABLE dfn_ntp.m02_institute ADD CONSTRAINT m02_fk_m02 FOREIGN KEY (m02_display_currency_code_m03)
   REFERENCES dfn_ntp.m03_currency (m03_code) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M02_INSTITUTE
