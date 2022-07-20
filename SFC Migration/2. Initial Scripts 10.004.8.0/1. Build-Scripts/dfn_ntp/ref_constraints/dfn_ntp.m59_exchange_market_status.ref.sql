-- Foreign Key for  DFN_NTP.M59_EXCHANGE_MARKET_STATUS


  ALTER TABLE dfn_ntp.m59_exchange_market_status ADD CONSTRAINT m59_m01 FOREIGN KEY (m59_exchange_id_m01)
   REFERENCES dfn_ntp.m01_exchanges (m01_id) ENABLE
/

  ALTER TABLE dfn_ntp.m59_exchange_market_status ADD CONSTRAINT m59_v19 FOREIGN KEY (m59_market_status_id_v19)
   REFERENCES dfn_ntp.v19_market_status (v19_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M59_EXCHANGE_MARKET_STATUS
