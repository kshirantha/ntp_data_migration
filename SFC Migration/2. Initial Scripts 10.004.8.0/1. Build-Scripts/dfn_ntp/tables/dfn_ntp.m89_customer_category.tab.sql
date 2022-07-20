CREATE TABLE dfn_ntp.m89_customer_category
(
    m89_id                         NUMBER (5, 0) NOT NULL,
    m89_institute_id_m02           NUMBER (3, 0) NOT NULL,
    m89_name                       VARCHAR2 (100 BYTE) NOT NULL,
    m89_name_lang                  VARCHAR2 (100 BYTE) NOT NULL,
    m89_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m89_created_date               TIMESTAMP (6) NOT NULL,
    m89_status_id_v01              NUMBER (5, 0) NOT NULL,
    m89_modified_by_id_u17         NUMBER (10, 0),
    m89_modified_date              TIMESTAMP (6),
    m89_status_changed_by_id_u17   NUMBER (10, 0),
    m89_status_changed_date        TIMESTAMP (6),
    m89_external_ref               VARCHAR2 (20 BYTE),
    m89_additional_details         VARCHAR2 (400 BYTE),
    m89_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    PRIMARY KEY (m89_id)
)
/

ALTER TABLE dfn_ntp.m89_customer_category
ADD CONSTRAINT m89_uk UNIQUE (m89_institute_id_m02, m89_name)
USING INDEX
/

ALTER TABLE dfn_ntp.m89_customer_category
ADD CONSTRAINT fk_m89_institute_id_m02 FOREIGN KEY (m89_institute_id_m02)
REFERENCES dfn_ntp.m02_institute (m02_id)
/
