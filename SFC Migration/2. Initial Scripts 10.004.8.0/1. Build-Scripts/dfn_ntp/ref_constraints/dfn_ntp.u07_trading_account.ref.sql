-- Foreign Key for  DFN_NTP.U07_TRADING_ACCOUNT


  ALTER TABLE dfn_ntp.u07_trading_account ADD CONSTRAINT fku07_tradin385152 FOREIGN KEY (u07_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.u07_trading_account ADD CONSTRAINT fku07_tradin916039 FOREIGN KEY (u07_commission_group_id_m22)
   REFERENCES dfn_ntp.m22_commission_group (m22_id) ENABLE
/

  ALTER TABLE dfn_ntp.u07_trading_account ADD CONSTRAINT fku07_tradin515499 FOREIGN KEY (u07_commission_dis_grp_id_m24)
   REFERENCES dfn_ntp.m24_commission_discount_group (m24_id) ENABLE
/

  ALTER TABLE dfn_ntp.u07_trading_account ADD CONSTRAINT fku07_tradin785145 FOREIGN KEY (u07_trading_group_id_m08)
   REFERENCES dfn_ntp.m08_trading_group (m08_id) ENABLE
/

  ALTER TABLE dfn_ntp.u07_trading_account ADD CONSTRAINT fku07_tradin130855 FOREIGN KEY (u07_exe_broker_id_m26)
   REFERENCES dfn_ntp.m26_executing_broker (m26_id) ENABLE
/

  ALTER TABLE dfn_ntp.u07_trading_account ADD CONSTRAINT fku07_tradin424607 FOREIGN KEY (u07_customer_id_u01)
   REFERENCES dfn_ntp.u01_customer (u01_id) ENABLE
/

  ALTER TABLE dfn_ntp.u07_trading_account ADD CONSTRAINT fku07_tradin727360 FOREIGN KEY (u07_cash_account_id_u06)
   REFERENCES dfn_ntp.u06_cash_account (u06_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U07_TRADING_ACCOUNT
