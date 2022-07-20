CREATE TABLE dfn_ntp.f03_falcon_controllers
(
    f03_id               VARCHAR2 (50 BYTE),
    f03_property_value   VARCHAR2 (50 BYTE),
    f03_method           VARCHAR2 (250 BYTE),
    f03_username         VARCHAR2 (250 BYTE),
    f03_path             VARCHAR2 (250 BYTE)
)
/

ALTER TABLE DFN_NTP.f03_FALCON_CONTROLLERS ADD CONSTRAINT PK_f03_ID
  PRIMARY KEY (
  f03_ID
)
 ENABLE
 VALIDATE
/