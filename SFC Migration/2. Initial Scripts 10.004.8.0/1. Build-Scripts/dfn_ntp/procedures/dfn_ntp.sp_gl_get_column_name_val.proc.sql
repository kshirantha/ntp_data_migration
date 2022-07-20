CREATE OR REPLACE PROCEDURE dfn_ntp.sp_gl_get_column_name_val (
    pt27_id                        IN     t27_gl_batches.t27_id%TYPE,
    pm137_view_name                IN     m137_gl_event_data_sources.m137_view_name%TYPE,
    pm137_cutoff_enabled           IN     m137_gl_event_data_sources.m137_cutoff_enabled%TYPE,
    pm137_external_ref             IN     m137_gl_event_data_sources.m137_external_ref%TYPE,
    pm137_filter                   IN     VARCHAR2,
    pm139_id                       IN     m139_gl_column_destribution.m139_id%TYPE,
    pm139_external_ref             IN     m139_gl_column_destribution.m139_external_ref%TYPE,
    pm139_narration_expression     IN     m139_gl_column_destribution.m139_narration_expression%TYPE,
    pm139_narration_expression_l   IN     m139_gl_column_destribution.m139_narration_expression_lang%TYPE,
    pm139_dr_1_expression          IN     m139_gl_column_destribution.m139_dr_1_expression%TYPE,
    pm139_dr_1_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_dr_1_acc_cat_id_m134%TYPE,
    pm139_dr_1_acc_ref             IN     m139_gl_column_destribution.m139_dr_1_acc_ref%TYPE,
    pm139_dr_2_expression          IN     m139_gl_column_destribution.m139_dr_2_expression%TYPE,
    pm139_dr_2_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_dr_2_acc_cat_id_m134%TYPE,
    pm139_dr_2_acc_ref             IN     m139_gl_column_destribution.m139_dr_2_acc_ref%TYPE,
    pm139_dr_3_expression          IN     m139_gl_column_destribution.m139_dr_3_expression%TYPE,
    pm139_dr_3_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_dr_3_acc_cat_id_m134%TYPE,
    pm139_dr_3_acc_ref             IN     m139_gl_column_destribution.m139_dr_3_acc_ref%TYPE,
    pm139_dr_4_expression          IN     m139_gl_column_destribution.m139_dr_4_expression%TYPE,
    pm139_dr_4_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_dr_4_acc_cat_id_m134%TYPE,
    pm139_dr_4_acc_ref             IN     m139_gl_column_destribution.m139_dr_4_acc_ref%TYPE,
    pm139_dr_5_expression          IN     m139_gl_column_destribution.m139_dr_5_expression%TYPE,
    pm139_dr_5_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_dr_5_acc_cat_id_m134%TYPE,
    pm139_dr_5_acc_ref             IN     m139_gl_column_destribution.m139_dr_5_acc_ref%TYPE,
    pm139_cr_1_expression          IN     m139_gl_column_destribution.m139_cr_1_expression%TYPE,
    pm139_cr_1_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_cr_1_acc_cat_id_m134%TYPE,
    pm139_cr_1_acc_ref             IN     m139_gl_column_destribution.m139_cr_1_acc_ref%TYPE,
    pm139_cr_2_expression          IN     m139_gl_column_destribution.m139_cr_2_expression%TYPE,
    pm139_cr_2_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_cr_2_acc_cat_id_m134%TYPE,
    pm139_cr_2_acc_ref             IN     m139_gl_column_destribution.m139_cr_2_acc_ref%TYPE,
    pm139_cr_3_expression          IN     m139_gl_column_destribution.m139_cr_3_expression%TYPE,
    pm139_cr_3_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_cr_3_acc_cat_id_m134%TYPE,
    pm139_cr_3_acc_ref             IN     m139_gl_column_destribution.m139_cr_3_acc_ref%TYPE,
    pm139_cr_4_expression          IN     m139_gl_column_destribution.m139_cr_4_expression%TYPE,
    pm139_cr_4_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_cr_4_acc_cat_id_m134%TYPE,
    pm139_cr_4_acc_ref             IN     m139_gl_column_destribution.m139_cr_4_acc_ref%TYPE,
    pm139_cr_5_expression          IN     m139_gl_column_destribution.m139_cr_5_expression%TYPE,
    pm139_cr_5_acc_cat_id_m134     IN     m139_gl_column_destribution.m139_cr_5_acc_cat_id_m134%TYPE,
    pm139_cr_5_acc_ref             IN     m139_gl_column_destribution.m139_cr_5_acc_ref%TYPE,
    pm139_event_ref_1              IN     dfn_ntp.m139_gl_column_destribution.m139_event_ref_1%TYPE,
    pm139_event_ref_2              IN     dfn_ntp.m139_gl_column_destribution.m139_event_ref_2%TYPE,
    pm139_event_ref_3              IN     dfn_ntp.m139_gl_column_destribution.m139_event_ref_3%TYPE,
    pm139_event_ref_4              IN     dfn_ntp.m139_gl_column_destribution.m139_event_ref_4%TYPE,
    pm139_event_ref_5              IN     dfn_ntp.m139_gl_column_destribution.m139_event_ref_5%TYPE,
    pname_columns                     OUT VARCHAR2,
    pvalue_columns                    OUT VARCHAR2)
