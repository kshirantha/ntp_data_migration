-- Foreign Key for  DFN_NTP.M54_NOTIFICATION_GROUPS


  ALTER TABLE dfn_ntp.m54_notification_groups ADD CONSTRAINT m54_created_by_u17 FOREIGN KEY (m54_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.m54_notification_groups ADD CONSTRAINT m54_modified_by_u17 FOREIGN KEY (m54_modified_by_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.m54_notification_groups ADD CONSTRAINT m54_status_changed_by_u17 FOREIGN KEY (m54_status_changed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M54_NOTIFICATION_GROUPS
