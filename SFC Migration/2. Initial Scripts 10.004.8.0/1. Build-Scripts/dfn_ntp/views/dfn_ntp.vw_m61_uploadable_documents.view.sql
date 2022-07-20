CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m61_uploadable_documents
(
    m61_id,
    m61_name,
    m61_file_name_prefix,
    m61_doc_content_type,
    m61_prefered_size,
    enabled,
    is_mandatory,
    m61_default,
    m61_allow_remove,
    m61_created_date,
    m61_modified_by_id_u17,
    m61_modified_date,
    m61_created_by_id_u17,
    m61_status_id_v01,
    status_description,
    status_description_lang,
    m61_status_changed_by_id_u17,
    m61_status_changed_date,
    is_default,
    is_allow_remove,
    doc_content_type,
    created_by_name,
    modified_by_name,
    status_changed_by_name
)
AS
    SELECT m61.m61_id,
           m61.m61_name,
           m61.m61_file_name_prefix,
           m61.m61_doc_content_type,
           m61.m61_prefered_size,
           0 AS enabled,
           0 AS is_mandatory,
           m61.m61_default,
           m61.m61_allow_remove,
           m61.m61_created_date,
           m61.m61_modified_by_id_u17,
           m61.m61_modified_date,
           m61.m61_created_by_id_u17,
           m61.m61_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m61.m61_status_changed_by_id_u17,
           m61.m61_status_changed_date,
           CASE
               WHEN m61.m61_default = 0 THEN 'No'
               WHEN m61.m61_default = 1 THEN 'Yes'
           END
               AS is_default,
           CASE
               WHEN m61.m61_allow_remove = 0 THEN 'No'
               WHEN m61.m61_allow_remove = 1 THEN 'Yes'
           END
               AS is_allow_remove,
           CASE
               WHEN m61.m61_doc_content_type = 1 THEN 'Image'
               WHEN m61.m61_doc_content_type = 2 THEN 'PDF'
               WHEN m61.m61_doc_content_type = 3 THEN 'Word Doc'
           END
               AS doc_content_type,
           u17_created_by.u17_full_name AS created_by_name,
           u17_modified_by.u17_full_name AS modified_by_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_name
      FROM m61_uploadable_documents m61
           LEFT JOIN u17_employee u17_created_by
               ON m61.m61_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m61.m61_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m61.m61_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m61.m61_status_id_v01 = status_list.v01_id
/