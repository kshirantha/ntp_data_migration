-- Foreign Key for  DFN_NTP.F05_FALCON_COMPONENT_INFO

ALTER TABLE DFN_NTP.F05_FALCON_COMPONENT_INFO ADD CONSTRAINT FK_F05_F02_ID
  FOREIGN KEY (
F05_PROCESS_ID_F02
)
 REFERENCES DFN_NTP.F02_FALCON_PROCESSES
 ENABLE
 VALIDATE
/

-- End of REF DDL Script for Table DFN_NTP.F05_FALCON_COMPONENT_INFO