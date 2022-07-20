-- Foreign Key for  DFN_NTP.U15_TRADING_INSTRUMENT


  ALTER TABLE dfn_ntp.u15_trading_instrument ADD CONSTRAINT fku15_tradin147989 FOREIGN KEY (u15_id_u07)
   REFERENCES dfn_ntp.u07_trading_account (u07_id) ENABLE
/

  ALTER TABLE dfn_ntp.u15_trading_instrument ADD CONSTRAINT fku15_tradin521623 FOREIGN KEY (u15_id_m18)
   REFERENCES dfn_ntp.m18_instrument (m18_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U15_TRADING_INSTRUMENT
