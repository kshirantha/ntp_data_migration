CREATE TABLE dfn_ntp.m91_file_processing_validation
(
    m91_id                           NUMBER (20, 0),
    m91_config_id_m40                NUMBER (20, 0),
    m91_table_id_m42                 NUMBER (20, 0),
    m91_mapping_name                 VARCHAR2 (50 BYTE),
    m91_validation_strategy_id_v01   NUMBER (5, 0),
    m91_value                        VARCHAR2 (50 BYTE),
    m91_custom_type                  VARCHAR2 (2 BYTE)
)
/


ALTER TABLE dfn_ntp.m91_file_processing_validation
ADD CONSTRAINT m91_pk PRIMARY KEY (m91_id)
USING INDEX
/

