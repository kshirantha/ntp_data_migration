-- Table DFN_NTP.U48_CORP_CUSTOMER_CONTACT

CREATE TABLE dfn_ntp.u48_corp_customer_contact
(
    u48_id                         NUMBER (10, 0),
    u48_customer_id_u01            NUMBER (10, 0),
    u48_is_default                 NUMBER (1, 0),
    u48_mobile                     VARCHAR2 (20),
    u48_fax                        VARCHAR2 (20),
    u48_email                      VARCHAR2 (20),
    u48_telephone                  VARCHAR2 (20),
    u48_title_id_v01               NUMBER (5, 0),
    u48_name                       VARCHAR2 (100),
    u48_position                   VARCHAR2 (50),
    u48_date_of_birth              DATE,
    u48_created_by_id_u17          NUMBER (10, 0),
    u48_created_date               DATE,
    u48_status_id_v01              NUMBER (5, 0),
    u48_modified_by_id_u17         NUMBER (10, 0),
    u48_modified_date              DATE,
    u48_status_changed_by_id_u17   NUMBER (10, 0),
    u48_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.U48_CORP_CUSTOMER_CONTACT


  ALTER TABLE dfn_ntp.u48_corp_customer_contact MODIFY (u48_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u48_corp_customer_contact MODIFY (u48_customer_id_u01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u48_corp_customer_contact MODIFY (u48_is_default NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u48_corp_customer_contact MODIFY (u48_telephone NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u48_corp_customer_contact MODIFY (u48_title_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u48_corp_customer_contact MODIFY (u48_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u48_corp_customer_contact MODIFY (u48_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u48_corp_customer_contact MODIFY (u48_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u48_corp_customer_contact MODIFY (u48_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u48_corp_customer_contact ADD CONSTRAINT u48_pk PRIMARY KEY (u48_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.U48_CORP_CUSTOMER_CONTACT

COMMENT ON COLUMN dfn_ntp.u48_corp_customer_contact.u48_title_id_v01 IS
    'V01_Type = 2'
/
-- End of DDL Script for Table DFN_NTP.U48_CORP_CUSTOMER_CONTACT

COMMENT ON COLUMN dfn_ntp.u48_corp_customer_contact.u48_title_id_v01 IS ''
/

alter table dfn_ntp.U48_CORP_CUSTOMER_CONTACT
	add U48_CUSTOM_TYPE varchar2(50) default 1
/