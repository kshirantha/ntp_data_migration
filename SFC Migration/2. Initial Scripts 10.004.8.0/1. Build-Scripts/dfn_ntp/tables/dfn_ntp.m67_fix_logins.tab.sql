-- Table DFN_NTP.M67_FIX_LOGINS

CREATE TABLE dfn_ntp.m67_fix_logins
(
    m67_login_id             VARCHAR2 (20),
    m67_inst_id_m02          NUMBER (5, 0),
    m67_enabled              NUMBER (1, 0) DEFAULT 0,
    m67_id                   NUMBER (20, 0),
    m67_mubasher_no          VARCHAR2 (10),
    m67_created_by_id_u17    NUMBER (10, 0),
    m67_created_date         DATE,
    m67_modified_by_id_u17   NUMBER (10, 0),
    m67_modified_date        DATE
)
/

-- Constraints for  DFN_NTP.M67_FIX_LOGINS


  ALTER TABLE dfn_ntp.m67_fix_logins ADD CONSTRAINT m67_login_id_uk UNIQUE (m67_login_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m67_fix_logins ADD CONSTRAINT m67_pk PRIMARY KEY (m67_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m67_fix_logins MODIFY (m67_login_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m67_fix_logins MODIFY (m67_id NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M67_FIX_LOGINS

COMMENT ON COLUMN dfn_ntp.m67_fix_logins.m67_enabled IS
    '1 - enable, 0 - disable'
/
COMMENT ON COLUMN dfn_ntp.m67_fix_logins.m67_id IS 'pk'
/
-- End of DDL Script for Table DFN_NTP.M67_FIX_LOGINS

alter table dfn_ntp.M67_FIX_LOGINS
	add M67_CUSTOM_TYPE varchar2(50) default 1
/