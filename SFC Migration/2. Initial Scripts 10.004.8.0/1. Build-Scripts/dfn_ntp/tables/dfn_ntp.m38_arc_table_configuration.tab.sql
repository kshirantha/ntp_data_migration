CREATE TABLE dfn_ntp.m38_arc_table_configuration
(
    m38_id                      NUMBER (5, 0) NOT NULL,
    m38_source_table            VARCHAR2 (30 BYTE) NOT NULL,
    m38_archive_table           VARCHAR2 (30 BYTE),
    m38_archive_sequence        NUMBER (20, 0) NOT NULL,
    m38_archive_enabled         NUMBER (1, 0) DEFAULT 1 NOT NULL,
    m38_archive_date_field      VARCHAR2 (30 BYTE),
    m38_minimum_archive_days    NUMBER (5, 0),
    m38_filter_expression       VARCHAR2 (1000 BYTE),
    m38_last_success_arc_date   DATE,
    m38_is_archive_ready        NUMBER (1, 0),
    m38_archive_ready_sp_name   VARCHAR2 (50 BYTE)
)
/



ALTER TABLE dfn_ntp.m38_arc_table_configuration
ADD CONSTRAINT m38_pk PRIMARY KEY (m38_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m38_arc_table_configuration.m38_archive_enabled IS
    '0 - Disabled | 1 - Enabled'
/
COMMENT ON COLUMN dfn_ntp.m38_arc_table_configuration.m38_archive_ready_sp_name IS
    'SP needs to be called to update M38_IS_ARCHIVE_READY flag'
/
COMMENT ON COLUMN dfn_ntp.m38_arc_table_configuration.m38_id IS 'M38 pK'
/
COMMENT ON COLUMN dfn_ntp.m38_arc_table_configuration.m38_is_archive_ready IS
    '1 - Archieve Ready, 0 - Need to sync columns from live to archive'
/

ALTER TABLE dfn_ntp.m38_arc_table_configuration
 ADD (
  m38_archive_days NUMBER (5, 0)
 )
/
