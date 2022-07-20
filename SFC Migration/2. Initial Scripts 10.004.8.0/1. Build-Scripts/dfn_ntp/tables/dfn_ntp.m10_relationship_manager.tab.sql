CREATE TABLE dfn_ntp.m10_relationship_manager
(
    m10_id                         NUMBER (5, 0) NOT NULL,
    m10_institute_id_m02           NUMBER (3, 0) NOT NULL,
    m10_name                       VARCHAR2 (100 BYTE) NOT NULL,
    m10_name_lang                  VARCHAR2 (100 BYTE),
    m10_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m10_created_date               TIMESTAMP (6) NOT NULL,
    m10_status_id_v01              NUMBER (5, 0) NOT NULL,
    m10_modified_by_id_u17         NUMBER (10, 0),
    m10_modified_date              TIMESTAMP (6),
    m10_status_changed_by_id_u17   NUMBER (10, 0),
    m10_status_changed_date        TIMESTAMP (6),
    m10_external_ref               VARCHAR2 (20 BYTE),
    m10_code                       VARCHAR2 (18 BYTE),
    m10_location_id_m07            NUMBER (18, 0),
    m10_telephone                  VARCHAR2 (20 BYTE),
    m10_fax                        VARCHAR2 (20 BYTE),
    m10_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    PRIMARY KEY (m10_id)
)
/

ALTER TABLE dfn_ntp.m10_relationship_manager
 ADD (
  m10_incentive_group_id_m162 NUMBER (5)
 )
/