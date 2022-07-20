CREATE TABLE dfn_ntp.f05_falcon_component_info
(
    f05_id                   VARCHAR2 (50 BYTE),
    f05_component_delay      VARCHAR2 (250 BYTE),
    f05_port                 VARCHAR2 (50 BYTE),
    f05_username             VARCHAR2 (250 BYTE),
    f05_password             VARCHAR2 (250 BYTE),
    f05_configuration_file   VARCHAR2 (250 BYTE),
    f05_process_id_f02       VARCHAR2 (50 BYTE)
)
/

ALTER TABLE dfn_ntp.f05_falcon_component_info ADD CONSTRAINT pk_f05_id
  PRIMARY KEY (
  f05_id
)
 ENABLE
 VALIDATE
/