CREATE TABLE dfn_ntp.m162_incentive_group
(
    m162_id                         NUMBER (5, 0) NOT NULL,
    m162_description                VARCHAR2 (256 BYTE) NOT NULL,
    m162_institute_id_m02           NUMBER (10, 0),
    m162_is_default                 NUMBER (1, 0),
    m162_created_by_id_u17          NUMBER (20, 0),
    m162_created_date               DATE,
    m162_modified_by_id_u17         NUMBER (20, 0),
    m162_modified_date              DATE,
    m162_status_id_v01              NUMBER (20, 0),
    m162_status_changed_by_id_u17   NUMBER (10, 0),
    m162_status_changed_date        DATE,
    m162_custom_type                VARCHAR2 (50 BYTE),
    m162_additional_details         VARCHAR2 (300 BYTE),
    m162_group_type_id_v01          NUMBER (1, 0),
    m162_frequency_id_v01           NUMBER (1, 0),
    m162_commission_type_id_v01     NUMBER (1, 0)
)
/