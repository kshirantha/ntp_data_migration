-- Foreign Key for  DFN_NTP.U54_CUSTOMER_EXTERNAL_LOGIN


  ALTER TABLE dfn_ntp.u54_customer_external_login ADD CONSTRAINT fku54_custom230069 FOREIGN KEY (u54_customer_id_u01)
   REFERENCES dfn_ntp.u01_customer (u01_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U54_CUSTOMER_EXTERNAL_LOGIN
