-- Foreign Key for  DFN_NTP.U06_CASH_ACCOUNT


  ALTER TABLE dfn_ntp.u06_cash_account ADD CONSTRAINT fku06_cash_a675852 FOREIGN KEY (u06_currency_code_m03)
   REFERENCES dfn_ntp.m03_currency (m03_code) ENABLE
/

  ALTER TABLE dfn_ntp.u06_cash_account ADD CONSTRAINT fku06_cash_a955183 FOREIGN KEY (u06_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.u06_cash_account ADD CONSTRAINT fku06_cash_a915728 FOREIGN KEY (u06_customer_id_u01)
   REFERENCES dfn_ntp.u01_customer (u01_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U06_CASH_ACCOUNT
