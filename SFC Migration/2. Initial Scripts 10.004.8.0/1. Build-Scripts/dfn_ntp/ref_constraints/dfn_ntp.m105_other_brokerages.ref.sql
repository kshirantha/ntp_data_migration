-- Foreign Key for  DFN_NTP.M105_OTHER_BROKERAGES


  ALTER TABLE dfn_ntp.m105_other_brokerages ADD CONSTRAINT fk_m105_exchange_m01 FOREIGN KEY (m105_exchange_id_m01)
   REFERENCES dfn_ntp.m01_exchanges (m01_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M105_OTHER_BROKERAGES
