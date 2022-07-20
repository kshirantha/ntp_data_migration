CREATE TABLE dfn_ntp.m173_data_loader_template
(
    m173_id                    NUMBER (5, 0) NOT NULL,
    m173_file_type_id_v01      NUMBER (5, 0) NOT NULL,
    m173_template_name         VARCHAR2 (2000 BYTE) NOT NULL,
    m173_template_name_lang    VARCHAR2 (2000 BYTE),
    m173_file_format           VARCHAR2 (50 BYTE) DEFAULT NULL NOT NULL,
    m173_separator_type        NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m173_field_separator       VARCHAR2 (5 BYTE),
    m173_line_separator        VARCHAR2 (5 BYTE) NOT NULL,
    m173_skip_first_row        NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m173_created_by_id_u17     NUMBER (10, 0) NOT NULL,
    m173_created_date          TIMESTAMP (6) NOT NULL,
    m173_modified_by_id_u17    NUMBER (10, 0),
    m173_modified_date         TIMESTAMP (6),
    m173_institution_id_m02    NUMBER (5, 0) DEFAULT NULL NOT NULL,
    m173_custom_type           VARCHAR2 (50 BYTE) DEFAULT 1,
    m173_field_separator_id    NUMBER (5, 0),
    m173_line_separator_id     NUMBER (5, 0) NOT NULL,
    m173_table_validated       NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m173_validated_by_id_u17   NUMBER (10, 0),
    m173_validated_date        TIMESTAMP (6)
)
/



ALTER TABLE dfn_ntp.m173_data_loader_template
    ADD CONSTRAINT pk_m173 PRIMARY KEY (m173_id) USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m173_data_loader_template.m173_separator_type IS
    '0: Field Separator, 1: Fixed Length'
/
COMMENT ON COLUMN dfn_ntp.m173_data_loader_template.m173_skip_first_row IS
    '0: No, 1:Yes'
/
COMMENT ON COLUMN dfn_ntp.m173_data_loader_template.m173_table_validated IS
    '0: No, 1:Yes'
/

ALTER TABLE dfn_ntp.M173_DATA_LOADER_TEMPLATE 
 ADD (
  M173_USE_CUSTOM_PROC NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/
COMMENT ON COLUMN dfn_ntp.M173_DATA_LOADER_TEMPLATE.M173_USE_CUSTOM_PROC IS '0: No, 1:Yes'
/

ALTER TABLE dfn_ntp.M173_DATA_LOADER_TEMPLATE 
 ADD (
  M173_DB_PROC_NAME VARCHAR2 (50 BYTE)
 )
/

ALTER TABLE dfn_ntp.M173_DATA_LOADER_TEMPLATE 
 ADD (
  M173_FILE_NAME VARCHAR2 (100 BYTE)
 )
/
COMMENT ON COLUMN dfn_ntp.M173_DATA_LOADER_TEMPLATE.M173_FILE_NAME IS 'Validate file name if value added here'
/

ALTER TABLE dfn_ntp.M173_DATA_LOADER_TEMPLATE 
 ADD (
  M173_EXTERNAL_TABLE_NAME VARCHAR2 (50 BYTE)
 )
/


ALTER TABLE dfn_ntp.M173_DATA_LOADER_TEMPLATE 
 ADD (
  M173_MID_TABLE_NAME VARCHAR2 (50)
 )
/
COMMENT ON COLUMN dfn_ntp.M173_DATA_LOADER_TEMPLATE.M173_MID_TABLE_NAME IS 'Intermediate table name used for automate file processing'
/

ALTER TABLE DFN_NTP.M173_DATA_LOADER_TEMPLATE
 ADD (
  M173_IS_AUTOMATED_FILE NUMBER (1, 0) DEFAULT 0
 )
/
COMMENT ON COLUMN DFN_NTP.M173_DATA_LOADER_TEMPLATE.M173_IS_AUTOMATED_FILE IS '0: No, 1:Yes'
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m173_data_loader_template ADD (  m73_date_column_index NUMBER (5) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m173_data_loader_template')
           AND column_name = UPPER ('m73_date_column_index');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.m173_data_loader_template.m73_date_column_index IS
    'This only for automated file'
/