-- Foreign Key for  DFN_NTP.U47_POWER_OF_ATTORNEY


  ALTER TABLE dfn_ntp.u47_power_of_attorney ADD CONSTRAINT fk_u47_u01_id FOREIGN KEY (u47_customer_id_u01)
   REFERENCES dfn_ntp.u01_customer (u01_id) ENABLE
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney ADD CONSTRAINT fk_u47_m05_id FOREIGN KEY (u47_country_id_m05)
   REFERENCES dfn_ntp.m05_country (m05_id) ENABLE
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney ADD CONSTRAINT fk_u47_m06_id FOREIGN KEY (u47_city_id_m06)
   REFERENCES dfn_ntp.m06_city (m06_id) ENABLE
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney ADD CONSTRAINT fk_u47_m06_id_nationality FOREIGN KEY (u47_nationality_id_m05)
   REFERENCES dfn_ntp.m05_country (m05_id) ENABLE
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney ADD CONSTRAINT fk_u47_u17_id_created FOREIGN KEY (u47_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney ADD CONSTRAINT fk_u47_u17_id_modified FOREIGN KEY (u47_modified_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney ADD CONSTRAINT fk_u47_u17_status_chg FOREIGN KEY (u47_status_changed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney ADD CONSTRAINT fk_u47_m15_id FOREIGN KEY (u47_id_type_m15)
   REFERENCES dfn_ntp.m15_identity_type (m15_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U47_POWER_OF_ATTORNEY
