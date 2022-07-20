-- Table DFN_NTP.Z08_VERSION

CREATE TABLE dfn_ntp.z08_version
(
    z08_sql                     VARCHAR2 (200),
    z08_version                 NUMBER (18, 0) DEFAULT 1,
    z08_enabled                 NUMBER (1, 0) DEFAULT 1,
    z01_type                    NUMBER (2, 0) DEFAULT 0,
    z01_id                      NUMBER (5, 0),
    z08_last_updated_datetime   DATE
)
/

-- Constraints for  DFN_NTP.Z08_VERSION


  ALTER TABLE dfn_ntp.z08_version MODIFY (z08_sql NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z08_version MODIFY (z08_version NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z08_version MODIFY (z08_enabled NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z08_version MODIFY (z01_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z08_version ADD CONSTRAINT uk_z08_id UNIQUE (z01_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.z08_version ADD CONSTRAINT z08_pk PRIMARY KEY (z08_sql)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.Z08_VERSION

COMMENT ON COLUMN dfn_ntp.z08_version.z08_sql IS 'SQL Statement'
/
COMMENT ON COLUMN dfn_ntp.z08_version.z08_version IS 'Version No'
/
COMMENT ON COLUMN dfn_ntp.z08_version.z08_enabled IS 'Enabled 1=Yes 0=No'
/
COMMENT ON COLUMN dfn_ntp.z08_version.z01_type IS
    '0 - AT Cache, 1 - DT Master'
/
COMMENT ON TABLE dfn_ntp.z08_version IS 'Version Table for Cache Data'
/
-- End of DDL Script for Table DFN_NTP.Z08_VERSION
