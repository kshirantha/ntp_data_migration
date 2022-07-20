-- Foreign Key for  DFN_NTP.U45_UPLOADED_DOC_PAGES


  ALTER TABLE dfn_ntp.u45_uploaded_doc_pages ADD CONSTRAINT u45_upload_doc_pages_u44_id_fk FOREIGN KEY (u45_upload_doc_id_u44)
   REFERENCES dfn_ntp.u44_uploaded_documents (u44_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U45_UPLOADED_DOC_PAGES
