-- Foreign Key for  DFN_NTP.M14_ISSUE_LOCATION


  ALTER TABLE dfn_ntp.m14_issue_location ADD CONSTRAINT fkm14_issue_362903 FOREIGN KEY (m14_country_id_m05)
   REFERENCES dfn_ntp.m05_country (m05_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M14_ISSUE_LOCATION
