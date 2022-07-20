-- Table DFN_NTP.M117_CHARGE_GROUPS

CREATE TABLE dfn_ntp.m117_charge_groups
(
    m117_id                         NUMBER (5, 0),
    m117_name                       VARCHAR2 (75),
    m117_description                VARCHAR2 (500),
    m117_created_date               DATE,
    m117_created_by_id_u17          NUMBER (10, 0),
    m117_status_changed_by_id_u17   NUMBER (10, 0),
    m117_status_changed_date        DATE,
    m117_modified_date              DATE,
    m117_modified_by_id_u17         NUMBER (10, 0),
    m117_status_id_v01              NUMBER (1, 0) DEFAULT 0,
    m117_is_default                 NUMBER (1, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.M117_CHARGE_GROUPS


  ALTER TABLE dfn_ntp.m117_charge_groups ADD CONSTRAINT m117_id_pk PRIMARY KEY (m117_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m117_charge_groups MODIFY (m117_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m117_charge_groups MODIFY (m117_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m117_charge_groups MODIFY (m117_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m117_charge_groups MODIFY (m117_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m117_charge_groups MODIFY (m117_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m117_charge_groups MODIFY (m117_status_id_v01 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M117_CHARGE_GROUPS

alter table dfn_ntp.M117_CHARGE_GROUPS
	add M117_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m117_charge_groups
 ADD (
  m117_institute_id_m02 NUMBER (3, 0)
 )
/


ALTER TABLE dfn_ntp.m117_charge_groups
    MODIFY (m117_institute_id_m02 DEFAULT 1)
/

