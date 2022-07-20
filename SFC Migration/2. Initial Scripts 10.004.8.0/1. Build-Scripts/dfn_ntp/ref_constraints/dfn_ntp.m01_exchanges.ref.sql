-- Foreign Key for  DFN_NTP.M01_EXCHANGES


  ALTER TABLE dfn_ntp.m01_exchanges ADD CONSTRAINT m01_m30_fk FOREIGN KEY (m01_country_id_m05)
   REFERENCES dfn_ntp.m05_country (m05_id) ENABLE
/

  ALTER TABLE dfn_ntp.m01_exchanges ADD CONSTRAINT m01_default_currency_fk_m03 FOREIGN KEY (m01_default_currency_code_m03)
   REFERENCES dfn_ntp.m03_currency (m03_code) ENABLE
/

  ALTER TABLE dfn_ntp.m01_exchanges ADD CONSTRAINT m01_created_by_m06 FOREIGN KEY (m01_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.m01_exchanges ADD CONSTRAINT m01_modified_by_m06 FOREIGN KEY (m01_modified_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.m01_exchanges ADD CONSTRAINT m01_status_changed_by_m06 FOREIGN KEY (m01_status_changed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M01_EXCHANGES
