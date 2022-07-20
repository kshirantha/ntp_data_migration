-- Foreign Key for  DFN_NTP.U48_CORP_CUSTOMER_CONTACT


  ALTER TABLE dfn_ntp.u48_corp_customer_contact ADD CONSTRAINT u48_corp_customer_contact_fk FOREIGN KEY (u48_customer_id_u01)
   REFERENCES dfn_ntp.u01_customer (u01_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U48_CORP_CUSTOMER_CONTACT
