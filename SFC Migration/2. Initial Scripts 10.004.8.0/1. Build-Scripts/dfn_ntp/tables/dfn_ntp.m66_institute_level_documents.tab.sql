CREATE TABLE dfn_ntp.m66_institute_level_documents
(
    m66_id                        NUMBER (10, 0) NOT NULL,
    m66_institute_id_m02          NUMBER (10, 0) NOT NULL,
    m66_type                      NUMBER (2, 0) NOT NULL,
    m66_document_name             VARCHAR2 (250 BYTE),
    m66_document                  BLOB,
    m66_last_uploaded_by_id_u17   NUMBER (10, 0),
    m66_last_uploaded_date        DATE,
    m66_custom_type               VARCHAR2 (50 BYTE) DEFAULT 1
)
/



COMMENT ON COLUMN dfn_ntp.m66_institute_level_documents.m66_institute_id_m02 IS
    'fk from m02'
/
COMMENT ON COLUMN dfn_ntp.m66_institute_level_documents.m66_last_uploaded_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m66_institute_level_documents.m66_type IS
    '1 - SIMAH'
/