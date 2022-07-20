-- Table DFN_NTP.M83_APPROVAL_REQUIRED_COLUMNS

CREATE TABLE dfn_ntp.m83_approval_required_columns
(
    m83_id              NUMBER (5, 0),
    m83_table_id_m53    NUMBER (5, 0),
    m83_column_id_m85   NUMBER (5, 0)
)
/



-- Comments for  DFN_NTP.M83_APPROVAL_REQUIRED_COLUMNS

COMMENT ON COLUMN dfn_ntp.m83_approval_required_columns.m83_column_id_m85 IS
    'FK from M85'
/
-- End of DDL Script for Table DFN_NTP.M83_APPROVAL_REQUIRED_COLUMNS

alter table dfn_ntp.M83_APPROVAL_REQUIRED_COLUMNS
	add M83_Custom_Type varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m83_approval_required_columns
 ADD (
  m83_dependant_no NUMBER (2, 0)
 )
/
COMMENT ON COLUMN dfn_ntp.m83_approval_required_columns.m83_dependant_no IS
    'Group of Dependant Columns Have Same No'
/

ALTER TABLE dfn_ntp.m83_approval_required_columns
 ADD (
  m83_is_sensitive_data NUMBER (1) DEFAULT 0,
  m83_entitlement_id_v04 NUMBER (10)
 )
/