CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m62_institute_documents
(
    m62_id,
    m62_institute_id_m02,
    m62_document_id_m61,
    document_name,
    m62_document_type_id_v28,
    m62_is_mandatory,
    m62_created_by_id_u17,
    created_by_full_name,
    m62_created_date,
    m62_modified_by_id_u17,
    modified_by_full_name,
    m62_modified_date,
    m62_status_id_v01,
    status_description,
    status_description_lang
)
AS
    (SELECT m62.m62_id,
            m62.m62_institute_id_m02,
            m62.m62_document_id_m61,
            m61.m61_name AS document_name,
            m62.m62_document_type_id_v28,
            m62.m62_is_mandatory,
            m62.m62_created_by_id_u17,
            u17_created_by.u17_full_name AS created_by_full_name,
            m62.m62_created_date,
            m62.m62_modified_by_id_u17,
            u17_modified_by.u17_full_name AS modified_by_full_name,
            m62.m62_modified_date,
            m62.m62_status_id_v01,
            status_list.v01_description AS status_description,
            status_list.v01_description_lang AS status_description_lang
       FROM m62_institute_documents m62
            LEFT JOIN u17_employee u17_created_by
                ON m62.m62_created_by_id_u17 = u17_created_by.u17_id
            LEFT JOIN u17_employee u17_modified_by
                ON m62.m62_modified_by_id_u17 = u17_modified_by.u17_id
            LEFT JOIN vw_status_list status_list
                ON m62.m62_status_id_v01 = status_list.v01_id
            LEFT JOIN m61_uploadable_documents m61
                ON m62.m62_document_id_m61 = m61.m61_id);
/
