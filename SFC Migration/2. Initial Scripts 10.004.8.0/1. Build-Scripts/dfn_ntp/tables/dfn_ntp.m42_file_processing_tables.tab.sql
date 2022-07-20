CREATE TABLE dfn_ntp.m42_file_processing_tables
(
    m42_id                    NUMBER (10, 0),
    m42_config_id_m40         NUMBER (10, 0),
    m42_table_name            VARCHAR2 (50 BYTE),
    m42_relationship_id_v01   NUMBER (5, 0),
    m42_sequence              NUMBER,
    m42_source_sql            CLOB,
    m42_control_para_id_m41   NUMBER (10, 0),
    m42_strategy_id_v01       NUMBER (5, 0),
    m42_custom_type           VARCHAR2 (50 BYTE) DEFAULT 1,
    m42_check_column          VARCHAR2 (50 BYTE),
    m42_check_column_value    VARCHAR2 (50 BYTE)
)

/



ALTER TABLE dfn_ntp.m42_file_processing_tables
ADD CONSTRAINT m42_pk PRIMARY KEY (m42_id)
/

COMMENT ON COLUMN dfn_ntp.m42_file_processing_tables.m42_check_column IS
    'this column to check whether record is exist'
/
COMMENT ON COLUMN dfn_ntp.m42_file_processing_tables.m42_strategy_id_v01 IS
    '1 - skip is avilable 2- delete insert'
/
