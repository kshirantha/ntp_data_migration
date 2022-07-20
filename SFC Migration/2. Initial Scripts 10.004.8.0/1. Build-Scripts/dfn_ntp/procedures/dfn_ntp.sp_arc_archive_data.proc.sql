CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_archive_data (
    pdate IN DATE DEFAULT SYSDATE)
IS
    l_current_date        DATE;
    l_archive_date        DATE;
    l_start_date          DATE;
    l_name_columns        VARCHAR2 (5000);
    l_filter_expression   VARCHAR2 (1000);
    l_archive_owner       VARCHAR2 (100) DEFAULT 'DFN_ARC';
BEGIN
    l_current_date := TRUNC (pdate);

    FOR c_arc_tables
        IN (  SELECT m38_id,
                     m38_source_table,
                     m38_archive_table,
                     m38_archive_date_field,
                     m38_archive_days,
                     m38_filter_expression
                FROM m38_arc_table_configuration
               WHERE m38_is_archive_ready = 1 AND m38_archive_enabled = 1
            ORDER BY m38_archive_sequence)
    LOOP
        BEGIN
            l_name_columns := '';

            l_archive_date :=
                TO_DATE (l_current_date - c_arc_tables.m38_archive_days,
                         'DD-MM-YYYY');

            EXECUTE IMMEDIATE
                   'SELECT '
                || 'MIN('
                || c_arc_tables.m38_archive_date_field
                || ')'
                || ' FROM '
                || c_arc_tables.m38_source_table
                INTO l_start_date;

            l_start_date := TRUNC (l_start_date);

            dfn_ntp.sp_arc_get_columns (
                ptable           => c_arc_tables.m38_archive_table,
                powner           => 'DFN_ARC',
                p_name_columns   => l_name_columns);

            l_filter_expression :=
                CASE
                    WHEN c_arc_tables.m38_filter_expression IS NOT NULL
                    THEN
                        ' AND ' || c_arc_tables.m38_filter_expression
                    ELSE
                        ''
                END;

            WHILE l_start_date <= l_archive_date
            LOOP
                EXECUTE IMMEDIATE
                       'INSERT INTO '
                    || l_archive_owner
                    || '.'
                    || c_arc_tables.m38_archive_table
                    || ' ('
                    || l_name_columns
                    || ') ( SELECT '
                    || l_name_columns
                    || ' FROM DFN_NTP.'
                    || c_arc_tables.m38_source_table
                    || ' WHERE '
                    || c_arc_tables.m38_archive_date_field
                    || ' <= TO_DATE('''
                    || TO_CHAR (l_start_date, 'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY'') + 0.99999'
                    || l_filter_expression
                    || ')';

                EXECUTE IMMEDIATE
                       'DELETE FROM DFN_NTP.'
                    || c_arc_tables.m38_source_table
                    || ' WHERE '
                    || c_arc_tables.m38_archive_date_field
                    || ' <= TO_DATE('''
                    || TO_CHAR (l_start_date, 'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY'') + 0.99999'
                    || l_filter_expression;

                l_start_date := l_start_date + 1;

                COMMIT;
            END LOOP;

            dfn_ntp.sp_arc_update_audit_log (
                pa14_audit_type         => 1,           --1 - INFO | 2 - ERROR
                pa14_arc_table_id_m38   => c_arc_tables.m38_id,
                pa14_status             => 1, --0 - Failed | 1 - Success | 2 - Partially Executed with Errors
                pa14_narration          =>    'ARCHIVE_DATA => '
                                           || c_arc_tables.m38_source_table
                                           || ' | Archive completed');

            UPDATE m38_arc_table_configuration m38
               SET m38.m38_last_success_arc_date = l_archive_date
             WHERE m38_id = c_arc_tables.m38_id;
        EXCEPTION
            WHEN OTHERS
            THEN
                ROLLBACK;
                dfn_ntp.sp_arc_update_audit_log (
                    pa14_audit_type         => 2,       --1 - INFO | 2 - ERROR
                    pa14_arc_table_id_m38   => c_arc_tables.m38_id,
                    pa14_status             => 0, --0 - Failed | 1 - Success | 2 - Partially Executed with Errors
                    pa14_narration          =>    'ARCHIVE_DATA => '
                                               || c_arc_tables.m38_source_table
                                               || ' | '
                                               || SUBSTR (SQLERRM, 1, 512));
                COMMIT;
        END;
    END LOOP;
END;
/
