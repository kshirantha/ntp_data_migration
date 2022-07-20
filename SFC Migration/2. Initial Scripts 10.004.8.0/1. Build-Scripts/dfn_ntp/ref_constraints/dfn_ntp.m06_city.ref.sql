-- Foreign Key for  DFN_NTP.M06_CITY


  ALTER TABLE dfn_ntp.m06_city ADD CONSTRAINT fkm06_city490434 FOREIGN KEY (m06_country_id_m05)
   REFERENCES dfn_ntp.m05_country (m05_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M06_CITY
