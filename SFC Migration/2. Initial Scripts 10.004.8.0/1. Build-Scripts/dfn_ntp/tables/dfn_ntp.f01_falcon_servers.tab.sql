CREATE TABLE dfn_ntp.f01_falcon_servers
(
    f01_ip_address   VARCHAR2 (50 BYTE),
    f01_auth_token   VARCHAR2 (50 BYTE),
    f01_status       VARCHAR2 (50 BYTE)
)
/

ALTER TABLE DFN_NTP.f01_FALCON_SERVERS ADD CONSTRAINT PK_f01_FALCON_SERVERS
  PRIMARY KEY (
  f01_AUTH_TOKEN
)
 ENABLE
 VALIDATE
/

COMMENT ON COLUMN DFN_NTP.f01_FALCON_SERVERS.f01_STATUS IS '"active": server is available and "passive": server is removed'
/