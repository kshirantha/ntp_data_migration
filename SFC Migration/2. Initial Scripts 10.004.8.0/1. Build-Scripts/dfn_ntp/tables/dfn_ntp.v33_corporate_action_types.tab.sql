-- Table DFN_NTP.V33_CORPORATE_ACTION_TYPES

CREATE TABLE dfn_ntp.v33_corporate_action_types
(
    v33_id            NUMBER (5, 0),
    v33_code          VARCHAR2 (10),
    v33_description   VARCHAR2 (100),
    v33_category      NUMBER (1, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.V33_CORPORATE_ACTION_TYPES


  ALTER TABLE dfn_ntp.v33_corporate_action_types ADD CONSTRAINT pk_v33_id PRIMARY KEY (v33_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.v33_corporate_action_types MODIFY (v33_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v33_corporate_action_types MODIFY (v33_code NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v33_corporate_action_types MODIFY (v33_description NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.V33_CORPORATE_ACTION_TYPES

COMMENT ON COLUMN dfn_ntp.v33_corporate_action_types.v33_category IS
    '0 - International | 1 - Local (TDWLSpecific)'
/
COMMENT ON TABLE dfn_ntp.v33_corporate_action_types IS
    'TDWL Specific Corporate Actions Starts from 101'
/
-- End of DDL Script for Table DFN_NTP.V33_CORPORATE_ACTION_TYPES
