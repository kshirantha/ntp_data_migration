-- Foreign Key for  DFN_NTP.M83_APPROVAL_REQUIRED_COLUMNS


  ALTER TABLE dfn_ntp.m83_approval_required_columns ADD CONSTRAINT fk_m85 FOREIGN KEY (m83_column_id_m85)
   REFERENCES dfn_ntp.m85_approval_columns (m85_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M83_APPROVAL_REQUIRED_COLUMNS
