-- Foreign Key for  DFN_NTP.U09_CUSTOMER_LOGIN


  ALTER TABLE dfn_ntp.u09_customer_login ADD CONSTRAINT fku09_custom487900 FOREIGN KEY (u09_customer_id_u01)
   REFERENCES dfn_ntp.u01_customer (u01_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U09_CUSTOMER_LOGIN
