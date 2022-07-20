-- Foreign Key for  DFN_NTP.M63_SECTORS


  ALTER TABLE dfn_ntp.m63_sectors ADD CONSTRAINT m63_exchangecode_m01_fk FOREIGN KEY (m63_exchange_id_m01)
   REFERENCES dfn_ntp.m01_exchanges (m01_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m63_sectors ADD CONSTRAINT m63_created_by_m06 FOREIGN KEY (m63_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m63_sectors ADD CONSTRAINT m63_modified_by_m06 FOREIGN KEY (m63_modified_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m63_sectors ADD CONSTRAINT m63_status_changed_by_m06 FOREIGN KEY (m63_status_changed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE NOVALIDATE
/
-- End of REF DDL Script for Table DFN_NTP.M63_SECTORS
