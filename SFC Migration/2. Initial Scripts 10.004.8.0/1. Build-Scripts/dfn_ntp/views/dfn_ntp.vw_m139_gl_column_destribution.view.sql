CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m139_gl_column_destribution
(
    m139_id,
    m139_data_source_id_m137,
    m139_narration_expression,
    m139_narration_expression_lang,
    m139_enabled,
    m139_dr_1_expression,
    m139_dr_1_acc_cat_id_m134,
    m139_dr_2_expression,
    m139_dr_2_acc_cat_id_m134,
    m139_dr_3_expression,
    m139_dr_3_acc_cat_id_m134,
    m139_dr_4_expression,
    m139_dr_4_acc_cat_id_m134,
    m139_dr_5_expression,
    m139_dr_5_acc_cat_id_m134,
    m139_cr_1_expression,
    m139_cr_1_acc_cat_id_m134,
    m139_cr_2_expression,
    m139_cr_2_acc_cat_id_m134,
    m139_cr_3_expression,
    m139_cr_3_acc_cat_id_m134,
    m139_cr_4_expression,
    m139_cr_4_acc_cat_id_m134,
    m139_cr_5_expression,
    m139_cr_5_acc_cat_id_m134,
    m139_modified_by_id_u17,
    m139_modified_date,
    event_data_source_desc,
    enabled_desc,
    modified_by_full_name,
    dr_1_acc_category_desc,
    dr_1_acc_category_desc_lang,
    dr_2_acc_category_desc,
    dr_2_acc_category_desc_lang,
    dr_3_acc_category_desc,
    dr_3_acc_category_desc_lang,
    dr_4_acc_category_desc,
    dr_4_acc_category_desc_lang,
    dr_5_acc_category_desc,
    dr_5_acc_category_desc_lang,
    cr_1_acc_category_desc,
    cr_1_acc_category_desc_lang,
    cr_2_acc_category_desc,
    cr_2_acc_category_desc_lang,
    cr_3_acc_category_desc,
    cr_3_acc_category_desc_lang,
    cr_4_acc_category_desc,
    cr_4_acc_category_desc_lang,
    cr_5_acc_category_desc,
    cr_5_acc_category_desc_lang,
    m139_external_ref,
    m139_dr_1_acc_ref,
    m139_dr_2_acc_ref,
    m139_dr_3_acc_ref,
    m139_dr_4_acc_ref,
    m139_dr_5_acc_ref,
    m139_cr_1_acc_ref,
    m139_cr_2_acc_ref,
    m139_cr_3_acc_ref,
    m139_cr_4_acc_ref,
    m139_cr_5_acc_ref
)
AS
    SELECT m139.m139_id,
           m139.m139_data_source_id_m137,
           m139.m139_narration_expression,
           m139.m139_narration_expression_lang,
           m139.m139_enabled,
           m139.m139_dr_1_expression,
           m139.m139_dr_1_acc_cat_id_m134,
           m139.m139_dr_2_expression,
           m139.m139_dr_2_acc_cat_id_m134,
           m139.m139_dr_3_expression,
           m139.m139_dr_3_acc_cat_id_m134,
           m139.m139_dr_4_expression,
           m139.m139_dr_4_acc_cat_id_m134,
           m139.m139_dr_5_expression,
           m139.m139_dr_5_acc_cat_id_m134,
           m139.m139_cr_1_expression,
           m139.m139_cr_1_acc_cat_id_m134,
           m139.m139_cr_2_expression,
           m139.m139_cr_2_acc_cat_id_m134,
           m139.m139_cr_3_expression,
           m139.m139_cr_3_acc_cat_id_m134,
           m139.m139_cr_4_expression,
           m139.m139_cr_4_acc_cat_id_m134,
           m139.m139_cr_5_expression,
           m139.m139_cr_5_acc_cat_id_m134,
           m139.m139_modified_by_id_u17,
           m139.m139_modified_date,
           m137.m137_description AS event_data_source_desc,
           CASE m139.m139_enabled WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS enabled_desc,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m134_dr_1_acc_cat.m134_description AS dr_1_acc_category_desc,
           m134_dr_1_acc_cat.m134_description_lang
               AS dr_1_acc_category_desc_lang,
           m134_dr_2_acc_cat.m134_description AS dr_2_acc_category_desc,
           m134_dr_2_acc_cat.m134_description_lang
               AS dr_2_acc_category_desc_lang,
           m134_dr_3_acc_cat.m134_description AS dr_3_acc_category_desc,
           m134_dr_3_acc_cat.m134_description_lang
               AS dr_3_acc_category_desc_lang,
           m134_dr_4_acc_cat.m134_description AS dr_4_acc_category_desc,
           m134_dr_4_acc_cat.m134_description_lang
               AS dr_4_acc_category_desc_lang,
           m134_dr_5_acc_cat.m134_description AS dr_5_acc_category_desc,
           m134_dr_5_acc_cat.m134_description_lang
               AS dr_5_acc_category_desc_lang,
           m134_cr_1_acc_cat.m134_description AS cr_1_acc_category_desc,
           m134_cr_1_acc_cat.m134_description_lang
               AS cr_1_acc_category_desc_lang,
           m134_cr_2_acc_cat.m134_description AS cr_2_acc_category_desc,
           m134_cr_2_acc_cat.m134_description_lang
               AS cr_2_acc_category_desc_lang,
           m134_cr_3_acc_cat.m134_description AS cr_3_acc_category_desc,
           m134_cr_3_acc_cat.m134_description_lang
               AS cr_3_acc_category_desc_lang,
           m134_cr_4_acc_cat.m134_description AS cr_4_acc_category_desc,
           m134_cr_4_acc_cat.m134_description_lang
               AS cr_4_acc_category_desc_lang,
           m134_cr_5_acc_cat.m134_description AS cr_5_acc_category_desc,
           m134_cr_5_acc_cat.m134_description_lang
               AS cr_5_acc_category_desc_lang,
           m139.m139_external_ref,
           m139.m139_dr_1_acc_ref,
           m139.m139_dr_2_acc_ref,
           m139.m139_dr_3_acc_ref,
           m139.m139_dr_4_acc_ref,
           m139.m139_dr_5_acc_ref,
           m139.m139_cr_1_acc_ref,
           m139.m139_cr_2_acc_ref,
           m139.m139_cr_3_acc_ref,
           m139.m139_cr_4_acc_ref,
           m139.m139_cr_5_acc_ref
      FROM m139_gl_column_destribution m139
           JOIN m137_gl_event_data_sources m137
               ON m139.m139_data_source_id_m137 = m137.m137_id
           LEFT JOIN u17_employee u17_modified_by
               ON m139.m139_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN m134_gl_account_categories m134_dr_1_acc_cat
               ON m139.m139_dr_1_acc_cat_id_m134 = m134_dr_1_acc_cat.m134_id
           LEFT JOIN m134_gl_account_categories m134_dr_2_acc_cat
               ON m139.m139_dr_2_acc_cat_id_m134 = m134_dr_2_acc_cat.m134_id
           LEFT JOIN m134_gl_account_categories m134_dr_3_acc_cat
               ON m139.m139_dr_3_acc_cat_id_m134 = m134_dr_3_acc_cat.m134_id
           LEFT JOIN m134_gl_account_categories m134_dr_4_acc_cat
               ON m139.m139_dr_4_acc_cat_id_m134 = m134_dr_4_acc_cat.m134_id
           LEFT JOIN m134_gl_account_categories m134_dr_5_acc_cat
               ON m139.m139_dr_5_acc_cat_id_m134 = m134_dr_5_acc_cat.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr_1_acc_cat
               ON m139.m139_cr_1_acc_cat_id_m134 = m134_cr_1_acc_cat.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr_2_acc_cat
               ON m139.m139_cr_2_acc_cat_id_m134 = m134_cr_2_acc_cat.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr_3_acc_cat
               ON m139.m139_cr_3_acc_cat_id_m134 = m134_cr_3_acc_cat.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr_4_acc_cat
               ON m139.m139_cr_4_acc_cat_id_m134 = m134_cr_4_acc_cat.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr_5_acc_cat
               ON m139.m139_cr_5_acc_cat_id_m134 = m134_cr_5_acc_cat.m134_id
/
