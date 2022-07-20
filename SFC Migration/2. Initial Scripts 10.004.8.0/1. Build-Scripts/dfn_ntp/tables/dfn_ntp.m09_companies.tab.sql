-- Table DFN_NTP.M09_COMPANIES

CREATE TABLE dfn_ntp.m09_companies
(
    m09_id                         NUMBER (4, 0),
    m09_description                VARCHAR2 (75),
    m09_created_by_id_u17          NUMBER (10, 0),
    m09_created_date               DATE,
    m09_modified_by_id_u17         NUMBER (10, 0),
    m09_modified_date              DATE,
    m09_status_id_v01              NUMBER (20, 0),
    m09_status_changed_by_id_u17   NUMBER (10, 0),
    m09_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M09_COMPANIES


  ALTER TABLE dfn_ntp.m09_companies MODIFY (m09_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m09_companies MODIFY (m09_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m09_companies MODIFY (m09_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m09_companies MODIFY (m09_created_date NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M09_COMPANIES

alter table dfn_ntp.M09_COMPANIES
	add M09_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.M09_COMPANIES 
 ADD (
  M09_INSTITUTE_ID_M02 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.m09_companies
    MODIFY (m09_institute_id_m02 DEFAULT 1)
/
