-- Table DFN_NTP.V02_ENT_SENSITIVE_LEVELS

CREATE TABLE dfn_ntp.v02_ent_sensitive_levels
(
    v02_id            NUMBER (3, 0),
    v02_description   VARCHAR2 (75)
)
/

-- Constraints for  DFN_NTP.V02_ENT_SENSITIVE_LEVELS


  ALTER TABLE dfn_ntp.v02_ent_sensitive_levels MODIFY (v02_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v02_ent_sensitive_levels MODIFY (v02_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v02_ent_sensitive_levels ADD CONSTRAINT v02_pk PRIMARY KEY (v02_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.V02_ENT_SENSITIVE_LEVELS

COMMENT ON COLUMN dfn_ntp.v02_ent_sensitive_levels.v02_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.v02_ent_sensitive_levels.v02_description IS
    'level description'
/
COMMENT ON TABLE dfn_ntp.v02_ent_sensitive_levels IS
    'this table keeps the sensitive levels for entitlements'
/
-- End of DDL Script for Table DFN_NTP.V02_ENT_SENSITIVE_LEVELS
