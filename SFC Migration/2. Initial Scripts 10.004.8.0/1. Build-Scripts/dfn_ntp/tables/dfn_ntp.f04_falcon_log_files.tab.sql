CREATE TABLE dfn_ntp.f04_falcon_log_files
(
    f04_id               VARCHAR2 (50 BYTE),
    f04_file_path        VARCHAR2 (250 BYTE),
    f04_process_id_f02   VARCHAR2 (50 BYTE)
)
/

ALTER TABLE DFN_NTP.f04_FALCON_LOG_FILES ADD CONSTRAINT PK_f04_ID
  PRIMARY KEY (
  f04_ID
)
 ENABLE
 VALIDATE
/
