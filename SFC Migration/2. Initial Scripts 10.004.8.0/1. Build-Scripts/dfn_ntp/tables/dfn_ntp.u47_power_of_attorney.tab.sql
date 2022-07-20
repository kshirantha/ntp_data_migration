-- Table DFN_NTP.U47_POWER_OF_ATTORNEY

CREATE TABLE dfn_ntp.u47_power_of_attorney
(
    u47_id                         NUMBER (10, 0),
    u47_customer_id_u01            NUMBER (10, 0),
    u47_poa_customer_id_u01        NUMBER (10, 0),
    u47_poa_name                   VARCHAR2 (255),
    u47_poa_name_lang              VARCHAR2 (255),
    u47_zip                        VARCHAR2 (100),
    u47_po_box                     VARCHAR2 (255),
    u47_street_address_1           VARCHAR2 (255),
    u47_street_address_2           VARCHAR2 (255),
    u47_city_id_m06                NUMBER (5, 0),
    u47_country_id_m05             NUMBER (5, 0),
    u47_nationality_id_m05         NUMBER (5, 0),
    u47_id_type_m15                NUMBER (5, 0),
    u47_poa_type                   NUMBER (3, 0) DEFAULT 0,
    u47_id_no                      VARCHAR2 (100),
    u47_id_expiry_date             DATE,
    u47_contact_no                 VARCHAR2 (25),
    u47_bank_acc_no                VARCHAR2 (100),
    u47_created_by_id_u17          NUMBER (10, 0),
    u47_created_date               DATE,
    u47_modified_by_id_u17         NUMBER (10, 0),
    u47_modified_date              DATE,
    u47_status_id_v01              NUMBER (5, 0),
    u47_status_changed_by_id_u17   NUMBER (10, 0),
    u47_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.U47_POWER_OF_ATTORNEY


  ALTER TABLE dfn_ntp.u47_power_of_attorney ADD CONSTRAINT pk_u47 PRIMARY KEY (u47_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney MODIFY (u47_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney MODIFY (u47_customer_id_u01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney MODIFY (u47_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney MODIFY (u47_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney MODIFY (u47_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney MODIFY (u47_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u47_power_of_attorney MODIFY (u47_status_changed_date NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.U47_POWER_OF_ATTORNEY

COMMENT ON COLUMN dfn_ntp.u47_power_of_attorney.u47_poa_customer_id_u01 IS
    'Reference for Existing Customer as POA'
/
COMMENT ON COLUMN dfn_ntp.u47_power_of_attorney.u47_poa_type IS
    '0 - None, 1 - Family, 2 - Non-Family, 3 - Guardian, 4 - Guardian for Impaired'
/
-- End of DDL Script for Table DFN_NTP.U47_POWER_OF_ATTORNEY

alter table dfn_ntp.U47_POWER_OF_ATTORNEY
	add U47_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.U47_POWER_OF_ATTORNEY 
 ADD (
  u47_institute_id_m02 NUMBER (3) DEFAULT 1
 )
/

CREATE INDEX dfn_ntp.idx_u47_customer_id_u01 ON dfn_ntp.u47_power_of_attorney
( u47_customer_id_u01 ASC)
/

