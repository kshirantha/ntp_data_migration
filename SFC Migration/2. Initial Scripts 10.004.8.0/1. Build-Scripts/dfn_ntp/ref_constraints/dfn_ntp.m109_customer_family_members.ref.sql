-- Foreign Key for  DFN_NTP.M109_CUSTOMER_FAMILY_MEMBERS


  ALTER TABLE dfn_ntp.m109_customer_family_members ADD CONSTRAINT m109_customer_id_m01 FOREIGN KEY (m109_customer_id_u01)
   REFERENCES dfn_ntp.u01_customer (u01_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m109_customer_family_members ADD CONSTRAINT m109_family_member_m01 FOREIGN KEY (m109_family_member_id_u01)
   REFERENCES dfn_ntp.u01_customer (u01_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m109_customer_family_members ADD CONSTRAINT m109_created_by_m06 FOREIGN KEY (m109_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m109_customer_family_members ADD CONSTRAINT m109_modified_by_m06 FOREIGN KEY (m109_modified_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE NOVALIDATE
/
-- End of REF DDL Script for Table DFN_NTP.M109_CUSTOMER_FAMILY_MEMBERS
