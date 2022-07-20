-- Table DFN_NTP.M112_FATCA_ENTITIES

CREATE TABLE dfn_ntp.m112_fatca_entities
(
    m112_id          NUMBER (2, 0),
    m112_type        NUMBER (1, 0),
    m112_name        VARCHAR2 (255),
    m112_name_lang   VARCHAR2 (255)
)
/

-- Constraints for  DFN_NTP.M112_FATCA_ENTITIES


  ALTER TABLE dfn_ntp.m112_fatca_entities ADD CONSTRAINT m112_id_pk PRIMARY KEY (m112_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m112_fatca_entities MODIFY (m112_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m112_fatca_entities MODIFY (m112_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m112_fatca_entities MODIFY (m112_name NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M112_FATCA_ENTITIES

COMMENT ON COLUMN dfn_ntp.m112_fatca_entities.m112_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m112_fatca_entities.m112_type IS
    '1=Status, 2=Certification, 3=Classification'
/
-- End of DDL Script for Table DFN_NTP.M112_FATCA_ENTITIES
