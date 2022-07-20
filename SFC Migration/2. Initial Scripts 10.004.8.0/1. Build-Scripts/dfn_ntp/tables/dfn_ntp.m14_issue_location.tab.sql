-- Table DFN_NTP.M14_ISSUE_LOCATION

CREATE TABLE dfn_ntp.m14_issue_location
(
    m14_id                         NUMBER (5, 0),
    m14_country_id_m05             NUMBER (5, 0),
    m14_name                       VARCHAR2 (50),
    m14_name_lang                  VARCHAR2 (50),
    m14_created_by_id_u17          NUMBER (10, 0),
    m14_created_date               DATE,
    m14_status_id_v01              NUMBER (5, 0),
    m14_modified_by_id_u17         NUMBER (10, 0),
    m14_modified_date              DATE,
    m14_status_changed_by_id_u17   NUMBER (10, 0),
    m14_status_changed_date        DATE,
    m14_external_ref               VARCHAR2 (20),
    PRIMARY KEY (m14_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.M14_ISSUE_LOCATION


  ALTER TABLE dfn_ntp.m14_issue_location MODIFY (m14_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m14_issue_location MODIFY (m14_country_id_m05 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m14_issue_location MODIFY (m14_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m14_issue_location MODIFY (m14_name_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m14_issue_location MODIFY (m14_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m14_issue_location MODIFY (m14_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m14_issue_location MODIFY (m14_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m14_issue_location ADD CONSTRAINT uk_m14_name UNIQUE (m14_name)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.M14_ISSUE_LOCATION

alter table dfn_ntp.M14_ISSUE_LOCATION
	add M14_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m14_issue_location
 ADD (
  m14_institute_id_m02 NUMBER (3)
 )
/

ALTER TABLE dfn_ntp.m14_issue_location
    MODIFY (m14_institute_id_m02 DEFAULT 1)
/

ALTER TABLE dfn_ntp.m14_issue_location
    DROP CONSTRAINT uk_m14_name DROP INDEX
/

ALTER TABLE dfn_ntp.m14_issue_location
    ADD CONSTRAINT uk_m14_name UNIQUE (m14_name, m14_institute_id_m02)
        USING INDEX ENABLE
/
