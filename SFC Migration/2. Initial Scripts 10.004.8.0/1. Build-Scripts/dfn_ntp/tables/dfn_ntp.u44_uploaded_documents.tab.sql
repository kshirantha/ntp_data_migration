-- Table DFN_NTP.U44_UPLOADED_DOCUMENTS

CREATE TABLE dfn_ntp.u44_uploaded_documents
(
    u44_id                          NUMBER (10, 0) DEFAULT NULL,
    u44_institute_document_id_m62   NUMBER (10, 0) DEFAULT NULL,
    u44_version                     NUMBER (5, 0) DEFAULT 0,
    u44_owner_id_u01                NUMBER (10, 0) DEFAULT NULL,
    u44_file_availability           NUMBER (1, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.U44_UPLOADED_DOCUMENTS


  ALTER TABLE dfn_ntp.u44_uploaded_documents ADD CONSTRAINT uk_u44_uploaded_documents PRIMARY KEY (u44_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.u44_uploaded_documents MODIFY (u44_institute_document_id_m62 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u44_uploaded_documents MODIFY (u44_version NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u44_uploaded_documents MODIFY (u44_owner_id_u01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u44_uploaded_documents MODIFY (u44_file_availability NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.U44_UPLOADED_DOCUMENTS

alter table dfn_ntp.U44_UPLOADED_DOCUMENTS
	add U44_CUSTOM_TYPE varchar2(50) default 1
/
