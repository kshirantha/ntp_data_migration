-- Table DFN_NTP.M62_INSTITUTE_DOCUMENTS

CREATE TABLE dfn_ntp.m62_institute_documents
(
    m62_id                     NUMBER (10, 0),
    m62_institute_id_m02       NUMBER (10, 0),
    m62_document_id_m61        NUMBER (5, 0),
    m62_document_type_id_v28   NUMBER (2, 0) DEFAULT 1,
    m62_is_mandatory           NUMBER (1, 0) DEFAULT 0,
    m62_created_by_id_u17      NUMBER (10, 0),
    m62_created_date           DATE,
    m62_modified_by_id_u17     NUMBER (10, 0),
    m62_modified_date          DATE,
    m62_status_id_v01          NUMBER (1, 0) DEFAULT 1
)
/

-- Constraints for  DFN_NTP.M62_INSTITUTE_DOCUMENTS


  ALTER TABLE dfn_ntp.m62_institute_documents ADD CONSTRAINT m62_id_pk PRIMARY KEY (m62_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m62_institute_documents MODIFY (m62_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m62_institute_documents MODIFY (m62_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m62_institute_documents MODIFY (m62_document_id_m61 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m62_institute_documents MODIFY (m62_document_type_id_v28 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m62_institute_documents MODIFY (m62_is_mandatory NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m62_institute_documents MODIFY (m62_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m62_institute_documents MODIFY (m62_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m62_institute_documents MODIFY (m62_status_id_v01 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M62_INSTITUTE_DOCUMENTS

alter table dfn_ntp.M62_INSTITUTE_DOCUMENTS
	add M62_CUSTOM_TYPE varchar2(50) default 1
/