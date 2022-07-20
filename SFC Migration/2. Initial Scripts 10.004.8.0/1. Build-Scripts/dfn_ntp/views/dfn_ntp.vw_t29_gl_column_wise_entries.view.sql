CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t29_gl_column_wise_entries
(
    t29_id,
    t29_batch_id_t27,
    t29_cash_account_id_u06,
    t29_distribution_id_m139,
    t29_txn_ref,
    t29_txn_date,
    t29_settle_date,
    t29_narration,
    t29_narration_lang,
    t29_currency_code_m03,
    t29_currency_id_m03,
    t29_dr1_acc_cat_id_m134,
    t29_dr1,
    t29_dr2_acc_cat_id_m134,
    t29_dr2,
    t29_dr3_acc_cat_id_m134,
    t29_dr3,
    t29_dr4_acc_cat_id_m134,
    t29_dr4,
    t29_dr5_acc_cat_id_m134,
    t29_dr5,
    t29_cr1_acc_cat_id_m134,
    t29_cr1,
    t29_cr2_acc_cat_id_m134,
    t29_cr2,
    t29_cr3_acc_cat_id_m134,
    t29_cr3,
    t29_cr4_acc_cat_id_m134,
    t29_cr4,
    t29_cr5_acc_cat_id_m134,
    t29_cr5,
    customer_no,
    investment_account_no,
    institute_id_m02,
    distribution_external_ref,
    data_sources_external_ref,
    event_category_desc,
    event_category_desc_lang,
    dr1_account_category_desc,
    dr1_account_category_desc_lang,
    dr2_account_category_desc,
    dr2_account_category_desc_lang,
    dr3_account_category_desc,
    dr3_account_category_desc_lang,
    dr4_account_category_desc,
    dr4_account_category_desc_lang,
    dr5_account_category_desc,
    dr5_account_category_desc_lang,
    cr1_account_category_desc,
    cr1_account_category_desc_lang,
    cr2_account_category_desc,
    cr2_account_category_desc_lang,
    cr3_account_category_desc,
    cr3_account_category_desc_lang,
    cr4_account_category_desc,
    cr4_account_category_desc_lang,
    cr5_account_category_desc,
    cr5_account_category_desc_lang
)
AS
    SELECT t29.t29_id,
           t29.t29_batch_id_t27,
           t29.t29_cash_account_id_u06,
           t29.t29_distribution_id_m139,
           t29.t29_txn_ref,
           t29.t29_txn_date,
           t29.t29_settle_date,
           t29.t29_narration,
           t29.t29_narration_lang,
           t29.t29_currency_code_m03,
           t29.t29_currency_id_m03,
           t29.t29_dr1_acc_cat_id_m134,
           t29.t29_dr1,
           t29.t29_dr2_acc_cat_id_m134,
           t29.t29_dr2,
           t29.t29_dr3_acc_cat_id_m134,
           t29.t29_dr3,
           t29.t29_dr4_acc_cat_id_m134,
           t29.t29_dr4,
           t29.t29_dr5_acc_cat_id_m134,
           t29.t29_dr5,
           t29.t29_cr1_acc_cat_id_m134,
           t29.t29_cr1,
           t29.t29_cr2_acc_cat_id_m134,
           t29.t29_cr2,
           t29.t29_cr3_acc_cat_id_m134,
           t29.t29_cr3,
           t29.t29_cr4_acc_cat_id_m134,
           t29.t29_cr4,
           t29.t29_cr5_acc_cat_id_m134,
           t29.t29_cr5,
           u06.u06_customer_no_u01 AS customer_no,
           u06.u06_investment_account_no AS investment_account_no,
           u06.u06_institute_id_m02 AS institute_id_m02,
           m139.m139_external_ref AS distribution_external_ref,
           m137.m137_external_ref AS data_sources_external_ref,
           m136.m136_description AS event_category_desc,
           m136.m136_description_lang AS event_category_desc_lang,
           NVL (m134_dr1.m134_description, t29.t29_dr_1_acc_ref)
               AS dr1_account_category_desc,
           NVL (m134_dr1.m134_description_lang, t29.t29_dr_1_acc_ref)
               AS dr1_account_category_desc_lang,
           NVL (m134_dr2.m134_description, t29.t29_dr_2_acc_ref)
               AS dr2_account_category_desc,
           NVL (m134_dr2.m134_description_lang, t29.t29_dr_2_acc_ref)
               AS dr2_account_category_desc_lang,
           NVL (m134_dr3.m134_description, t29.t29_dr_3_acc_ref)
               AS dr3_account_category_desc,
           NVL (m134_dr3.m134_description_lang, t29.t29_dr_3_acc_ref)
               AS dr3_account_category_desc_lang,
           NVL (m134_dr4.m134_description, t29.t29_dr_4_acc_ref)
               AS dr4_account_category_desc,
           NVL (m134_dr4.m134_description_lang, t29.t29_dr_4_acc_ref)
               AS dr4_account_category_desc_lang,
           NVL (m134_dr5.m134_description, t29.t29_dr_5_acc_ref)
               AS dr5_account_category_desc,
           NVL (m134_dr5.m134_description_lang, t29.t29_dr_5_acc_ref)
               AS dr5_account_category_desc_lang,
           NVL (m134_cr1.m134_description, t29.t29_cr_1_acc_ref)
               AS cr1_account_category_desc,
           NVL (m134_cr1.m134_description_lang, t29.t29_cr_1_acc_ref)
               AS cr1_account_category_desc_lang,
           NVL (m134_cr2.m134_description, t29.t29_cr_2_acc_ref)
               AS cr2_account_category_desc,
           NVL (m134_cr2.m134_description_lang, t29.t29_cr_2_acc_ref)
               AS cr2_account_category_desc_lang,
           NVL (m134_cr3.m134_description, t29.t29_cr_3_acc_ref)
               AS cr3_account_category_desc,
           NVL (m134_cr3.m134_description_lang, t29.t29_cr_3_acc_ref)
               AS cr3_account_category_desc_lang,
           NVL (m134_cr4.m134_description, t29.t29_cr_4_acc_ref)
               AS cr4_account_category_desc,
           NVL (m134_cr4.m134_description_lang, t29.t29_cr_4_acc_ref)
               AS cr4_account_category_desc_lang,
           NVL (m134_cr5.m134_description, t29.t29_cr_5_acc_ref)
               AS cr5_account_category_desc,
           NVL (m134_cr5.m134_description_lang, t29.t29_cr_5_acc_ref)
               AS cr5_account_category_desc_lang
      FROM t29_gl_column_wise_entries t29
           JOIN t27_gl_batches t27
               ON t29.t29_batch_id_t27 = t27.t27_id
           JOIN m139_gl_column_destribution m139
               ON t29.t29_distribution_id_m139 = m139.m139_id
           JOIN m137_gl_event_data_sources m137
               ON m139.m139_data_source_id_m137 = m137.m137_id
           JOIN m136_gl_event_categories m136
               ON m137.m137_event_cat_id_m136 = m136.m136_id
           LEFT JOIN u06_cash_account u06
               ON t29.t29_cash_account_id_u06 = u06.u06_id
           LEFT JOIN m134_gl_account_categories m134_dr1
               ON t29.t29_dr1_acc_cat_id_m134 = m134_dr1.m134_id
           LEFT JOIN m134_gl_account_categories m134_dr2
               ON t29.t29_dr2_acc_cat_id_m134 = m134_dr2.m134_id
           LEFT JOIN m134_gl_account_categories m134_dr3
               ON t29.t29_dr3_acc_cat_id_m134 = m134_dr3.m134_id
           LEFT JOIN m134_gl_account_categories m134_dr4
               ON t29.t29_dr4_acc_cat_id_m134 = m134_dr4.m134_id
           LEFT JOIN m134_gl_account_categories m134_dr5
               ON t29.t29_dr5_acc_cat_id_m134 = m134_dr5.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr1
               ON t29.t29_cr1_acc_cat_id_m134 = m134_cr1.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr2
               ON t29.t29_cr2_acc_cat_id_m134 = m134_cr2.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr3
               ON t29.t29_cr3_acc_cat_id_m134 = m134_cr3.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr4
               ON t29.t29_cr4_acc_cat_id_m134 = m134_cr4.m134_id
           LEFT JOIN m134_gl_account_categories m134_cr5
               ON t29.t29_cr5_acc_cat_id_m134 = m134_cr5.m134_id
/