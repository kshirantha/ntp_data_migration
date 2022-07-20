-- Table DFN_NTP.V22_SYMBOL_STATUS

CREATE TABLE dfn_ntp.v22_symbol_status
(
    v22_id            NUMBER (3, 0),
    v22_description   VARCHAR2 (75)
)
/

-- Constraints for  DFN_NTP.V22_SYMBOL_STATUS


  ALTER TABLE dfn_ntp.v22_symbol_status MODIFY (v22_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v22_symbol_status MODIFY (v22_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v22_symbol_status ADD CONSTRAINT v22_pk PRIMARY KEY (v22_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.V22_SYMBOL_STATUS

COMMENT ON COLUMN dfn_ntp.v22_symbol_status.v22_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.v22_symbol_status.v22_description IS
    'description of SYMBOL_status'
/
-- End of DDL Script for Table DFN_NTP.V22_SYMBOL_STATUS
