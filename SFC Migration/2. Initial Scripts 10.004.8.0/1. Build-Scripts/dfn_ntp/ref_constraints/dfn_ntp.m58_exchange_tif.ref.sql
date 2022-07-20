-- Foreign Key for  DFN_NTP.M58_EXCHANGE_TIF


  ALTER TABLE dfn_ntp.m58_exchange_tif ADD CONSTRAINT m58_exchange_m01 FOREIGN KEY (m58_exchange_id_m01)
   REFERENCES dfn_ntp.m01_exchanges (m01_id) ENABLE
/

  ALTER TABLE dfn_ntp.m58_exchange_tif ADD CONSTRAINT m58_tif_v10 FOREIGN KEY (m58_tif_id_v10)
   REFERENCES dfn_ntp.v10_tif (v10_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M58_EXCHANGE_TIF
