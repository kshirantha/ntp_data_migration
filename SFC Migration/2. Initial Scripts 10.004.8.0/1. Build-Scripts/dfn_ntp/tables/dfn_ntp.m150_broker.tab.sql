CREATE TABLE dfn_ntp.m150_broker
(
    m150_id                         NUMBER (5, 0) NOT NULL,
    m150_description                VARCHAR2 (75 BYTE),
    m150_created_by_id_u17          NUMBER (20, 0),
    m150_created_date               DATE,
    m150_modified_by_id_u17         NUMBER (20, 0),
    m150_modified_date              DATE,
    m150_status_id_v01              NUMBER (20, 0),
    m150_status_changed_by_id_u17   NUMBER (20, 0),
    m150_status_changed_date        DATE,
    m150_code                       VARCHAR2 (20 BYTE) DEFAULT NULL NOT NULL,
    m150_custom_type                VARCHAR2 (20 BYTE) DEFAULT 1,
    m150_primary_institute_id_m02   NUMBER (3, 0)
)
/

ALTER TABLE dfn_ntp.m150_broker
    ADD CONSTRAINT m150_pk PRIMARY KEY (m150_id) USING INDEX
/