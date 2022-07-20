-- Table DFN_NTP.Z25_AUTO_UPDATE_VERSIONS

CREATE TABLE dfn_ntp.z25_auto_update_versions
(
    z25_id                     NUMBER (5, 0),
    z25_application            NUMBER (2, 0),
    z25_internal_version       VARCHAR2 (20),
    z25_external_version       VARCHAR2 (20),
    z25_created_time           DATE DEFAULT SYSDATE,
    z25_created_by_id_u17      NUMBER (10, 0),
    z25_file_name              VARCHAR2 (255),
    z25_status                 NUMBER (1, 0) DEFAULT 0,
    z25_size                   NUMBER (10, 0) DEFAULT 0,
    z25_mode                   NUMBER (1, 0) DEFAULT 0,
    z25_client_type            VARCHAR2 (10),
    z25_min_required_version   VARCHAR2 (20),
    z25_listener               VARCHAR2 (20),
    z25_end_time               DATE,
    z25_blob_id                NUMBER (18, 0),
    z25_client_hash            VARCHAR2 (512),
    z25_file_data              BLOB
)
/

-- Constraints for  DFN_NTP.Z25_AUTO_UPDATE_VERSIONS


  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_application NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_internal_version NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_created_time NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_file_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_status NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_size NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_mode NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_min_required_version NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions MODIFY (z25_listener NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions ADD CONSTRAINT z25_pk PRIMARY KEY (z25_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.z25_auto_update_versions ADD CONSTRAINT z25_uk UNIQUE (z25_internal_version, z25_client_type, z25_listener)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.Z25_AUTO_UPDATE_VERSIONS

COMMENT ON COLUMN dfn_ntp.z25_auto_update_versions.z25_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.z25_auto_update_versions.z25_application IS '1=AT'
/
COMMENT ON COLUMN dfn_ntp.z25_auto_update_versions.z25_created_by_id_u17 IS
    'FK from u17'
/
COMMENT ON COLUMN dfn_ntp.z25_auto_update_versions.z25_status IS
    '0-Started,1=Active,2-Deleted'
/
COMMENT ON COLUMN dfn_ntp.z25_auto_update_versions.z25_mode IS
    '0-normal,1-imidiate'
/
COMMENT ON COLUMN dfn_ntp.z25_auto_update_versions.z25_listener IS
    'listener name'
/
COMMENT ON COLUMN dfn_ntp.z25_auto_update_versions.z25_end_time IS
    'finished time'
/
COMMENT ON TABLE dfn_ntp.z25_auto_update_versions IS
    'this table keeps all the auto updates available in DBC'
/
-- End of DDL Script for Table DFN_NTP.Z25_AUTO_UPDATE_VERSIONS

alter table dfn_ntp.Z25_AUTO_UPDATE_VERSIONS
	add Z25_CUSTOM_TYPE varchar2(50) default 1
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.Z25_AUTO_UPDATE_VERSIONS  ADD (  Z25_FILE_1 NUMBER (1) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('Z25_AUTO_UPDATE_VERSIONS')
           AND column_name = UPPER ('Z25_FILE_1');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.Z25_AUTO_UPDATE_VERSIONS  ADD (  Z25_FILE_2 NUMBER (1) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('Z25_AUTO_UPDATE_VERSIONS')
           AND column_name = UPPER ('Z25_FILE_2');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_nullable   CHAR;
    l_ddl        VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.Z25_AUTO_UPDATE_VERSIONS  MODIFY (  Z25_MIN_REQUIRED_VERSION NULL )';
BEGIN
    SELECT nullable
      INTO l_nullable
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('Z25_AUTO_UPDATE_VERSIONS')
           AND column_name = UPPER ('Z25_MIN_REQUIRED_VERSION');

    IF l_nullable = 'N'
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.Z25_AUTO_UPDATE_VERSIONS  ADD (  Z25_PRIMARY_INSTITUTE_ID NUMBER (20) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('Z25_AUTO_UPDATE_VERSIONS')
           AND column_name = UPPER ('Z25_PRIMARY_INSTITUTE_ID');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/