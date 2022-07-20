CREATE TABLE dfn_ntp.z09_export_templates
(
    z09_id                   NUMBER (18, 0) NOT NULL,
    z09_form_id_z01          VARCHAR2 (200 BYTE),
    z09_title                VARCHAR2 (200 BYTE),
    z09_created_by_id_u17    NUMBER (10, 0),
    z09_created_date         DATE,
    z09_modified_by_id_u17   NUMBER (10, 0),
    z09_modified_date        DATE,
    z09_details              VARCHAR2 (4000 BYTE),
    z09_custom_type          VARCHAR2 (50 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.z09_export_templates
ADD CONSTRAINT z09_id_pk PRIMARY KEY (z09_id)
USING INDEX
/

COMMENT ON TABLE dfn_ntp.z09_export_templates IS 'export templates'
/
COMMENT ON COLUMN dfn_ntp.z09_export_templates.z09_created_by_id_u17 IS
    'Created by'
/
COMMENT ON COLUMN dfn_ntp.z09_export_templates.z09_created_date IS
    'Created Date'
/
COMMENT ON COLUMN dfn_ntp.z09_export_templates.z09_details IS
    'Export Details'
/
COMMENT ON COLUMN dfn_ntp.z09_export_templates.z09_form_id_z01 IS 'Form ID'
/
COMMENT ON COLUMN dfn_ntp.z09_export_templates.z09_id IS 'Primary Key'
/
COMMENT ON COLUMN dfn_ntp.z09_export_templates.z09_modified_by_id_u17 IS
    'Modified by'
/
COMMENT ON COLUMN dfn_ntp.z09_export_templates.z09_modified_date IS 'Date'
/
COMMENT ON COLUMN dfn_ntp.z09_export_templates.z09_title IS 'Title'
/

ALTER TABLE dfn_ntp.z09_export_templates
 ADD (
  z09_export_type NUMBER (1)
 )
/
COMMENT ON COLUMN dfn_ntp.z09_export_templates.z09_export_type IS
    'CSV = 1, EXCEL = 2'
/