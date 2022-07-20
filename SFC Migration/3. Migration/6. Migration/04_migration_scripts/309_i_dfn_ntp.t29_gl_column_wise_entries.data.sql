DECLARE
    l_batch_id   NUMBER;
    l_sqlerrm    VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t27_id), 0) INTO l_batch_id FROM dfn_ntp.t27_gl_batches;

    DELETE FROM error_log
          WHERE mig_table = 'T27_GL_BATCHES';

    FOR i
        IN (SELECT to_gl_local.*, t27_map.new_reference
              FROM (  SELECT 'T10_GL_LOCAL_INTEGRATION_SFC' AS source_tbale,
                             t10.t10_transaction_date,
                             t10.t10_transaction_reference,
                             MAX (u06_institute_id_m02) AS institute_id
                        FROM mubasher_oms.t10_gl_local_integration_sfc@mubasher_db_link t10,
                             u06_cash_account_mappings u06_map,
                             dfn_ntp.u06_cash_account u06,
                             dfn_ntp.m03_currency m03
                       WHERE     t10.t10_cash_account_id =
                                     u06_map.old_cash_account_id
                             AND u06_map.new_cash_account_id = u06.u06_id
                             AND t10.t10_cash_account_currency =
                                     m03.m03_code(+)
                    GROUP BY t10.t10_transaction_date,
                             t10.t10_transaction_reference) to_gl_local,
                   (SELECT *
                      FROM t27_gl_new_batches_mappings
                     WHERE old_gl_table = 'T10_GL_LOCAL_INTEGRATION_SFC') t27_map
             WHERE     to_gl_local.t10_transaction_date =
                           t27_map.old_txn_date(+)
                   AND to_gl_local.t10_transaction_reference =
                           t27_map.old_reference(+))
    LOOP
        BEGIN
            IF i.new_reference IS NULL
            THEN
                l_batch_id := l_batch_id + 1;

                INSERT
                  INTO dfn_ntp.t27_gl_batches (t27_id,
                                               t27_institute_id_m02,
                                               t27_date,
                                               t27_event_cat_id_m136,
                                               t27_created_by_id_u17,
                                               t27_created_date,
                                               t27_status_id_v01,
                                               t27_status_changed_by_id_u17,
                                               t27_status_changed_date,
                                               t27_custom_type)
                VALUES (l_batch_id, -- t27_id
                        i.institute_id, -- t27_institute_id_m02
                        i.t10_transaction_date, -- t27_date
                        2, -- t27_event_cat_id_m136 | 2 - LB GL - Daily
                        0, -- t27_created_by_id_u17
                        i.t10_transaction_date, -- t27_created_date
                        2, -- t27_status_id_v01
                        0, -- t27_status_changed_by_id_u17
                        i.t10_transaction_date, -- t27_status_changed_date
                        '1' -- t27_custom_type
                           );

                INSERT INTO t27_gl_new_batches_mappings (old_gl_table,
                                                        old_txn_date,
                                                        old_reference,
                                                        new_reference)
                     VALUES (i.source_tbale,
                             i.t10_transaction_date,
                             i.t10_transaction_reference,
                             l_batch_id);
            ELSE
                UPDATE dfn_ntp.t27_gl_batches
                   SET t27_institute_id_m02 = i.institute_id, -- t27_institute_id_m02
                       t27_status_changed_date = i.t10_transaction_date -- t27_status_changed_date
                 WHERE t27_id = i.new_reference;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'LOCAL - T27_GL_BATCHES',
                                   'Date : '
                                || i.t10_transaction_date
                                || ' - Reference : '
                                || i.t10_transaction_reference,
                                CASE
                                    WHEN i.new_reference IS NULL
                                    THEN
                                        l_batch_id
                                    ELSE
                                        i.new_reference
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_reference IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

