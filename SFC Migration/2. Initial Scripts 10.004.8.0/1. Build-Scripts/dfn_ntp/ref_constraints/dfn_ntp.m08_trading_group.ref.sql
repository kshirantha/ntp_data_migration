-- Foreign Key for  DFN_NTP.M08_TRADING_GROUP


  ALTER TABLE dfn_ntp.m08_trading_group ADD CONSTRAINT fkm08_tradin847435 FOREIGN KEY (m08_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M08_TRADING_GROUP
