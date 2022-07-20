CREATE OR REPLACE PROCEDURE dfn_ntp.sp_gl_get_record_name_val (
    pt27_id                        IN     t27_gl_batches.t27_id%TYPE,
    pm137_view_name                IN     m137_gl_event_data_sources.m137_view_name%TYPE,
    pm137_cutoff_enabled           IN     m137_gl_event_data_sources.m137_cutoff_enabled%TYPE,
    pm137_filter                   IN     VARCHAR2,
    pm137_external_ref             IN     m137_gl_event_data_sources.m137_external_ref%TYPE,
    pm138_id                       IN     m138_gl_record_destribution.m138_id%TYPE,
    pm138_external_ref             IN     m138_gl_record_destribution.m138_external_ref%TYPE,
    pm138_narration_expression     IN     m138_gl_record_destribution.m138_narration_expression%TYPE,
    pm138_narration_expression_l   IN     m138_gl_record_destribution.m138_narration_expression_lang%TYPE,
    pm138_dr_expression            IN     m138_gl_record_destribution.m138_dr_expression%TYPE,
    pm138_cr_expression            IN     m138_gl_record_destribution.m138_cr_expression%TYPE,
    pm138_acc_cat_id_m134          IN     m138_gl_record_destribution.m138_acc_cat_id_m134%TYPE,
    pm138_acc_ref                  IN     m138_gl_record_destribution.m138_acc_ref%TYPE,
    pname_columns                     OUT VARCHAR2,
    pvalue_columns                    OUT VARCHAR2)
IS
    l_table_name                    VARCHAR2 (30) := 'T28_GL_RECORD_WISE_ENTRIES';
    l_owner                         VARCHAR2 (30) := 'DFN_NTP';
    l_m138_narration_expression     m138_gl_record_destribution.m138_narration_expression%TYPE;
    l_m138_narration_expression_l   m138_gl_record_destribution.m138_narration_expression_lang%TYPE;
    l_m138_dr_expression            m138_gl_record_destribution.m138_dr_expression%TYPE;
    l_m138_cr_expression            m138_gl_record_destribution.m138_cr_expression%TYPE;
    l_m138_acc_cat_id_m134          m138_gl_record_destribution.m138_acc_cat_id_m134%TYPE;
BEGIN
    pname_columns :=
        't28_id, t28_batch_id_t27, t28_cash_account_id_u06,
           t28_distribution_id_m138, t28_source_ref, t28_distribution_ref,
           t28_txn_ref, t28_txn_date, t28_settle_date, t28_narration,
           t28_narration_lang, t28_acc_cat_id_m134, t28_acc_ref,
           t28_currency_code_m03, t28_currency_id_m03, t28_dr, t28_cr';

    pvalue_columns :=
           'SELECT '
        || '1'                                                        --Record
        || LPAD (pt27_id, 5, '0')
        || LPAD (pm138_id, 3, '0')
        || LPAD (pm138_acc_cat_id_m134, 5, '0')
        || '|| LPAD (ROWNUM, 5, ''0'') AS t28_id, '                   --t28_id
        || pt27_id                                          --t28_batch_id_t27
        || ' AS t28_batch_id_t27, cash_account_id_u06 AS t28_cash_account_id_u06, ' --t28_cash_account_id_u06
        || pm138_id                                 --t28_distribution_id_m138
        || ' AS t28_distribution_id_m138, '
        || pm137_external_ref                                 --t28_source_ref
        || ' AS t28_source_ref, '
        || pm138_external_ref                           --t28_distribution_ref
        || ' AS t28_distribution_ref, txn_ref AS t28_txn_ref, txn_date AS t28_txn_date, settle_date AS t28_settle_date, ' --t28_txn_ref, t28_txn_date, t28_settle_date
        || pm138_narration_expression                          --t28_narration
        || ' AS t28_narration, '
        || pm138_narration_expression_l                   --t28_narration_lang
        || ' AS t28_narration_lang, '
        || pm138_acc_cat_id_m134                         --t28_acc_cat_id_m134
        || ' AS t28_acc_cat_id_m134, '
        || pm138_acc_ref                                         --t28_acc_ref
        || ' AS t28_acc_ref, currency_code_m03 AS t28_currency_code_m03, currency_id_m03 AS t28_currency_id_m03, ' --t28_currency_code_m03, t28_currency_id_m03
        || pm138_dr_expression                                        --t28_dr
        || ' AS t28_dr, '
        || pm138_cr_expression                                        --t28_cr
        || ' AS t28_cr '
        || ' FROM '
        || pm137_view_name
        || CASE
               WHEN pm137_cutoff_enabled = 1 THEN ', t30_gl_txn_candidates'
               ELSE ''
           END
        || CASE
               WHEN pm137_filter IS NOT NULL THEN ' WHERE ' || pm137_filter
               ELSE ''
           END;
END;
/