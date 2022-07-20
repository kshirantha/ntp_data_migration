CREATE TABLE dfn_ntp.m134_gl_account_categories
(
    m134_id                         NUMBER (5, 0) NOT NULL,
    m134_description                VARCHAR2 (75 BYTE) NOT NULL,
    m134_description_lang           VARCHAR2 (75 BYTE),
    m134_account_type_id_m133       NUMBER (3, 0) NOT NULL,
    m134_institute_id_m02           NUMBER (5, 0) NOT NULL,
    m134_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m134_created_date               DATE NOT NULL,
    m134_modified_by_id_u17         NUMBER (10, 0),
    m134_modified_date              DATE,
    m134_status_id_v01              NUMBER (5, 0) NOT NULL,
    m134_status_changed_by_id_u17   NUMBER (10, 0),
    m134_status_changed_date        DATE,
    m134_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m134_gl_account_categories
    ADD CONSTRAINT pk_m134 PRIMARY KEY (m134_id) USING INDEX
/


COMMENT ON COLUMN dfn_ntp.m134_gl_account_categories.m134_institute_id_m02 IS
    'Primary Institution'
/
