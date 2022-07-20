-- Foreign Key for  DFN_NTP.U13_TRADING_SYMBOL


  ALTER TABLE dfn_ntp.u13_trading_symbol ADD CONSTRAINT fku13_tradin786687 FOREIGN KEY (u13_id_u07)
   REFERENCES dfn_ntp.u07_trading_account (u07_id) ENABLE
/

  ALTER TABLE dfn_ntp.u13_trading_symbol ADD CONSTRAINT fku13_tradin404027 FOREIGN KEY (u13_id_m20)
   REFERENCES dfn_ntp.m20_symbol (m20_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U13_TRADING_SYMBOL
