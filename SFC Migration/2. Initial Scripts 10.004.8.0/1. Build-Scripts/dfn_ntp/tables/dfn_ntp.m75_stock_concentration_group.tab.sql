-- Table DFN_NTP.M75_STOCK_CONCENTRATION_GROUP

CREATE TABLE dfn_ntp.m75_stock_concentration_group
(
    m75_id                         NUMBER (10, 0),
    m75_institute_id_m02           NUMBER (20, 0) DEFAULT 1,
    m75_type                       NUMBER (1, 0),
    m75_description                VARCHAR2 (100),
    m75_additional_details         VARCHAR2 (500),
    m75_status_id_v01              NUMBER (10, 0),
    m75_exchange_id_m01            NUMBER (5, 0),
    m75_exchange_code_m01          VARCHAR2 (10) DEFAULT 'TDWL',
    m75_created_by_id_u17          NUMBER (20, 0),
    m75_created_date               DATE,
    m75_modified_by_id_u17         NUMBER (20, 0),
    m75_modified_date              DATE,
    m75_status_changed_by_id_u17   NUMBER (10, 0),
    m75_status_changed_date        DATE
)
/



-- Comments for  DFN_NTP.M75_STOCK_CONCENTRATION_GROUP

COMMENT ON COLUMN dfn_ntp.m75_stock_concentration_group.m75_id IS 'pk m75'
/
COMMENT ON COLUMN dfn_ntp.m75_stock_concentration_group.m75_type IS
    '1 - Margin | 2 - Holdings Ownership'
/
COMMENT ON COLUMN dfn_ntp.m75_stock_concentration_group.m75_exchange_code_m01 IS
    'fk m02'
/
COMMENT ON COLUMN dfn_ntp.m75_stock_concentration_group.m75_created_by_id_u17 IS
    'fku17'
/
COMMENT ON COLUMN dfn_ntp.m75_stock_concentration_group.m75_modified_by_id_u17 IS
    'fk u17'
/
-- End of DDL Script for Table DFN_NTP.M75_STOCK_CONCENTRATION_GROUP

alter table dfn_ntp.M75_STOCK_CONCENTRATION_GROUP
	add M75_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.M75_STOCK_CONCENTRATION_GROUP 
 ADD (
  M75_GLOBAL_CONCENTRATION_PCT NUMBER (5, 2) DEFAULT 100
 )
/