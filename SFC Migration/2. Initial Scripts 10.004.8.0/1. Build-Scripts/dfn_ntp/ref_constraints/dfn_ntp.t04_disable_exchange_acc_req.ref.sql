-- Foreign Key for  DFN_NTP.T04_DISABLE_EXCHANGE_ACC_REQ


  ALTER TABLE dfn_ntp.t04_disable_exchange_acc_req ADD CONSTRAINT fk_t04_trading_acc_id_u07 FOREIGN KEY (t04_trading_acc_id_u07)
   REFERENCES dfn_ntp.u07_trading_account (u07_id) ENABLE
/

  ALTER TABLE dfn_ntp.t04_disable_exchange_acc_req ADD CONSTRAINT fk_t04_created_by_u17 FOREIGN KEY (t04_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.T04_DISABLE_EXCHANGE_ACC_REQ
