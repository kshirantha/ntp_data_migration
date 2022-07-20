-- Foreign Key for  DFN_NTP.U08_CUSTOMER_BENEFICIARY_ACC


  ALTER TABLE dfn_ntp.u08_customer_beneficiary_acc ADD CONSTRAINT fku08_custom651108 FOREIGN KEY (u08_bank_id_m16)
   REFERENCES dfn_ntp.m16_bank (m16_id) ENABLE
/

  ALTER TABLE dfn_ntp.u08_customer_beneficiary_acc ADD CONSTRAINT fku08_custom63295 FOREIGN KEY (u08_currency_code_m03)
   REFERENCES dfn_ntp.m03_currency (m03_code) ENABLE
/

  ALTER TABLE dfn_ntp.u08_customer_beneficiary_acc ADD CONSTRAINT fku08_custom977405 FOREIGN KEY (u08_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.u08_customer_beneficiary_acc ADD CONSTRAINT fku08_custom16861 FOREIGN KEY (u08_customer_id_u01)
   REFERENCES dfn_ntp.u01_customer (u01_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U08_CUSTOMER_BENEFICIARY_ACC
