-- Table DFN_NTP.M24_COMMISSION_DISCOUNT_GROUP

CREATE TABLE dfn_ntp.m24_commission_discount_group
(
    m24_id                         NUMBER (5, 0),
    m24_description                VARCHAR2 (200),
    m24_name                       VARCHAR2 (50),
    m24_name_lang                  VARCHAR2 (50),
    m24_created_by_id_u17          NUMBER (10, 0),
    m24_created_date               DATE,
    m24_modified_by_id_u17         NUMBER (10, 0),
    m24_modified_date              DATE,
    m24_status_id_v01              NUMBER (20, 0),
    m24_status_changed_by_id_u17   NUMBER (10, 0),
    m24_status_changed_date        DATE,
    m24_external_ref               VARCHAR2 (10),
    m24_institution_id_m02         NUMBER (10, 0),
    PRIMARY KEY (m24_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
OVERFLOW
/

-- Constraints for  DFN_NTP.M24_COMMISSION_DISCOUNT_GROUP


  ALTER TABLE dfn_ntp.m24_commission_discount_group MODIFY (m24_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m24_commission_discount_group MODIFY (m24_description NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M24_COMMISSION_DISCOUNT_GROUP

alter table dfn_ntp.M24_COMMISSION_DISCOUNT_GROUP
	add M24_CUSTOM_TYPE varchar2(50) default 1
/
