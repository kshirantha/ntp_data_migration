-- Foreign Key for  DFN_NTP.M96_HOLIDAYS


  ALTER TABLE dfn_ntp.m96_holidays ADD CONSTRAINT m96_exchange_id_fk_m01 FOREIGN KEY (m96_exchange_id_m01)
   REFERENCES dfn_ntp.m01_exchanges (m01_id) ENABLE NOVALIDATE
/
-- End of REF DDL Script for Table DFN_NTP.M96_HOLIDAYS
