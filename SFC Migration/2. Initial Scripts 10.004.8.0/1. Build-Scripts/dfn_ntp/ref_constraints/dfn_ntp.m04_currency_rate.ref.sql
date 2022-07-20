-- Foreign Key for  DFN_NTP.M04_CURRENCY_RATE


  ALTER TABLE dfn_ntp.m04_currency_rate ADD CONSTRAINT fkm04_curren202188 FOREIGN KEY (m04_from_currency_code_m03)
   REFERENCES dfn_ntp.m03_currency (m03_code) ENABLE
/

  ALTER TABLE dfn_ntp.m04_currency_rate ADD CONSTRAINT fkm04_curren89006 FOREIGN KEY (m04_to_currency_code_m03)
   REFERENCES dfn_ntp.m03_currency (m03_code) ENABLE
/

  ALTER TABLE dfn_ntp.m04_currency_rate ADD CONSTRAINT fkm04_curren327244 FOREIGN KEY (m04_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M04_CURRENCY_RATE
