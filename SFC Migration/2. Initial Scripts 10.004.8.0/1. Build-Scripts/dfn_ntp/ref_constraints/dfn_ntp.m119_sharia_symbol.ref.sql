-- Foreign Key for  DFN_NTP.M119_SHARIA_SYMBOL


  ALTER TABLE dfn_ntp.m119_sharia_symbol ADD CONSTRAINT fk_m119_institute_id_m02 FOREIGN KEY (m119_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol ADD CONSTRAINT fk_m119_exchange_id_m01 FOREIGN KEY (m119_exchange_id_m01)
   REFERENCES dfn_ntp.m01_exchanges (m01_id) ENABLE
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol ADD CONSTRAINT fk_m119_symbol_id_m20 FOREIGN KEY (m119_symbol_id_m20)
   REFERENCES dfn_ntp.m20_symbol (m20_id) ENABLE
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol ADD CONSTRAINT fk_m119_created_by_id_u17 FOREIGN KEY (m119_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol ADD CONSTRAINT fk_m119_sharia_group_id_m120 FOREIGN KEY (m119_sharia_group_id_m120)
   REFERENCES dfn_ntp.m120_sharia_compliant_group (m120_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M119_SHARIA_SYMBOL
