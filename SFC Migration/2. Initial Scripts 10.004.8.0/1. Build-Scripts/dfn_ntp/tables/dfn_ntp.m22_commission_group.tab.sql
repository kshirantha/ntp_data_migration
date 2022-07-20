CREATE TABLE dfn_ntp.m22_commission_group
(
    m22_id                         NUMBER (5, 0) NOT NULL,
    m22_description                VARCHAR2 (256 BYTE) NOT NULL,
    m22_institute_id_m02           NUMBER (10, 0),
    m22_additional_details         VARCHAR2 (4000 BYTE),
    m22_exchange_code_m01          VARCHAR2 (10 BYTE),
    m22_currency_m03               CHAR (3 BYTE),
    m22_type                       NUMBER (1, 0) DEFAULT 0,
    m22_commission_category        NUMBER (1, 0) DEFAULT 0,
    m22_is_default                 NUMBER (1, 0) DEFAULT 0,
    m22_created_by_id_u17          NUMBER (20, 0),
    m22_created_date               DATE,
    m22_modified_by_id_u17         NUMBER (20, 0),
    m22_modified_date              DATE,
    m22_status_id_v01              NUMBER (20, 0),
    m22_status_changed_by_id_u17   NUMBER (10, 0),
    m22_status_changed_date        DATE,
    m22_exchange_id_m01            NUMBER (5, 0),
    m22_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    PRIMARY KEY (m22_id)
)
/

ALTER TABLE dfn_ntp.m22_commission_group
ADD CONSTRAINT m22_inst_uk UNIQUE (m22_description, m22_institute_id_m02)
USING INDEX
/

ALTER TABLE dfn_ntp.m22_commission_group
 ADD (
  m22_category_m89 NUMBER (5)
 )
/

COMMENT ON COLUMN dfn_ntp.m22_commission_group.m22_category_m89 IS
    'fk m89_id'
/

ALTER TABLE dfn_ntp.m22_commission_group
 MODIFY (
  m22_category_m89 DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_ntp.m22_commission_group.m22_category_m89 IS
    'fk m89_id | 0 - Default | 1 - Staff'
/

ALTER TABLE dfn_ntp.m22_commission_group
RENAME COLUMN m22_category_m89 TO m22_category_v01
/

COMMENT ON COLUMN dfn_ntp.m22_commission_group.m22_category_v01 IS
    'v01_type = 86 | 0 - Default | 1 - Staff'
/
