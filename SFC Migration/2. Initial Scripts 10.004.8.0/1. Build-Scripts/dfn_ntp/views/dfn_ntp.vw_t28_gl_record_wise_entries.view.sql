CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t28_gl_record_wise_entries
(
    t28_id,
    t28_batch_id_t27,
    t28_cash_account_id_u06,
    t28_distribution_id_m138,
    t28_txn_ref,
    t28_txn_date,
    t28_settle_date,
    t28_narration,
    t28_narration_lang,
    t28_acc_cat_id_m134,
    t28_currency_code_m03,
    t28_currency_id_m03,
    t28_dr,
    t28_cr,
    customer_no,
    investment_account_no,
    institute_id_m02,
    distribution_external_ref,
    data_sources_external_ref,
    event_category_desc,
    event_category_desc_lang,
    account_category_desc,
    account_category_desc_lang,
    accounts_code,
    accounts_external_ref
)
AS
    SELECT t28.t28_id,
           t28.t28_batch_id_t27,
           t28.t28_cash_account_id_u06,
           t28.t28_distribution_id_m138,
           t28.t28_txn_ref,
           t28.t28_txn_date,
           t28.t28_settle_date,
           t28.t28_narration,
           t28.t28_narration_lang,
           t28.t28_acc_cat_id_m134,
           t28.t28_currency_code_m03,
           t28.t28_currency_id_m03,
           t28.t28_dr,
           t28.t28_cr,
           u06.u06_customer_no_u01 AS customer_no,
           u06.u06_investment_account_no AS investment_account_no,
           u06.u06_institute_id_m02 as institute_id_m02,
           m138.m138_external_ref AS distribution_external_ref,
           m137.m137_external_ref AS data_sources_external_ref,
           m136.m136_description AS event_category_desc,
           m136.m136_description_lang AS event_category_desc_lang,
           m134.m134_description AS account_category_desc,
           m134.m134_description_lang AS account_category_desc_lang,
           m135.m135_code AS accounts_code,
           m135.m135_external_ref AS accounts_external_ref
      FROM t28_gl_record_wise_entries t28
           JOIN t27_gl_batches t27
               ON t28.t28_batch_id_t27 = t27.t27_id
           JOIN m138_gl_record_destribution m138
               ON t28.t28_distribution_id_m138 = m138.m138_id
           JOIN m137_gl_event_data_sources m137
               ON m138.m138_data_source_id_m137 = m137.m137_id
           JOIN m136_gl_event_categories m136
               ON m137.m137_event_cat_id_m136 = m136.m136_id
           JOIN m134_gl_account_categories m134
               ON t28.t28_acc_cat_id_m134 = m134.m134_id
           LEFT JOIN m135_gl_accounts m135
               ON     t28.t28_acc_cat_id_m134 = m135.m135_acc_cat_id_m134
                  AND t28.t28_currency_id_m03 = m135_currency_id_m03
           LEFT JOIN u06_cash_account u06
               ON t28.t28_cash_account_id_u06 = u06.u06_id
/