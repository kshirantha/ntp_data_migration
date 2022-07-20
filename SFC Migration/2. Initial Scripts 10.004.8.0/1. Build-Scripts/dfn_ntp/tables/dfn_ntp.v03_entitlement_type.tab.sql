-- Table DFN_NTP.V03_ENTITLEMENT_TYPE

CREATE TABLE dfn_ntp.v03_entitlement_type
(
    v03_id            NUMBER (10, 0),
    v03_description   VARCHAR2 (255)
)
/

-- Constraints for  DFN_NTP.V03_ENTITLEMENT_TYPE


  ALTER TABLE dfn_ntp.v03_entitlement_type MODIFY (v03_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v03_entitlement_type ADD CONSTRAINT v03_description_uk UNIQUE (v03_description)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.v03_entitlement_type ADD CONSTRAINT v03_pk PRIMARY KEY (v03_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.V03_ENTITLEMENT_TYPE

COMMENT ON COLUMN dfn_ntp.v03_entitlement_type.v03_id IS 'Primary Key'
/
COMMENT ON COLUMN dfn_ntp.v03_entitlement_type.v03_description IS
    'Description'
/
COMMENT ON TABLE dfn_ntp.v03_entitlement_type IS 'Entitlement Types'
/
-- End of DDL Script for Table DFN_NTP.V03_ENTITLEMENT_TYPE
