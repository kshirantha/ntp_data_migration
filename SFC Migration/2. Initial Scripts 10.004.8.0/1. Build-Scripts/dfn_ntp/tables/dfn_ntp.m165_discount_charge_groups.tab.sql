CREATE TABLE dfn_ntp.m165_discount_charge_groups
(
    m165_id                         NUMBER (5, 0) NOT NULL,
    m165_name                       VARCHAR2 (75 BYTE) NOT NULL,
    m165_description                VARCHAR2 (500 BYTE),
    m165_created_date               DATE NOT NULL,
    m165_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m165_status_changed_date        DATE,
    m165_status_changed_by_id_u17   NUMBER (10, 0) NOT NULL,
    m165_modified_date              DATE,
    m165_modified_by_id_u17         NUMBER (10, 0),
    m165_status_id_v01              NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m165_is_default                 NUMBER (2, 0) DEFAULT 0,
    m165_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m165_institute_id_m02           NUMBER (3, 0) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.m165_discount_charge_groups
ADD CONSTRAINT m165_id_pk PRIMARY KEY (m165_id)
USING INDEX
/
