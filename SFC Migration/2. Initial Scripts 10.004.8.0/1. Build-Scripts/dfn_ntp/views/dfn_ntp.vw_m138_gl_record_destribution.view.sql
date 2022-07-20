CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m138_gl_record_destribution
(
    m138_id,
    m138_data_source_id_m137,
    m138_acc_cat_id_m134,
    m138_narration_expression,
    m138_narration_expression_lang,
    m138_enabled,
    m138_dr_expression,
    m138_cr_expression,
    m138_external_ref,
    m138_modified_by_id_u17,
    m138_modified_date,
    event_data_source_desc,
    acc_category_desc,
    acc_category_desc_lang,
    enabled_desc,
    modified_by_full_name,
    m138_acc_ref
)
AS
    SELECT m138.m138_id,
           m138.m138_data_source_id_m137,
           m138.m138_acc_cat_id_m134,
           m138.m138_narration_expression,
           m138.m138_narration_expression_lang,
           m138.m138_enabled,
           m138.m138_dr_expression,
           m138.m138_cr_expression,
           m138.m138_external_ref,
           m138.m138_modified_by_id_u17,
           m138.m138_modified_date,
           m137.m137_description AS event_data_source_desc,
           m134.m134_description AS acc_category_desc,
           m134.m134_description_lang AS acc_category_desc_lang,
           CASE m138.m138_enabled WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS enabled_desc,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m138.m138_acc_ref
      FROM m138_gl_record_destribution m138
           JOIN m137_gl_event_data_sources m137
               ON m138.m138_data_source_id_m137 = m137.m137_id
           JOIN m134_gl_account_categories m134
               ON m138.m138_acc_cat_id_m134 = m134.m134_id
           LEFT JOIN u17_employee u17_modified_by
               ON m138.m138_modified_by_id_u17 = u17_modified_by.u17_id
/
