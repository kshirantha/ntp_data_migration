DECLARE
    l_batch_id   NUMBER;
    l_sqlerrm    VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t27_id), 0) INTO l_batch_id FROM dfn_ntp.t27_gl_batches;

    DELETE FROM error_log
          WHERE mig_table = 'T27_GL_BATCHES';

    FOR i
        IN (SELECT t10_gl_int_sfc.*, t27_map.new_reference
              FROM (  SELECT 'T10_GL_INTEGRATION_SFC' AS source_tbale,
                             t10.t10_trns_date,
                             t10.t10_account_no,
                             MAX (u06_institute_id_m02) AS institute_id
                        FROM mubasher_oms.t10_gl_integration_sfc@mubasher_db_link t10,
                             u06_cash_account_mappings u06_map,
                             dfn_ntp.u06_cash_account u06,
                             dfn_ntp.m03_currency m03
                       WHERE     t10.t10_account_no =
                                     u06_map.old_cash_account_id
                             AND u06_map.new_cash_account_id = u06.u06_id
                             AND t10.t10_currency = m03.m03_code(+)
                    GROUP BY t10.t10_trns_date, t10.t10_account_no) t10_gl_int_sfc,
                   (SELECT *
                      FROM t27_gl_new_batches_mappings
                     WHERE old_gl_table = 'T10_GL_INTEGRATION_SFC') t27_map
             WHERE     t10_gl_int_sfc.t10_trns_date = t27_map.old_txn_date(+)
                   AND t10_gl_int_sfc.t10_account_no =
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
                        i.t10_trns_date, -- t27_date
                        1, -- t27_event_cat_id_m136 | 1 - IB GL - Daily
                        0, -- t27_created_by_id_u17
                        i.t10_trns_date, -- t27_created_date
                        2, -- t27_status_id_v01
                        0, -- t27_status_changed_by_id_u17
                        i.t10_trns_date, -- t27_status_changed_date
                        '1' -- t27_custom_type
                           );

                INSERT INTO t27_gl_new_batches_mappings (old_gl_table,
                                                        old_txn_date,
                                                        old_reference,
                                                        new_reference)
                     VALUES (i.source_tbale,
                             i.t10_trns_date,
                             i.t10_account_no,
                             l_batch_id);
            ELSE
                UPDATE dfn_ntp.t27_gl_batches
                   SET t27_institute_id_m02 = i.institute_id, -- t27_institute_id_m02
                       t27_status_changed_date = i.t10_trns_date -- t27_status_changed_date
                 WHERE t27_id = i.new_reference;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'INTERNATIONAL - T27_GL_BATCHES',
                                   'Date : '
                                || i.t10_trns_date
                                || ' - Account No : '
                                || i.t10_account_no,
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
    l_gl_record_wise_entry_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t28_id), 0)
      INTO l_gl_record_wise_entry_id
      FROM dfn_ntp.t28_gl_record_wise_entries;

    DELETE FROM error_log
          WHERE mig_table = 'T28_GL_RECORD_WISE_ENTRIES';

    FOR i
        IN (SELECT t10.t10_created_date,
                   t10.t10_account_no,
                   u06_map.new_cash_account_id,
                   u06.u06_institute_id_m02,
                   t10.t10_trns_date,
                   m03.m03_code,
                   m03.m03_id,
                   t10.t10_remarks,
                   t10.t10_ref_no,
                   t10.t10_sub_ref_no,
                   CASE
                       WHEN t10.t10_trns_amount > 0
                       THEN
                           ABS (t10_trns_amount)
                   END
                       AS cr,
                   CASE
                       WHEN t10.t10_trns_amount < 0
                       THEN
                           ABS (t10_trns_amount)
                   END
                       AS dr,
                   t10.t10_trns_amount,
                   t27_new_map.new_reference,
                   t10.t10_ex_ref_no,
                   t28_map.new_gl_rec_wise_entry_id
              FROM (  SELECT t10_account_no,
                             t10_created_date,
                             t10_trns_date,
                             t10_remarks,
                             t10_ref_no,
                             t10_sub_ref_no,
                             t10_trns_amount,
                             t10_ex_ref_no,
                             t10_currency
                        FROM mubasher_oms.t10_gl_integration_sfc@mubasher_db_link
                       WHERE     t10_ref_no IS NOT NULL
                             AND t10_sub_ref_no IS NOT NULL
                    GROUP BY t10_account_no,
                             t10_created_date,
                             t10_trns_date,
                             t10_remarks,
                             t10_ref_no,
                             t10_sub_ref_no,
                             t10_trns_amount,
                             t10_ex_ref_no,
                             t10_currency) t10,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   dfn_ntp.m03_currency m03,
                   t28_gl_rec_wise_entry_mappings t28_map,
                   (SELECT *
                      FROM t27_gl_new_batches_mappings
                     WHERE old_gl_table = 'T10_GL_INTEGRATION_SFC') t27_new_map
             WHERE     t10.t10_account_no = u06_map.old_cash_account_id(+)
                   AND u06_map.new_cash_account_id = u06.u06_id(+)
                   AND t10.t10_currency = m03.m03_code(+)
                   AND t10.t10_trns_date = t27_new_map.old_txn_date(+)
                   AND t10.t10_account_no = t27_new_map.old_reference(+)
                   AND t10.t10_account_no = t28_map.old_gl_cash_acc_no(+)
                   AND t10.t10_trns_date = t28_map.old_gl_txn_date(+)
                   AND t10.t10_ref_no = t28_map.old_gl_ref_no(+)
                   AND t10.t10_sub_ref_no = t28_map.old_gl_sub_ref_no(+)
                   AND t10.t10_trns_amount = t28_map.old_gl_amount(+))
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

            IF i.t10_ref_no IS NULL
            THEN
                raise_application_error (-20001,
                                         'Old Reference No Not Available',
                                         TRUE);
            END IF;

            IF i.t10_sub_ref_no IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Old Sub Reference No Not Available',
                    TRUE);
            END IF;

            IF i.new_gl_rec_wise_entry_id IS NULL
            THEN
                l_gl_record_wise_entry_id := l_gl_record_wise_entry_id + 1;

                INSERT
                  INTO dfn_ntp.t28_gl_record_wise_entries (
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
                           t28_acc_ref,
                           t28_source_ref,
                           t28_distribution_ref)
                VALUES (l_gl_record_wise_entry_id, -- t28_id
                        i.new_reference, -- t28_batch_id_t27
                        i.new_cash_account_id, -- t28_cash_account_id_u06
                        -1, -- t28_distribution_id_m138 | Not Available
                        i.t10_ref_no, -- t28_txn_ref
                        i.t10_trns_date, -- t28_txn_date
                        i.t10_trns_date, -- t28_settle_date
                        i.t10_remarks, -- t28_narration
                        i.t10_remarks, -- t28_narration_lang
                        -1, -- t28_acc_cat_id_m134 | Not Available
                        i.m03_code, -- t28_currency_code_m03
                        i.m03_id, -- t28_currency_id_m03
                        i.dr, -- t28_dr
                        i.cr, -- t28_cr
                        i.t10_account_no, -- t28_acc_ref
                        i.t10_ex_ref_no, -- t28_source_ref
                        i.t10_sub_ref_no -- t28_distribution_ref
                                        );

                INSERT
                  INTO t28_gl_rec_wise_entry_mappings (
                           old_gl_cash_acc_no,
                           old_gl_txn_date,
                           old_gl_ref_no,
                           old_gl_sub_ref_no,
                           old_gl_amount,
                           new_gl_rec_wise_entry_id)
                VALUES (i.t10_account_no,
                        i.t10_trns_date,
                        i.t10_ref_no,
                        i.t10_sub_ref_no,
                        i.t10_trns_amount,
                        l_gl_record_wise_entry_id);
            ELSE
                UPDATE dfn_ntp.t28_gl_record_wise_entries
                   SET t28_batch_id_t27 = i.new_reference, -- t28_batch_id_t27
                       t28_narration = i.t10_remarks, -- t28_narration
                       t28_narration_lang = i.t10_remarks, -- t28_narration_lang
                       t28_currency_code_m03 = i.m03_code, -- t28_currency_code_m03
                       t28_currency_id_m03 = i.m03_id, -- t28_currency_id_m03
                       t28_dr = i.dr, -- t28_dr
                       t28_cr = i.cr, -- t28_cr
                       t28_source_ref = i.t10_ex_ref_no -- t28_source_ref
                 WHERE t28_id = i.new_gl_rec_wise_entry_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T28_GL_RECORD_WISE_ENTRIES',
                                   'Cash Account - '
                                || i.new_cash_account_id
                                || ' | Txn Date - '
                                || i.t10_trns_date
                                || ' | Ref No - '
                                || i.t10_ref_no
                                || ' | Sub Ref No - '
                                || i.t10_sub_ref_no
                                || ' | Currency - '
                                || i.m03_code
                                || ' | Amount - '
                                || i.t10_trns_amount,
                                CASE
                                    WHEN i.new_gl_rec_wise_entry_id
                                             IS NULL
                                    THEN
                                        l_gl_record_wise_entry_id
                                    ELSE
                                        i.new_gl_rec_wise_entry_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_gl_rec_wise_entry_id
                                             IS NULL
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
