CREATE TABLE dfn_ntp.m175_data_loader_type_fields
(
    m175_id                   NUMBER (5, 0) NOT NULL,
    m175_file_type_id_v01     NUMBER (5, 0) NOT NULL,
    m175_field_name           VARCHAR2 (2000 BYTE) NOT NULL,
    m175_field_name_lang      VARCHAR2 (2000 BYTE),
    m175_field_column         VARCHAR2 (2000 BYTE) NOT NULL,
    m175_institution_id_m02   NUMBER (5, 0) DEFAULT NULL NOT NULL,
    m175_custom_type          VARCHAR2 (50 BYTE) DEFAULT '1'
)
/



ALTER TABLE dfn_ntp.m175_data_loader_type_fields
    ADD CONSTRAINT pk_m175 PRIMARY KEY (m175_id) USING INDEX
/

ALTER TABLE dfn_ntp.M175_DATA_LOADER_TYPE_FIELDS 
 ADD (
  M175_FIXED_LENGTH NUMBER (20, 0),
  M175_UNICODE_REQUIRED NUMBER (1, 1) DEFAULT 0 NOT NULL
 )
/
COMMENT ON COLUMN dfn_ntp.M175_DATA_LOADER_TYPE_FIELDS.M175_UNICODE_REQUIRED IS '0:No, 1:Yes'
/