IS
BEGIN
    pname_columns :=
        't29_id, t29_batch_id_t27, t29_cash_account_id_u06, t29_distribution_id_m139, t29_source_ref,
        t29_distribution_ref, t29_txn_ref, t29_txn_date, t29_settle_date, t29_narration, t29_narration_lang,
        t29_currency_code_m03, t29_currency_id_m03,
        t29_dr1_acc_cat_id_m134, t29_dr_1_acc_ref, t29_dr1,
        t29_dr2_acc_cat_id_m134, t29_dr_2_acc_ref, t29_dr2,
        t29_dr3_acc_cat_id_m134, t29_dr_3_acc_ref, t29_dr3,
        t29_dr4_acc_cat_id_m134, t29_dr_4_acc_ref, t29_dr4,
        t29_dr5_acc_cat_id_m134, t29_dr_5_acc_ref, t29_dr5,
        t29_cr1_acc_cat_id_m134, t29_cr_1_acc_ref, t29_cr1,
        t29_cr2_acc_cat_id_m134, t29_cr_2_acc_ref, t29_cr2,
        t29_cr3_acc_cat_id_m134, t29_cr_3_acc_ref, t29_cr3,
        t29_cr4_acc_cat_id_m134, t29_cr_4_acc_ref, t29_cr4,
        t29_cr5_acc_cat_id_m134, t29_cr_5_acc_ref, t29_cr5,
        t29_event_ref_1, t29_event_ref_2, t29_event_ref_3, t29_event_ref_4, t29_event_ref_5';

    pvalue_columns :=
           'SELECT '
        || '2'                                                   --Column Wise
        || LPAD (pt27_id, 5, '0')
        || LPAD (pm139_id, 3, '0')
        || ' || LPAD (ROWNUM, 5, ''0'') AS t29_id, '                  --t29_id
        || pt27_id                                          --t29_batch_id_t27
        || ' AS t29_id, cash_account_id_u06 AS t29_cash_account_id_u06, ' --t29_cash_account_id_u06
        || pm139_id                                 --t29_distribution_id_m139
        || ' AS t29_distribution_id_m139, '
        || pm137_external_ref
        || ' AS t29_source_ref, '                             --t29_source_ref
        || pm139_external_ref
        || ' AS t29_distribution_ref, '                 --t29_distribution_ref
        || 'txn_ref AS t29_txn_ref, txn_date AS t29_txn_date, settle_date AS t29_settle_date, ' --t29_txn_ref, t29_txn_date, t29_settle_date
        || pm139_narration_expression                          --t29_narration
        || ' AS t29_narration, '
        || pm139_narration_expression_l                   --t29_narration_lang
        || ' AS t29_narration_lang, currency_code_m03 AS t29_currency_code_m03, currency_id_m03 AS t29_currency_id_m03, ' --t29_currency_code_m03, t29_currency_id_m03
        || pm139_dr_1_acc_cat_id_m134
        || ' AS t29_dr1_acc_cat_id_m134, '           --t29_dr1_acc_cat_id_m134
        || pm139_dr_1_acc_ref
        || ' AS t29_dr_1_acc_ref, '                         --t29_dr_1_acc_ref
        || pm139_dr_1_expression
        || ' AS t29_dr1, '                                           --t29_dr1
        || pm139_dr_2_acc_cat_id_m134
        || ' AS t29_dr2_acc_cat_id_m134, '           --t29_dr2_acc_cat_id_m134
        || pm139_dr_2_acc_ref
        || ' AS t29_dr_2_acc_ref, '                         --t29_dr_2_acc_ref
        || pm139_dr_2_expression
        || ' AS t29_dr2, '                                           --t29_dr2
        || pm139_dr_3_acc_cat_id_m134
        || ' AS t29_dr3_acc_cat_id_m134, '           --t29_dr3_acc_cat_id_m134
        || pm139_dr_3_acc_ref
        || ' AS t29_dr_3_acc_ref, '                         --t29_dr_3_acc_ref
        || pm139_dr_3_expression
        || ' AS t29_dr3, '                                           --t29_dr3
        || pm139_dr_4_acc_cat_id_m134
        || ' AS t29_dr4_acc_cat_id_m134, '           --t29_dr4_acc_cat_id_m134
        || pm139_dr_4_acc_ref
        || ' AS t29_dr_4_acc_ref, '                         --t29_dr_4_acc_ref
        || pm139_dr_4_expression
        || ' AS t29_dr4, '                                           --t29_dr4
        || pm139_dr_5_acc_cat_id_m134
        || ' AS t29_dr5_acc_cat_id_m134, '           --t29_dr5_acc_cat_id_m134
        || pm139_dr_5_acc_ref
        || ' AS t29_dr_5_acc_ref, '                         --t29_dr_5_acc_ref
        || pm139_dr_5_expression
        || ' AS t29_dr5, '                                           --t29_dr5
        || pm139_cr_1_acc_cat_id_m134
        || ' AS t29_cr1_acc_cat_id_m134, '           --t29_cr1_acc_cat_id_m134
        || pm139_cr_1_acc_ref
        || ' AS t29_cr_1_acc_ref, '                         --t29_cr_1_acc_ref
        || pm139_cr_1_expression
        || ' AS t29_cr1, '                                           --t29_cr1
        || pm139_cr_2_acc_cat_id_m134
        || ' AS t29_cr2_acc_cat_id_m134, '           --t29_cr2_acc_cat_id_m134
        || pm139_cr_2_acc_ref
        || ' AS t29_cr_2_acc_ref, '                         --t29_cr_2_acc_ref
        || pm139_cr_2_expression
        || ' AS t29_cr2, '                                           --t29_cr2
        || pm139_cr_3_acc_cat_id_m134
        || ' AS t29_cr3_acc_cat_id_m134, '           --t29_cr3_acc_cat_id_m134
        || pm139_cr_3_acc_ref
        || ' AS t29_cr_3_acc_ref, '                         --t29_cr_3_acc_ref
        || pm139_cr_3_expression
        || ' AS t29_cr3, '                                           --t29_cr3
        || pm139_cr_4_acc_cat_id_m134
        || ' AS t29_cr4_acc_cat_id_m134, '           --t29_cr4_acc_cat_id_m134
        || pm139_cr_4_acc_ref
        || ' AS t29_cr_4_acc_ref, '                         --t29_cr_4_acc_ref
        || pm139_cr_4_expression
        || ' AS t29_cr4, '                                           --t29_cr4
        || pm139_cr_5_acc_cat_id_m134
        || ' AS t29_cr5_acc_cat_id_m134, '           --t29_cr5_acc_cat_id_m134
        || pm139_cr_5_acc_ref
        || ' AS t29_cr_5_acc_ref, '                         --t29_cr_5_acc_ref
        || pm139_cr_5_expression
        || ' AS t29_cr5, '                                           --t29_cr5
        || pm139_event_ref_1
        || ' AS t29_event_ref_1, '                           --t29_event_ref_1
        || pm139_event_ref_2
        || ' AS t29_event_ref_2, '                           --t29_event_ref_2
        || pm139_event_ref_3
        || ' AS t29_event_ref_3, '                           --t29_event_ref_3
        || pm139_event_ref_4
        || ' AS t29_event_ref_4, '                           --t29_event_ref_4
        || pm139_event_ref_5
        || ' AS t29_event_ref_5 '                            --t29_event_ref_5
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