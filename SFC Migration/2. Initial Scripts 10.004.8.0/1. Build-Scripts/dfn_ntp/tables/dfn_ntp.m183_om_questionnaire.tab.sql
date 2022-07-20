CREATE TABLE dfn_ntp.m183_om_questionnaire
(
    m183_id                         NUMBER (3, 0) NOT NULL,
    m183_product_id_m73             NUMBER (3, 0) NOT NULL,
    m183_description                VARCHAR2 (250 BYTE) NOT NULL,
    m183_description_lang           VARCHAR2 (250 BYTE),
    m183_status_id_v01              NUMBER (5, 0),
    m183_created_by_id_u17          NUMBER (10, 0),
    m183_created_date               DATE,
    m183_status_changed_by_id_u17   NUMBER (10, 0),
    m183_status_changed_date        DATE,
    m183_modified_by_id_u17         NUMBER (10, 0),
    m183_modified_date              DATE,
    m183_custom_type                VARCHAR2 (50 BYTE),
    m183_institute_id_m02           NUMBER (3, 0)
)
/



ALTER TABLE dfn_ntp.m183_om_questionnaire
ADD CONSTRAINT pk_m183_id PRIMARY KEY (m183_id)
USING INDEX
/

ALTER TABLE dfn_ntp.M183_OM_QUESTIONNAIRE 
 MODIFY (
  M183_DESCRIPTION VARCHAR2 (1000 BYTE),
  M183_DESCRIPTION_LANG VARCHAR2 (1000 BYTE)

 )
/
