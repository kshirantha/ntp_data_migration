CREATE TABLE dfn_ntp.m174_data_loader_field_map
(
    m174_id                 NUMBER (5, 0) NOT NULL,
    m174_template_id_m173   NUMBER (5, 0) NOT NULL,
    m174_field_name         VARCHAR2 (2000 BYTE) NOT NULL,
    m174_field_name_lang    VARCHAR2 (2000 BYTE),
    m174_field_column       VARCHAR2 (2000 BYTE) NOT NULL,
    m174_mapping_col_num    NUMBER (5, 0) DEFAULT NULL NOT NULL,
    m174_type               NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m174_custom_type        VARCHAR2 (50 BYTE) DEFAULT 1,
    m174_fixed_length       NUMBER (20, 0)
)
/



ALTER TABLE dfn_ntp.m174_data_loader_field_map
    ADD CONSTRAINT pk_m174 PRIMARY KEY (m174_id) USING INDEX
/


COMMENT ON COLUMN dfn_ntp.m174_data_loader_field_map.m174_type IS
    '0: Default, 1:Custom'
/

ALTER TABLE dfn_ntp.M174_DATA_LOADER_FIELD_MAP 
 ADD (
  M174_UNICODE_REQUIRED NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/
COMMENT ON COLUMN dfn_ntp.M174_DATA_LOADER_FIELD_MAP.M174_UNICODE_REQUIRED IS '0: No, 1:Yes'
/



ALTER TABLE dfn_ntp.m174_data_loader_field_map
 ADD (
  m174_mid_tab_col_mapping_name VARCHAR2 (50)
 )
/
COMMENT ON COLUMN dfn_ntp.m174_data_loader_field_map.m174_mid_tab_col_mapping_name IS
    'Intermediate table mapping column name used for automated file processing'
/
