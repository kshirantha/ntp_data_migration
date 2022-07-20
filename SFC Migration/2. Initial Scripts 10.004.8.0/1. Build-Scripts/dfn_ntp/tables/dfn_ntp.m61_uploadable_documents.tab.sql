-- Table DFN_NTP.M61_UPLOADABLE_DOCUMENTS

CREATE TABLE dfn_ntp.m61_uploadable_documents
(
    m61_id                         NUMBER (5, 0),
    m61_name                       VARCHAR2 (75),
    m61_file_name_prefix           VARCHAR2 (20),
    m61_created_by_id_u17          NUMBER (10, 0),
    m61_created_date               DATE,
    m61_modified_by_id_u17         NUMBER (10, 0),
    m61_modified_date              DATE,
    m61_default                    NUMBER (1, 0) DEFAULT 0,
    m61_doc_content_type           NUMBER (2, 0) DEFAULT 1,
    m61_prefered_size              VARCHAR2 (100),
    m61_allow_remove               NUMBER (1, 0) DEFAULT 0,
    m61_status_id_v01              NUMBER (5, 0) DEFAULT 1,
    m61_status_changed_by_id_u17   NUMBER (10, 0),
    m61_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M61_UPLOADABLE_DOCUMENTS


  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_file_name_prefix NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_modified_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_modified_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_default NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_doc_content_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_allow_remove NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m61_uploadable_documents MODIFY (m61_status_id_v01 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M61_UPLOADABLE_DOCUMENTS

COMMENT ON COLUMN dfn_ntp.m61_uploadable_documents.m61_name IS
    'Document display name'
/
COMMENT ON COLUMN dfn_ntp.m61_uploadable_documents.m61_default IS
    '1=yes,0=no: specifiies whther this has to be added when a new institution is created'
/
COMMENT ON COLUMN dfn_ntp.m61_uploadable_documents.m61_doc_content_type IS
    '1=Image,2=PDF,3=Word Doc'
/
COMMENT ON COLUMN dfn_ntp.m61_uploadable_documents.m61_prefered_size IS
    'Applicable only for images. display only no validation of the size'
/
COMMENT ON COLUMN dfn_ntp.m61_uploadable_documents.m61_allow_remove IS
    '1=allow, 0=remove'
/
-- End of DDL Script for Table DFN_NTP.M61_UPLOADABLE_DOCUMENTS

alter table dfn_ntp.M61_UPLOADABLE_DOCUMENTS
	add M61_CUSTOM_TYPE varchar2(50) default 1
/


ALTER TABLE dfn_ntp.m61_uploadable_documents
    MODIFY (m61_modified_by_id_u17 NULL, m61_modified_date NULL)
/