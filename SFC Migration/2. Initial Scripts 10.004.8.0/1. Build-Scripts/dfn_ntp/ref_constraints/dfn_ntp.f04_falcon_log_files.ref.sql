-- Foreign Key for  DFN_NTP.F04_FALCON_LOG_FILES


ALTER TABLE DFN_NTP.F04_FALCON_LOG_FILES ADD CONSTRAINT FK_F04_F02_ID
  FOREIGN KEY (
F04_PROCESS_ID_F02
)
 REFERENCES DFN_NTP.F02_FALCON_PROCESSES
 ENABLE
 VALIDATE
/

-- End of REF DDL Script for Table DFN_NTP.F04_FALCON_LOG_FILES