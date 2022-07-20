-- Foreign Key for  DFN_NTP.U10_LOGIN_TRADING_ACC


  ALTER TABLE dfn_ntp.u10_login_trading_acc ADD CONSTRAINT fk_u10_u09_login_id FOREIGN KEY (u10_login_id_u09)
   REFERENCES dfn_ntp.u09_customer_login (u09_id) ENABLE
/

  ALTER TABLE dfn_ntp.u10_login_trading_acc ADD CONSTRAINT fk_u10_u07_trading_acc_id FOREIGN KEY (u10_trading_acc_id_u07)
   REFERENCES dfn_ntp.u07_trading_account (u07_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U10_LOGIN_TRADING_ACC
