CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u44_uploaded_documents
(
    u44_id,
    u44_institute_document_id_m62,
    document_name,
    u44_owner_id_u01,
    u44_version
)
AS
    SELECT u44.u44_id,
           u44.u44_institute_document_id_m62,
           m61.m61_name AS document_name,
           u44.u44_owner_id_u01,
           u44.u44_version
      FROM u44_uploaded_documents u44
           LEFT JOIN m62_institute_documents m62
               ON u44.u44_institute_document_id_m62 = m62.m62_id
           LEFT JOIN m61_uploadable_documents m61
               ON m62.m62_document_id_m61 = m61.m61_id
/