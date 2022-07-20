CREATE TABLE dfn_ntp.m48_file_processing_columns
(
    m48_id                        NUMBER (10, 0),
    m48_table_id_m42              NUMBER (10, 0),
    m48_column_name               VARCHAR2 (50 BYTE),
    m48_mapping_name              VARCHAR2 (50 BYTE),
    m48_mapping_strategy_id_v01   NUMBER (5, 0),
    m48_default_value             VARCHAR2 (500 BYTE),
    m48_custom_type               VARCHAR2 (50 BYTE) DEFAULT 1,
    m48_config_id_m40             NUMBER
)
/



ALTER TABLE dfn_ntp.m48_file_processing_columns
ADD CONSTRAINT m48_pk PRIMARY KEY (m48_id)
/

COMMENT ON COLUMN dfn_ntp.m48_file_processing_columns.m48_mapping_name IS
    'Accroding to M42_source_sql'
/
COMMENT ON COLUMN dfn_ntp.m48_file_processing_columns.m48_mapping_strategy_id_v01 IS
    '1 - use default value 2. use default value if value is null 3 - use value only 4-use job paravalue 5 - use unique key'
/
