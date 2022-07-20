-- Foreign Key for  DFN_NTP.M84_APPROVAL_EXCLUDE_COLUMNS


  ALTER TABLE dfn_ntp.m84_approval_exclude_columns ADD CONSTRAINT fk_m84_column_id_m85 FOREIGN KEY (m84_column_id_m85)
   REFERENCES dfn_ntp.m85_approval_columns (m85_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M84_APPROVAL_EXCLUDE_COLUMNS
