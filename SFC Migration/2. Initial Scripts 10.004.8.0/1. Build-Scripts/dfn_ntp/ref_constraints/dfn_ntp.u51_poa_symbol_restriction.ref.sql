-- Foreign Key for  DFN_NTP.U51_POA_SYMBOL_RESTRICTION


  ALTER TABLE dfn_ntp.u51_poa_symbol_restriction ADD CONSTRAINT fk_u51_m20_id FOREIGN KEY (u51_symbol_id_m20)
   REFERENCES dfn_ntp.m20_symbol (m20_id) ENABLE
/

  ALTER TABLE dfn_ntp.u51_poa_symbol_restriction ADD CONSTRAINT fk_u51_u47_id FOREIGN KEY (u51_poa_id_u47)
   REFERENCES dfn_ntp.u47_power_of_attorney (u47_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U51_POA_SYMBOL_RESTRICTION
