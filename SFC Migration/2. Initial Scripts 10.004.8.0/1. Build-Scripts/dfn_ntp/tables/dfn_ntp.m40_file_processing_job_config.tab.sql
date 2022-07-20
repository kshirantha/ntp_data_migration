CREATE TABLE dfn_ntp.m40_file_processing_job_config
(
    m40_id                      NUMBER NOT NULL,
    m40_file_type_id_v01        NUMBER NOT NULL,
    m40_template_id_m173        NUMBER,
    m40_file_name_format        VARCHAR2 (500 BYTE),
    m40_file_extension          VARCHAR2 (10 BYTE),
    m40_file_location           VARCHAR2 (2000 BYTE),
    m40_archive_file_location   VARCHAR2 (2000 BYTE),
    m40_error_file_location     VARCHAR2 (2000 BYTE),
    m40_frequency_per_day       NUMBER,
    m40_start_time              DATE,
    m40_parent_config_id_m40    NUMBER,
    m40_notification_enabled    NUMBER,     
    m40_job_status_id_v01       NUMBER (5, 0),
    m40_status_id_v01           NUMBER (1, 0),
    m40_last_update_date_time   DATE,
    m40_last_update_date        DATE,
    m40_institute_id_m02        NUMBER,   
    m40_custom_type             VARCHAR2 (1 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.m40_file_processing_job_config
ADD CONSTRAINT m40_pk PRIMARY KEY (m40_id)
/

COMMENT ON COLUMN dfn_ntp.m40_file_processing_job_config.m40_file_type_id_v01 IS
    'v01_type=72'
/
COMMENT ON COLUMN dfn_ntp.m40_file_processing_job_config.m40_job_status_id_v01 IS
    'v01_type =4'
/
COMMENT ON COLUMN dfn_ntp.m40_file_processing_job_config.m40_status_id_v01 IS
    'v01_type =4'
/







DECLARE
    l_count   NUMBER (10) DEFAULT 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables a
     WHERE     a.owner = 'DFN_NTP'
           AND a.table_name = 'M40_FILE_PROCESSING_JOB_CONFIG';

    IF l_count > 0
    THEN
        EXECUTE IMMEDIATE 'drop table dfn_ntp.m40_file_processing_job_config';
    END IF;
END;
/

CREATE TABLE dfn_ntp.m40_file_processing_job_config
(
    m40_id                      NUMBER NOT NULL,
    m40_description             VARCHAR2 (200 BYTE),
    m40_file_type_id_v01        NUMBER NOT NULL,
    m40_template_id_m173        NUMBER,
    m40_file_name_format        VARCHAR2 (500 BYTE),
    m40_file_location           VARCHAR2 (2000 BYTE),
    m40_archive_file_location   VARCHAR2 (2000 BYTE),
    m40_error_file_location     VARCHAR2 (2000 BYTE),
    m40_frequency_per_day       NUMBER,
    m40_start_time              DATE,
    m40_parent_config_id_m40    NUMBER,
    m40_notification_enabled    NUMBER,
    m40_institute_id_m02        NUMBER,
    m40_job_status_id_v01       NUMBER (5, 0),
    m40_status_id_v01           NUMBER (1, 0),
    m40_last_update_date_time   DATE,
    m40_last_update_date        DATE,
    m40_file_extension          VARCHAR2 (10 BYTE),
    m40_custom_type             VARCHAR2 (1 BYTE) DEFAULT 1
)
/


ALTER TABLE dfn_ntp.m40_file_processing_job_config
ADD CONSTRAINT m40_pk PRIMARY KEY (m40_id)
/

COMMENT ON COLUMN dfn_ntp.m40_file_processing_job_config.m40_file_type_id_v01 IS
    'v01_type=72'
/
COMMENT ON COLUMN dfn_ntp.m40_file_processing_job_config.m40_job_status_id_v01 IS
    'v01_type =4'
/
COMMENT ON COLUMN dfn_ntp.m40_file_processing_job_config.m40_status_id_v01 IS
    'v01_type =4'
/





DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.m40_file_processing_job_config
 ADD (
  m40_is_enable NUMBER(1) DEFAULT 0
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m40_file_processing_job_config')
           AND column_name = UPPER ('m40_is_enable');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.m40_file_processing_job_config.m40_is_enable IS
    '1 - Enable 0 - Disable'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.m40_file_processing_job_config
 ADD (
  m40_is_auto_approve NUMBER(1) DEFAULT 0
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m40_file_processing_job_config')
           AND column_name = UPPER ('m40_is_auto_approve');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.m40_file_processing_job_config.m40_is_auto_approve IS
    '1 - Auto Approve and send to OMS , 0 - Do not auto approve'
/

ALTER TABLE dfn_ntp.m40_file_processing_job_config
 ADD (
  m40_modified_by_id_u17 NUMBER (10),
  m40_modified_date DATE,
  m40_status_changed_by_id_u17 NUMBER (10),
  m40_status_changed_date DATE
)
/

ALTER TABLE dfn_ntp.m40_file_processing_job_config RENAME COLUMN "M40_INSTITUTE_ID_M02" TO "M40_PRIMARY_INSTITUTE_ID_M02"
/
