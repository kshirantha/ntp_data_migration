CREATE TABLE dfn_ntp.z10_version_audit_log
(
    z10_id            NUMBER (18, 0) NOT NULL,
    z10_application   VARCHAR2 (100 CHAR) NOT NULL,
    z10_date          DATE NOT NULL,
    z10_version       VARCHAR2 (100 BYTE) NOT NULL
)
/


ALTER TABLE dfn_ntp.z10_version_audit_log
ADD CONSTRAINT pk_z10 PRIMARY KEY (z10_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.z10_version_audit_log.z10_id IS 'PK'
/

ALTER TABLE dfn_ntp.z10_version_audit_log
 ADD (
  z10_core_version VARCHAR2 (100 BYTE),
  z10_country_version VARCHAR2 (100 BYTE)
 )
/

ALTER TABLE dfn_ntp.z10_version_audit_log
 MODIFY (
  z10_version NULL

 )
/

DELETE FROM dfn_ntp.z10_version_audit_log;

COMMIT;

ALTER TABLE dfn_ntp.z10_version_audit_log
RENAME COLUMN z10_country_version TO z10_broker_version
/
ALTER TABLE dfn_ntp.z10_version_audit_log
RENAME COLUMN z10_core_version TO z10_country_version
/
ALTER TABLE dfn_ntp.z10_version_audit_log
RENAME COLUMN z10_version TO z10_core_version
/




