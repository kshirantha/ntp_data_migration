-- Foreign Key for  DFN_NTP.U44_UPLOADED_DOCUMENTS


  ALTER TABLE dfn_ntp.u44_uploaded_documents ADD CONSTRAINT u44_upload_doc_m62_id_fk FOREIGN KEY (u44_institute_document_id_m62)
   REFERENCES dfn_ntp.m62_institute_documents (m62_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U44_UPLOADED_DOCUMENTS
