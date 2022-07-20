CREATE OR REPLACE PROCEDURE dfn_ntp.sp_gl_process (
    pdate                    IN     DATE,
    pm136_id                 IN     m136_gl_event_categories.m136_id%TYPE,
    pt27_created_by_id_u17   IN     t27_gl_batches.t27_created_by_id_u17%TYPE,
    pt27_id                  IN     t27_gl_batches.t27_id%TYPE DEFAULT -1,
    paction                  IN     NUMBER DEFAULT 1, --1 - Generate | 2 - Regenerate
    pkey                        OUT NUMBER)
IS
    l_date                      DATE;
    l_m136_enabled              m136_gl_event_categories.m136_enabled%TYPE;
    l_t27_id                    t27_gl_batches.t27_id%TYPE;
    l_m136_institute_id_m02     m136_gl_event_categories.m136_institute_id_m02%TYPE;
    l_m136_type                 m136_gl_event_categories.m136_type%TYPE;
    l_m136_currency_filter      m136_gl_event_categories.m136_currency_filter%TYPE;
    l_m136_exchange_filter      m136_gl_event_categories.m136_exchange_filter%TYPE;
    l_name_columns              VARCHAR2 (32000);
    l_value_columns             VARCHAR2 (32000);
    l_query_str                 VARCHAR2 (15000);
    l_insert_qry                VARCHAR2 (30000);
    l_filter                    VARCHAR2 (5000);
    l_candidate_filter          VARCHAR2 (1000);
    l_institute_tag             VARCHAR2 (20) := '[INSTITUTE_ID_M02]';
    l_date_tag                  VARCHAR2 (20) := '[DATE]';
    l_currency_filter_tag       VARCHAR2 (20) := '[CURRENCY_FILTER]';
    l_exchange_filter_tag       VARCHAR2 (20) := '[EXCHANGE_FILTER]';
    l_record_wise_entry_table   VARCHAR2 (60)
                                    := 'DFN_NTP.T28_GL_RECORD_WISE_ENTRIES';
    l_column_wise_entry_table   VARCHAR2 (60)
                                    := 'DFN_NTP.T29_GL_COLUMN_WISE_ENTRIES';
    l_count                     NUMBER := 0;
    l_difference                NUMBER (18, 5) := 0;

    TYPE refcursor IS REF CURSOR;

    c_table_data                refcursor;
