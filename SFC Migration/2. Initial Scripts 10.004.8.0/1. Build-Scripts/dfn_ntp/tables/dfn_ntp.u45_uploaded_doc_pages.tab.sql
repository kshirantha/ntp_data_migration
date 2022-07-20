-- Table DFN_NTP.U45_UPLOADED_DOC_PAGES

CREATE TABLE dfn_ntp.u45_uploaded_doc_pages
(
    u45_id                   NUMBER (10, 0),
    u45_upload_doc_id_u44    NUMBER (10, 0),
    u45_file_name            VARCHAR2 (255),
    u45_local_file_name      VARCHAR2 (255),
    u45_sequence             NUMBER (3, 0) DEFAULT 1,
    u45_uploaded_by_id_u17   NUMBER (10, 0),
    u45_uploaded_date        DATE
)
/

-- Constraints for  DFN_NTP.U45_UPLOADED_DOC_PAGES


  ALTER TABLE dfn_ntp.u45_uploaded_doc_pages MODIFY (u45_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u45_uploaded_doc_pages MODIFY (u45_upload_doc_id_u44 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u45_uploaded_doc_pages MODIFY (u45_file_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u45_uploaded_doc_pages MODIFY (u45_sequence NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u45_uploaded_doc_pages MODIFY (u45_uploaded_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u45_uploaded_doc_pages MODIFY (u45_uploaded_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u45_uploaded_doc_pages ADD CONSTRAINT pk_u45_uploaded_doc_pages PRIMARY KEY (u45_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.U45_UPLOADED_DOC_PAGES

COMMENT ON COLUMN dfn_ntp.u45_uploaded_doc_pages.u45_file_name IS
    'Physical file name in disk'
/
COMMENT ON COLUMN dfn_ntp.u45_uploaded_doc_pages.u45_local_file_name IS
    'Orginal name of the file uploaded by the customer.'
/
-- End of DDL Script for Table DFN_NTP.U45_UPLOADED_DOC_PAGES

alter table dfn_ntp.U45_UPLOADED_DOC_PAGES
	add U45_CUSTOM_TYPE varchar2(50) default 1
/
