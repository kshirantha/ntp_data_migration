-- Foreign Key for  DFN_NTP.M110_REASONS


  ALTER TABLE dfn_ntp.m110_reasons ADD CONSTRAINT fk_m110_m127_reason_type FOREIGN KEY (m110_type)
   REFERENCES dfn_ntp.m127_reason_types (m127_id) ENABLE
/

  ALTER TABLE dfn_ntp.m110_reasons ADD CONSTRAINT fk_m110_u17_created FOREIGN KEY (m110_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.m110_reasons ADD CONSTRAINT fk_m110_u17_modified FOREIGN KEY (m110_modified_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.m110_reasons ADD CONSTRAINT fk_m110_u17_status_changed FOREIGN KEY (m110_status_changed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M110_REASONS
