-- Foreign Key for  DFN_NTP.U21_LOGIN_TRADING_RESTRICTION


  ALTER TABLE dfn_ntp.u21_login_trading_restriction ADD CONSTRAINT fk_u10 FOREIGN KEY (u21_login_id_u10)
   REFERENCES dfn_ntp.u10_login_trading_acc (u10_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U21_LOGIN_TRADING_RESTRICTION
