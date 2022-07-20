-- Table DFN_NTP.M113_FATCA_INSTITUTIONS

CREATE TABLE dfn_ntp.m113_fatca_institutions
(
    m113_id                 NUMBER (3, 0),
    m113_type               NUMBER (1, 0),
    m113_sub_type           NUMBER (1, 0),
    m113_institution        VARCHAR2 (50),
    m113_institution_lang   VARCHAR2 (50)
)
/

-- Constraints for  DFN_NTP.M113_FATCA_INSTITUTIONS


  ALTER TABLE dfn_ntp.m113_fatca_institutions ADD CONSTRAINT m113_id_pk PRIMARY KEY (m113_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m113_fatca_institutions MODIFY (m113_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m113_fatca_institutions MODIFY (m113_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m113_fatca_institutions MODIFY (m113_sub_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m113_fatca_institutions MODIFY (m113_institution NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M113_FATCA_INSTITUTIONS

COMMENT ON COLUMN dfn_ntp.m113_fatca_institutions.m113_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m113_fatca_institutions.m113_type IS
    '0=Unclassified, 1=Financial, 2=Non Financial'
/
COMMENT ON COLUMN dfn_ntp.m113_fatca_institutions.m113_sub_type IS
    '0=Unclassified, 1=US, 2=Non US'
/
-- End of DDL Script for Table DFN_NTP.M113_FATCA_INSTITUTIONS
