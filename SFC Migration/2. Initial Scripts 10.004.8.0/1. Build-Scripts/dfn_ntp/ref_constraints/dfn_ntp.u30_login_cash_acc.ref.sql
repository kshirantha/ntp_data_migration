-- Foreign Key for  DFN_NTP.U30_LOGIN_CASH_ACC


  ALTER TABLE dfn_ntp.u30_login_cash_acc ADD CONSTRAINT fk_u30_u09_login_id FOREIGN KEY (u30_login_id_u09)
   REFERENCES dfn_ntp.u09_customer_login (u09_id) ENABLE
/

  ALTER TABLE dfn_ntp.u30_login_cash_acc ADD CONSTRAINT fk_u30_u06_cash_acc_id FOREIGN KEY (u30_cash_acc_id_u06)
   REFERENCES dfn_ntp.u06_cash_account (u06_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U30_LOGIN_CASH_ACC
