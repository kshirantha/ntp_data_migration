CREATE TABLE dfn_ntp.m35_customer_settl_group
(
    m35_id                         NUMBER (18, 0) NOT NULL,
    m35_description                VARCHAR2 (50 BYTE) NOT NULL,
    m35_description_lang           VARCHAR2 (50 BYTE),
    m35_status_id_v01              NUMBER (15, 0),
    m35_created_by_id_u17          NUMBER (5, 0),
    m35_created_date               DATE,
    m35_modified_by_id_u17         NUMBER (10, 0),
    m35_modified_date              DATE,
    m35_status_changed_by_id_u17   NUMBER (10, 0),
    m35_additional_details         VARCHAR2 (100 BYTE),
    m35_status_changed_date        DATE,
    m35_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m35_institute_id_m02           NUMBER (5, 0),
    m35_is_default                 NUMBER (1, 0) DEFAULT 0
)
/