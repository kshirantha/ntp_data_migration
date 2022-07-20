-- Foreign Key for  DFN_NTP.M95_SETTLEMENT_CALENDAR_CONFIG


  ALTER TABLE dfn_ntp.m95_settlement_calendar_config ADD CONSTRAINT m95_exchange_m01 FOREIGN KEY (m95_exchange_id_m01)
   REFERENCES dfn_ntp.m01_exchanges (m01_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m95_settlement_calendar_config ADD CONSTRAINT m95_currency_m03 FOREIGN KEY (m95_currency_code_m03)
   REFERENCES dfn_ntp.m03_currency (m03_code) ENABLE NOVALIDATE
/
-- End of REF DDL Script for Table DFN_NTP.M95_SETTLEMENT_CALENDAR_CONFIG
