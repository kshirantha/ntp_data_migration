-- Foreign Key for  DFN_NTP.M93_BANK_ACCOUNTS


  ALTER TABLE dfn_ntp.m93_bank_accounts ADD CONSTRAINT m93_banks_fk FOREIGN KEY (m93_bank_id_m16)
   REFERENCES dfn_ntp.m16_bank (m16_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M93_BANK_ACCOUNTS
