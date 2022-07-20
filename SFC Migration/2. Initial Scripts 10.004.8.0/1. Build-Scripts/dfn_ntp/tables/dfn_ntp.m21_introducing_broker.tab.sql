-- Table DFN_NTP.M21_INTRODUCING_BROKER

CREATE TABLE dfn_ntp.m21_introducing_broker
(
    m21_id                         NUMBER (20, 0),
    m21_name                       VARCHAR2 (200),
    m21_name_lang                  VARCHAR2 (200),
    m21_office_telephone           VARCHAR2 (100),
    m21_mobile                     VARCHAR2 (100),
    m21_fax                        VARCHAR2 (100),
    m21_email                      VARCHAR2 (100),
    m21_additional_details         VARCHAR2 (500),
    m21_created_by_id_u17          NUMBER (20, 0),
    m21_created_date               DATE,
    m21_modified_by_id_u17         NUMBER (20, 0),
    m21_modified_date              DATE,
    m21_status_id_v01              NUMBER (20, 0),
    m21_status_changed_date        DATE,
    m21_status_changed_by_id_u17   NUMBER (20, 0)
)
/

-- Constraints for  DFN_NTP.M21_INTRODUCING_BROKER


  ALTER TABLE dfn_ntp.m21_introducing_broker ADD CONSTRAINT m21_introducing_broker_pk PRIMARY KEY (m21_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m21_introducing_broker MODIFY (m21_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m21_introducing_broker MODIFY (m21_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m21_introducing_broker MODIFY (m21_name_lang NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M21_INTRODUCING_BROKER

alter table dfn_ntp.M21_INTRODUCING_BROKER
	add M21_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m21_introducing_broker
 ADD (
  m21_institute_id_m02 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.m21_introducing_broker
    MODIFY (m21_institute_id_m02 DEFAULT 1)
/

ALTER TABLE dfn_ntp.m21_introducing_broker
 ADD (
  m21_incentive_group_id_m162 NUMBER (20)
 )
/