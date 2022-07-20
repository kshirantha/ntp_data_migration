-- Foreign Key for  DFN_NTP.M78_SYMBOL_MARGINABILITY


  ALTER TABLE dfn_ntp.m78_symbol_marginability ADD CONSTRAINT m78_symbol_id_m20_fk FOREIGN KEY (m78_symbol_id_m20)
   REFERENCES dfn_ntp.m20_symbol (m20_id) ENABLE
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability ADD CONSTRAINT m78_institution_m02_fk FOREIGN KEY (m78_institution_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability ADD CONSTRAINT m78_sym_margin_group_m77_fk FOREIGN KEY (m78_sym_margin_group_m77)
   REFERENCES dfn_ntp.m77_symbol_marginability_grps (m77_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M78_SYMBOL_MARGINABILITY
