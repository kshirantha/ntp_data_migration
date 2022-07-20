CREATE TABLE dfn_ntp.m07_location
(
    m07_id                         NUMBER (5, 0) NOT NULL,
    m07_institute_id_m02           NUMBER (3, 0) NOT NULL,
    m07_name                       VARCHAR2 (100 BYTE) NOT NULL,
    m07_name_lang                  VARCHAR2 (100 BYTE),
    m07_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m07_created_date               TIMESTAMP (6) NOT NULL,
    m07_status_id_v01              NUMBER (5, 0) NOT NULL,
    m07_modified_by_id_u17         NUMBER (10, 0),
    m07_modified_date              TIMESTAMP (6),
    m07_status_changed_by_id_u17   NUMBER (10, 0),
    m07_status_changed_date        TIMESTAMP (6),
    m07_external_ref               VARCHAR2 (20 BYTE),
    m07_region_id_m90              NUMBER (10, 0),
    m07_location_code              VARCHAR2 (250 BYTE),
    m07_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    PRIMARY KEY (m07_id)
)
/

ALTER TABLE dfn_ntp.m07_location
ADD CONSTRAINT uk_m07_name UNIQUE (m07_id, m07_institute_id_m02)
USING INDEX
/

ALTER TABLE dfn_ntp.m07_location
 ADD (
  m07_order_value_per_day NUMBER (21, 8),
  m07_order_volume_per_day NUMBER (21, 8)
 )
/

ALTER TABLE dfn_ntp.m07_location
 ADD (
  m07_default_currency_code_m03 VARCHAR2 (255),
  m07_default_currency_id_m03 NUMBER (5)
 )
/