DECLARE
    l_gl_colomn_wise_entry_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t29_id), 0)
      INTO l_gl_colomn_wise_entry_id
      FROM dfn_ntp.t29_gl_column_wise_entries;

    DELETE FROM error_log
          WHERE mig_table = 'T29_GL_COLUMN_WISE_ENTRIES';

    FOR i
        IN (SELECT t10.t10_id,
                   u06_map.new_cash_account_id,
                   t10.t10_transaction_reference,
                   t10.t10_transaction_date,
                   t10.t10_value_date,
                   t10.t10_remarks,
                   m03.m03_code,
                   m03.m03_id,
                   t10.t10_dr_amount_one,
                   t10.t10_cr_amount_one,
                   t10.t10_dr_account_one,
                   t10.t10_cr_account_one,
                   t10.t10_dr_amount_two,
                   t10.t10_cr_amount_two,
                   t10.t10_dr_account_two,
                   t10.t10_cr_account_two,
                   t10.t10_dr_amount_three,
                   t10.t10_cr_amount_three,
                   t10.t10_dr_account_three,
                   t10.t10_cr_account_three,
                   t10.t10_dr_amount_four,
                   t10.t10_cr_amount_four,
                   t10.t10_dr_account_four,
                   t10.t10_cr_account_four,
                   u06.u06_institute_id_m02,
                   t10.t10_create_date,
                   t27_new_map.new_reference,
                   t10.t10_cash_account_reference,
                   t29_map.new_gl_col_wise_entry_id
              FROM mubasher_oms.t10_gl_local_integration_sfc@mubasher_db_link t10,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   dfn_ntp.m03_currency m03,
                   t29_gl_col_wise_entry_mappings t29_map,
                   (SELECT *
                      FROM t27_gl_new_batches_mappings
                     WHERE old_gl_table = 'T10_GL_LOCAL_INTEGRATION_SFC') t27_new_map
             WHERE     t10.t10_cash_account_id =
                           u06_map.old_cash_account_id(+)
                   AND u06_map.new_cash_account_id = u06.u06_id(+)
                   AND t10.t10_cash_account_currency = m03.m03_code(+)
                   AND t10.t10_transaction_date = t27_new_map.old_txn_date(+)
                   AND t10.t10_transaction_reference =
                           t27_new_map.old_reference(+)
                   AND t10.t10_id = t29_map.old_gl_col_wise_entry_id(+))
    LOOP
        BEGIN
            IF i.new_cash_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Cash Account Not Available',
                                         TRUE);
            END IF;

            IF i.m03_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Currency Not Available',
                                         TRUE);
            END IF;

            IF i.new_gl_col_wise_entry_id IS NULL
            THEN
                l_gl_colomn_wise_entry_id := l_gl_colomn_wise_entry_id + 1;

                INSERT
                  INTO dfn_ntp.t29_gl_column_wise_entries (
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
                           t29_dr_1_acc_ref,
                           t29_dr_2_acc_ref,
                           t29_dr_3_acc_ref,
                           t29_dr_4_acc_ref,
                           t29_dr_5_acc_ref,
                           t29_cr_1_acc_ref,
                           t29_cr_2_acc_ref,
                           t29_cr_3_acc_ref,
                           t29_cr_4_acc_ref,
                           t29_cr_5_acc_ref,
                           t29_source_ref,
                           t29_distribution_ref,
                           t29_event_ref_1,
                           t29_event_ref_2,
                           t29_event_ref_3,
                           t29_event_ref_4,
                           t29_event_ref_5)
                VALUES (l_gl_colomn_wise_entry_id, -- t29_id
                        i.new_reference, -- t29_batch_id_t27
                        i.new_cash_account_id, -- t29_cash_account_id_u06
                        -1, -- t29_distribution_id_m139 | Not Available
                        i.t10_transaction_reference, -- t29_txn_ref
                        i.t10_transaction_date, -- t29_txn_date
                        i.t10_transaction_date, -- t29_settle_date | Not Available
                        i.t10_remarks, -- t29_narration
                        i.t10_remarks, -- t29_narration_lang
                        i.m03_code, -- t29_currency_code_m03
                        i.m03_id, -- t29_currency_id_m03
                        -1, -- t29_dr1_acc_cat_id_m134 | Not Available
                        i.t10_dr_amount_one, -- t29_dr1
                        -1, -- t29_dr2_acc_cat_id_m134 | Not Available
                        i.t10_dr_amount_two, -- t29_dr2
                        -1, -- t29_dr3_acc_cat_id_m134 | Not Available
                        i.t10_dr_amount_three, -- t29_dr3
                        -1, -- t29_dr4_acc_cat_id_m134 | Not Available
                        i.t10_dr_amount_four, -- t29_dr4
                        -1, -- t29_dr5_acc_cat_id_m134 | Not Available
                        0, -- t29_dr5 | Not Available
                        -1, -- t29_cr1_acc_cat_id_m134 | Not Available
                        i.t10_cr_amount_one, -- t29_cr1
                        -1, -- t29_cr2_acc_cat_id_m134 | Not Available
                        i.t10_cr_amount_two, -- t29_cr2
                        -1, -- t29_cr3_acc_cat_id_m134 | Not Available
                        i.t10_cr_amount_three, -- t29_cr3
                        -1, -- t29_cr4_acc_cat_id_m134 | Not Available
                        i.t10_cr_amount_four, -- t29_cr4
                        -1, -- t29_cr5_acc_cat_id_m134 | Not Available
                        0, -- t29_cr5
                        i.t10_dr_account_one, -- t29_dr_1_acc_ref
                        i.t10_dr_account_two, -- t29_dr_2_acc_ref
                        i.t10_dr_account_three, -- t29_dr_3_acc_ref
                        i.t10_dr_account_four, -- t29_dr_4_acc_ref
                        NULL, -- t29_dr_5_acc_ref | Not Available
                        i.t10_cr_account_one, -- t29_cr_1_acc_ref
                        i.t10_cr_account_two, -- t29_cr_2_acc_ref
                        i.t10_cr_account_three, -- t29_cr_3_acc_ref
                        i.t10_cr_account_four, -- t29_cr_4_acc_ref
                        NULL, -- t29_cr_5_acc_ref | Not Available
                        i.t10_cash_account_reference, -- t29_source_ref
                        i.t10_id, -- t29_distribution_ref
                        NULL, -- t29_event_ref_1 | Not Available
                        NULL, -- t29_event_ref_2 | Not Available
                        NULL, -- t29_event_ref_3 | Not Available
                        NULL, -- t29_event_ref_4 | Not Available
                        NULL -- t29_event_ref_5 | Not Available
                            );

                INSERT
                  INTO t29_gl_col_wise_entry_mappings (
                           old_gl_col_wise_entry_id,
                           new_gl_col_wise_entry_id)
                VALUES (i.t10_id, l_gl_colomn_wise_entry_id);
            ELSE
                UPDATE dfn_ntp.t29_gl_column_wise_entries
                   SET t29_batch_id_t27 = i.new_reference, -- t29_batch_id_t27
                       t29_cash_account_id_u06 = i.new_cash_account_id, -- t29_cash_account_id_u06
                       t29_txn_ref = i.t10_transaction_reference, -- t29_txn_ref
                       t29_txn_date = i.t10_transaction_date, -- t29_txn_date
                       t29_settle_date = i.t10_transaction_date, -- t29_settle_date | Not Available
                       t29_narration = i.t10_remarks, -- t29_narration
                       t29_narration_lang = i.t10_remarks, -- t29_narration_lang
                       t29_currency_code_m03 = i.m03_code, -- t29_currency_code_m03
                       t29_currency_id_m03 = i.m03_id, -- t29_currency_id_m03
                       t29_dr1 = i.t10_dr_amount_one, -- t29_dr1
                       t29_dr2 = i.t10_dr_amount_two, -- t29_dr2
                       t29_dr3 = i.t10_dr_amount_three, -- t29_dr3
                       t29_dr4 = i.t10_dr_amount_four, -- t29_dr4
                       t29_cr1 = i.t10_cr_amount_one, -- t29_cr1
                       t29_cr2 = i.t10_cr_amount_two, -- t29_cr2
                       t29_cr3 = i.t10_cr_amount_three, -- t29_cr3
                       t29_cr4 = i.t10_cr_amount_four, -- t29_cr4
                       t29_dr_1_acc_ref = i.t10_dr_account_one, -- t29_dr_1_acc_ref
                       t29_dr_2_acc_ref = i.t10_dr_account_two, -- t29_dr_2_acc_ref
                       t29_dr_3_acc_ref = i.t10_dr_account_three, -- t29_dr_3_acc_ref
                       t29_dr_4_acc_ref = i.t10_dr_account_four, -- t29_dr_4_acc_ref
                       t29_cr_1_acc_ref = i.t10_cr_account_one, -- t29_cr_1_acc_ref
                       t29_cr_2_acc_ref = i.t10_cr_account_two, -- t29_cr_2_acc_ref
                       t29_cr_3_acc_ref = i.t10_cr_account_three, -- t29_cr_3_acc_ref
                       t29_cr_4_acc_ref = i.t10_cr_account_four, -- t29_cr_4_acc_ref
                       t29_source_ref = i.t10_cash_account_reference, -- t29_source_ref
                       t29_distribution_ref = i.t10_id -- t29_distribution_ref
                 WHERE t29_id = i.new_gl_col_wise_entry_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T29_GL_COLUMN_WISE_ENTRIES',
                                i.t10_id,
                                CASE
                                    WHEN i.new_gl_col_wise_entry_id IS NULL
                                    THEN
                                        l_gl_colomn_wise_entry_id
                                    ELSE
                                        i.new_gl_col_wise_entry_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_gl_col_wise_entry_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
