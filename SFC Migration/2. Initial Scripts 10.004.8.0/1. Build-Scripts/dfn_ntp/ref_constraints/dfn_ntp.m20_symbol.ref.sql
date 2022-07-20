-- Foreign Key for  DFN_NTP.M20_SYMBOL


  ALTER TABLE dfn_ntp.m20_symbol ADD CONSTRAINT fk_m20_sector_id_m63 FOREIGN KEY (m20_sectors_id_m63)
   REFERENCES dfn_ntp.m63_sectors (m63_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M20_SYMBOL
