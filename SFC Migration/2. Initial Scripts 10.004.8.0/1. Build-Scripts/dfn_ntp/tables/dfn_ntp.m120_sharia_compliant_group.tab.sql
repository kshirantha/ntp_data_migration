-- Table DFN_NTP.M120_SHARIA_COMPLIANT_GROUP

CREATE TABLE dfn_ntp.m120_sharia_compliant_group
(
    m120_id                         NUMBER (10, 0),
    m120_name                       VARCHAR2 (100),
    m120_institute_id_m02           NUMBER (5, 0),
    m120_created_by_id_u17          NUMBER (10, 0),
    m120_created_date               DATE,
    m120_modified_by_id_u17         NUMBER (10, 0),
    m120_modified_date              DATE,
    m120_status_id_v01              NUMBER (5, 0),
    m120_status_changed_by_id_u17   NUMBER (10, 0),
    m120_status_changed_date        DATE,
    m120_is_default                 NUMBER (2, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.M120_SHARIA_COMPLIANT_GROUP


  ALTER TABLE dfn_ntp.m120_sharia_compliant_group ADD CONSTRAINT pk_m120_sharia_complient_group PRIMARY KEY (m120_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m120_sharia_compliant_group MODIFY (m120_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m120_sharia_compliant_group MODIFY (m120_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m120_sharia_compliant_group MODIFY (m120_institute_id_m02 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M120_SHARIA_COMPLIANT_GROUP

COMMENT ON COLUMN dfn_ntp.m120_sharia_compliant_group.m120_is_default IS
    '1 - Yes, 0 - No'
/
-- End of DDL Script for Table DFN_NTP.M120_SHARIA_COMPLIANT_GROUP

alter table dfn_ntp.M120_SHARIA_COMPLIANT_GROUP
	add M120_CUSTOM_TYPE varchar2(50) default 1
/