BEGIN
    l_date := TRUNC (pdate);

    SELECT m136_enabled,
           m136_institute_id_m02,
           m136_type,
           m136_currency_filter,
           m136_exchange_filter
      INTO l_m136_enabled,
           l_m136_institute_id_m02,
           l_m136_type,
           l_m136_currency_filter,
           l_m136_exchange_filter
      FROM m136_gl_event_categories
     WHERE m136_id = pm136_id;

    IF l_m136_enabled != 1                                  --0 - No | 1 - Yes
    THEN
        pkey := -2;
        RETURN;
    END IF;

    IF paction = 2                             --1 - Generate | 2 - Regenerate
    THEN
        SELECT COUNT (t27_id)
          INTO l_count
          FROM t27_gl_batches
         WHERE t27_id = pt27_id AND t27_status_id_v01 = 2;      --2 - Approved

        IF l_count > 0
        THEN
            pkey := -3;
            RETURN;
        END IF;

        l_t27_id := pt27_id;

        IF l_m136_type = 0                                        --0 - Record
        THEN
            EXECUTE IMMEDIATE
                   'DELETE FROM '
                || l_record_wise_entry_table
                || ' WHERE t28_batch_id_t27 = '
                || l_t27_id;
        ELSIF l_m136_type = 1                                     --1 - Column
        THEN
            EXECUTE IMMEDIATE
                   'DELETE FROM '
                || l_column_wise_entry_table
                || ' WHERE t29_batch_id_t27 = '
                || l_t27_id;
        END IF;

        COMMIT;
    ELSE
        l_t27_id := fn_get_next_sequnce (pseq_name => 'T27_GL_BATCHES');

        INSERT INTO t27_gl_batches (t27_id,
                                    t27_institute_id_m02,
                                    t27_date,
                                    t27_event_cat_id_m136,
                                    t27_created_by_id_u17,
                                    t27_created_date,
                                    t27_status_id_v01)
             VALUES (l_t27_id,
                     l_m136_institute_id_m02,
                     l_date,
                     pm136_id,
                     pt27_created_by_id_u17,
                     SYSDATE,
                     18                                           --Processing
                       );

        COMMIT;
    END IF;

    sp_gl_pre_validation (pdate                   => l_date,
                          pm136_currency_filter   => l_m136_currency_filter,
                          pm136_exchange_filter   => l_m136_exchange_filter);

    COMMIT;

    pkey := -1;

    FOR c_data
        IN (SELECT m136.m136_type,
                   m137.m137_id,
                   m137.m137_view_name,
                   m137.m137_filter,
                   m137.m137_cutoff_enabled,
                   m137.m137_cutoff_key_column,
                   m137.m137_external_ref
              FROM m136_gl_event_categories m136,
                   m137_gl_event_data_sources m137
             WHERE     m136.m136_id = pm136_id
                   AND m136.m136_id = m137.m137_event_cat_id_m136
                   AND m137.m137_enabled = 1                --0 - No | 1 - Yes
                                            )
    LOOP
        l_filter :=
            REPLACE (c_data.m137_filter,
                     l_institute_tag,
                     l_m136_institute_id_m02);

        l_filter :=
            REPLACE (l_filter, l_currency_filter_tag, l_m136_currency_filter);

        l_filter :=
            REPLACE (l_filter, l_exchange_filter_tag, l_m136_exchange_filter);

        l_filter :=
            REPLACE (
                l_filter,
                l_date_tag,
                   'TO_DATE('''
                || TO_CHAR (l_date, 'DD-MON-YYYY')
                || ''', ''DD-MON-YYYY'')');

        IF c_data.m137_cutoff_enabled = 1
        THEN
            IF paction = 1                     --1 - Generate | 2 - Regenerate
            THEN
                l_candidate_filter :=
                       c_data.m137_cutoff_key_column
                    || ' NOT IN (SELECT t30_txn_id FROM t30_gl_txn_candidates WHERE t30_date = TO_DATE('''
                    || TO_CHAR (l_date, 'DD-MON-YYYY')
                    || ''', ''DD-MON-YYYY'') AND t30_data_source_id_m137 = '
                    || c_data.m137_id
                    || ')';

                l_query_str :=
                       'INSERT INTO t30_gl_txn_candidates (t30_date,
                                                   t30_batch_id_t27,
                                                   t30_txn_id,
                                                   t30_data_source_id_m137)
                    SELECT TO_DATE('''
                    || TO_CHAR (l_date, 'DD-MON-YYYY')
                    || ''', ''DD-MON-YYYY''), '
                    || l_t27_id
                    || ', '
                    || c_data.m137_cutoff_key_column
                    || ', '
                    || c_data.m137_id
                    || ' FROM '
                    || c_data.m137_view_name
                    || CASE
                           WHEN l_filter IS NOT NULL
                           THEN
                                  ' WHERE '
                               || l_filter
                               || ' AND '
                               || l_candidate_filter
                           ELSE
                               ' WHERE ' || l_candidate_filter
                       END;

                EXECUTE IMMEDIATE l_query_str;

                COMMIT;
            END IF;

            l_filter :=
                   l_filter
                || ' AND '
                || c_data.m137_cutoff_key_column
                || ' = t30_txn_id AND t30_batch_id_t27 = '
                || l_t27_id
                || ' AND t30_data_source_id_m137 = '
                || c_data.m137_id;
        END IF;

        IF c_data.m136_type = 0                                   --0 - Record
        THEN
            FOR c_dstr
                IN (SELECT m138.m138_id,
                           m138.m138_narration_expression,
                           m138.m138_narration_expression_lang,
                           m138.m138_dr_expression,
                           m138.m138_cr_expression,
                           m138.m138_acc_cat_id_m134,
                           m138.m138_filter,
                           m138.m138_external_ref,
                           m138.m138_acc_ref
                      FROM m138_gl_record_destribution m138
                     WHERE     m138.m138_data_source_id_m137 = c_data.m137_id
                           AND m138.m138_enabled = 1        --0 - No | 1 - Yes
                                                    )
            LOOP
                sp_gl_get_record_name_val (
                    pt27_id                        => l_t27_id,
                    pm137_view_name                => c_data.m137_view_name,
                    pm137_cutoff_enabled           => c_data.m137_cutoff_enabled,
                    pm137_filter                   =>    l_filter
                                                      || CASE
                                                             WHEN c_dstr.m138_filter
                                                                      IS NOT NULL
                                                             THEN
                                                                    ' AND '
                                                                 || c_dstr.m138_filter
                                                         END,
                    pm137_external_ref             => c_data.m137_external_ref,
                    pm138_id                       => c_dstr.m138_id,
                    pm138_external_ref             => c_dstr.m138_external_ref,
                    pm138_narration_expression     => c_dstr.m138_narration_expression,
                    pm138_narration_expression_l   => c_dstr.m138_narration_expression_lang,
                    pm138_dr_expression            => c_dstr.m138_dr_expression,
                    pm138_cr_expression            => c_dstr.m138_cr_expression,
                    pm138_acc_cat_id_m134          => c_dstr.m138_acc_cat_id_m134,
                    pm138_acc_ref                  => c_dstr.m138_acc_ref,
                    pname_columns                  => l_name_columns,
                    pvalue_columns                 => l_value_columns);

                l_query_str :=
                       'INSERT INTO '
                    || l_record_wise_entry_table
                    || ' ('
                    || l_name_columns
                    || ') '
                    || l_value_columns;

                EXECUTE IMMEDIATE l_query_str;

                COMMIT;
            END LOOP;
        ELSIF c_data.m136_type = 1                                --1 - Column
        THEN
            FOR c_dstr
                IN (SELECT m139.m139_id,
                           m139_narration_expression,
                           m139.m139_narration_expression_lang,
                           m139.m139_dr_1_expression,
                           m139.m139_dr_1_acc_cat_id_m134,
                           m139.m139_dr_1_acc_ref,
                           m139.m139_dr_2_expression,
                           m139.m139_dr_2_acc_cat_id_m134,
                           m139.m139_dr_2_acc_ref,
                           m139.m139_dr_3_expression,
                           m139.m139_dr_3_acc_cat_id_m134,
                           m139.m139_dr_3_acc_ref,
                           m139.m139_dr_4_expression,
                           m139.m139_dr_4_acc_cat_id_m134,
                           m139.m139_dr_4_acc_ref,
                           m139.m139_dr_5_expression,
                           m139.m139_dr_5_acc_cat_id_m134,
                           m139.m139_dr_5_acc_ref,
                           m139.m139_cr_1_expression,
                           m139.m139_cr_1_acc_cat_id_m134,
                           m139.m139_cr_1_acc_ref,
                           m139.m139_cr_2_expression,
                           m139.m139_cr_2_acc_cat_id_m134,
                           m139.m139_cr_2_acc_ref,
                           m139.m139_cr_3_expression,
                           m139.m139_cr_3_acc_cat_id_m134,
                           m139.m139_cr_3_acc_ref,
                           m139.m139_cr_4_expression,
                           m139.m139_cr_4_acc_cat_id_m134,
                           m139.m139_cr_4_acc_ref,
                           m139.m139_cr_5_expression,
                           m139.m139_cr_5_acc_cat_id_m134,
                           m139.m139_cr_5_acc_ref,
                           m139.m139_filter,
                           m139.m139_external_ref,
                           m139.m139_event_ref_1,
                           m139.m139_event_ref_2,
                           m139.m139_event_ref_3,
                           m139.m139_event_ref_4,
                           m139.m139_event_ref_5
                      FROM m139_gl_column_destribution m139
                     WHERE     m139.m139_data_source_id_m137 = c_data.m137_id
                           AND m139.m139_enabled = 1        --0 - No | 1 - Yes
                                                    )
            LOOP
                sp_gl_get_column_name_val (
                    pt27_id                        => l_t27_id,
                    pm137_view_name                => c_data.m137_view_name,
                    pm137_cutoff_enabled           => c_data.m137_cutoff_enabled,
                    pm137_filter                   =>    l_filter
                                                      || CASE
                                                             WHEN c_dstr.m139_filter
                                                                      IS NOT NULL
                                                             THEN
                                                                    ' AND '
                                                                 || c_dstr.m139_filter
                                                         END,
                    pm137_external_ref             => c_data.m137_external_ref,
                    pm139_id                       => c_dstr.m139_id,
                    pm139_external_ref             => c_dstr.m139_external_ref,
                    pm139_narration_expression     => c_dstr.m139_narration_expression,
                    pm139_narration_expression_l   => c_dstr.m139_narration_expression_lang,
                    pm139_dr_1_expression          => c_dstr.m139_dr_1_expression,
                    pm139_dr_1_acc_cat_id_m134     => c_dstr.m139_dr_1_acc_cat_id_m134,
                    pm139_dr_1_acc_ref             => c_dstr.m139_dr_1_acc_ref,
                    pm139_dr_2_expression          => c_dstr.m139_dr_2_expression,
                    pm139_dr_2_acc_cat_id_m134     => c_dstr.m139_dr_2_acc_cat_id_m134,
                    pm139_dr_2_acc_ref             => c_dstr.m139_dr_2_acc_ref,
                    pm139_dr_3_expression          => c_dstr.m139_dr_3_expression,
                    pm139_dr_3_acc_cat_id_m134     => c_dstr.m139_dr_3_acc_cat_id_m134,
                    pm139_dr_3_acc_ref             => c_dstr.m139_dr_3_acc_ref,
                    pm139_dr_4_expression          => c_dstr.m139_dr_4_expression,
                    pm139_dr_4_acc_cat_id_m134     => c_dstr.m139_dr_4_acc_cat_id_m134,
                    pm139_dr_4_acc_ref             => c_dstr.m139_dr_4_acc_ref,
                    pm139_dr_5_expression          => c_dstr.m139_dr_5_expression,
                    pm139_dr_5_acc_cat_id_m134     => c_dstr.m139_dr_5_acc_cat_id_m134,
                    pm139_dr_5_acc_ref             => c_dstr.m139_dr_5_acc_ref,
                    pm139_cr_1_expression          => c_dstr.m139_cr_1_expression,
                    pm139_cr_1_acc_cat_id_m134     => c_dstr.m139_cr_1_acc_cat_id_m134,
                    pm139_cr_1_acc_ref             => c_dstr.m139_cr_1_acc_ref,
                    pm139_cr_2_expression          => c_dstr.m139_cr_2_expression,
                    pm139_cr_2_acc_cat_id_m134     => c_dstr.m139_cr_2_acc_cat_id_m134,
                    pm139_cr_2_acc_ref             => c_dstr.m139_cr_2_acc_ref,
                    pm139_cr_3_expression          => c_dstr.m139_cr_3_expression,
                    pm139_cr_3_acc_cat_id_m134     => c_dstr.m139_cr_3_acc_cat_id_m134,
                    pm139_cr_3_acc_ref             => c_dstr.m139_cr_3_acc_ref,
                    pm139_cr_4_expression          => c_dstr.m139_cr_4_expression,
                    pm139_cr_4_acc_cat_id_m134     => c_dstr.m139_cr_4_acc_cat_id_m134,
                    pm139_cr_4_acc_ref             => c_dstr.m139_cr_4_acc_ref,
                    pm139_cr_5_expression          => c_dstr.m139_cr_5_expression,
                    pm139_cr_5_acc_cat_id_m134     => c_dstr.m139_cr_5_acc_cat_id_m134,
                    pm139_cr_5_acc_ref             => c_dstr.m139_cr_5_acc_ref,
                    pm139_event_ref_1              => c_dstr.m139_event_ref_1,
                    pm139_event_ref_2              => c_dstr.m139_event_ref_2,
                    pm139_event_ref_3              => c_dstr.m139_event_ref_3,
                    pm139_event_ref_4              => c_dstr.m139_event_ref_4,
                    pm139_event_ref_5              => c_dstr.m139_event_ref_5,
                    pname_columns                  => l_name_columns,
                    pvalue_columns                 => l_value_columns);

                l_query_str :=
                       'INSERT INTO '
                    || l_column_wise_entry_table
                    || ' ('
                    || l_name_columns
                    || ') '
                    || l_value_columns;

                EXECUTE IMMEDIATE l_query_str;

                COMMIT;
            END LOOP;
        END IF;
    END LOOP;

    sp_gl_post_validation (pt27_id       => l_t27_id,
                           pm136_type    => l_m136_type,
                           pdifference   => l_difference);

    IF l_difference = 0
    THEN
        UPDATE t27_gl_batches
           SET t27_status_id_v01 = 1                                 --Pending
         WHERE t27_id = l_t27_id;
    ELSE
        UPDATE t27_gl_batches
           SET t27_status_id_v01 = 31                                 --Failed
         WHERE t27_id = l_t27_id;
    END IF;

    pkey := l_t27_id;
EXCEPTION
    WHEN OTHERS
    THEN
        UPDATE t27_gl_batches
           SET t27_status_id_v01 = 31                                 --Failed
         WHERE t27_id = l_t27_id;
END;
/