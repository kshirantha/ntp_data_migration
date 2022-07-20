-- Foreign Key for  DFN_NTP.M17_BANK_BRANCHES


  ALTER TABLE dfn_ntp.m17_bank_branches ADD CONSTRAINT m17_bank_id_fk FOREIGN KEY (m17_bank_id)
   REFERENCES dfn_ntp.m16_bank (m16_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M17_BANK_BRANCHES
