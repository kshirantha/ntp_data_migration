CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u45_uploaded_doc_pages
(
    u45_id,
    u45_file_name,
    u45_local_file_name,
    u45_sequence,
    u45_upload_doc_id_u44,
    u45_uploaded_by_id_u17,
    uploaded_by,
    u45_uploaded_date,
    m61_doc_content_type,
    doc_content_type,
    max_file_size,
    u44_id,
    u44_institute_document_id_m62,
    u44_owner_id_u01
)
AS
    SELECT u45.u45_id,
           u45.u45_file_name,
           u45.u45_local_file_name,
           u45.u45_sequence,
           u45.u45_upload_doc_id_u44,
           u45.u45_uploaded_by_id_u17,
           u17_uploaded_by.u17_full_name AS uploaded_by,
           u45.u45_uploaded_date,
           m61.m61_doc_content_type,
           CASE
               WHEN m61.m61_doc_content_type = 1 THEN 'fa fa-file-image-o'
               WHEN m61.m61_doc_content_type = 2 THEN 'fa fa-file-pdf-o'
               WHEN m61.m61_doc_content_type = 3 THEN 'fa fa-file-text-o'
           END
               AS doc_content_type,
           m61.m61_prefered_size AS max_file_size,
           u44_id,
           u44_institute_document_id_m62,
           u44_owner_id_u01
      FROM u45_uploaded_doc_pages u45
           LEFT JOIN u44_uploaded_documents u44
               ON u45.u45_upload_doc_id_u44 = u44.u44_id
           LEFT JOIN m62_institute_documents m62
               ON u44.u44_institute_document_id_m62 = m62.m62_id
           LEFT JOIN m61_uploadable_documents m61
               ON m62.m62_document_id_m61 = m61.m61_id
           LEFT JOIN u17_employee u17_uploaded_by
               ON u45.u45_uploaded_by_id_u17 = u17_uploaded_by.u17_id
/