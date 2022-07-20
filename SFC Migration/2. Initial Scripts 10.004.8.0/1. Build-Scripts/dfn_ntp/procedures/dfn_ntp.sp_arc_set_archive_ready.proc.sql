CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_set_archive_ready (
    pdate IN DATE DEFAULT SYSDATE)
IS
    l_column_diff     VARCHAR2 (10000);
    l_archive_owner   VARCHAR2 (100) DEFAULT 'DFN_ARC';
    l_archive_date    DATE;
    l_current_date    DATE;
    l_start_date      DATE;
    l_environment     NUMBER;
BEGIN
    l_current_date := TRUNC (pdate);

    SELECT NVL (MAX (v00_value), 1)
      INTO l_environment
      FROM v00_sys_config
     WHERE v00_key = 'ENVIRONMENT';

    UPDATE m38_arc_table_configuration
       SET m38_is_archive_ready = 0;

    FOR c_arc_tables IN (SELECT m38_id,
                                m38_source_table,
                                m38_archive_table,
                                m38_archive_ready_sp_name,
                                m38_archive_days,
                                m38_archive_date_field
                           FROM m38_arc_table_configuration
                          WHERE m38_archive_enabled = 1)
    LOOP
        BEGIN
            l_column_diff := NULL;

            l_archive_date := l_current_date - c_arc_tables.m38_archive_days;

            IF    c_arc_tables.m38_archive_ready_sp_name IS NOT NULL
               OR c_arc_tables.m38_archive_ready_sp_name <> ''
            THEN
                EXECUTE IMMEDIATE
                       'SELECT '
                    || 'MIN('
                    || c_arc_tables.m38_archive_date_field
                    || ')'
                    || ' FROM '
                    || c_arc_tables.m38_source_table
                    INTO l_start_date;

                l_start_date := TRUNC (l_start_date);

                WHILE l_start_date <= l_archive_date
                LOOP
                    EXECUTE IMMEDIATE
                           'BEGIN DFN_NTP.'
                        || c_arc_tables.m38_archive_ready_sp_name
                        || '( pdate => TO_DATE('''
                        || TO_CHAR (l_start_date, 'DD/MM/YYYY')
                        || ''',''DD/MM/YYYY'')'
                        || '); END;';

                    l_start_date := l_start_date + 1;

                    COMMIT;
                END LOOP;
            END IF;

            IF l_environment NOT IN (1, 2)
            THEN
                FOR c_new_cols
                    IN (SELECT column_name,
                               data_type,
                               nullable,
                               data_length,
                               data_precision,
                               data_scale
                          FROM all_tab_columns
                         WHERE     table_name =
                                       UPPER (c_arc_tables.m38_source_table)
                               AND owner = 'DFN_NTP'
                               AND column_name NOT IN
                                       (SELECT column_name
                                          FROM all_tab_columns
                                         WHERE     table_name =
                                                       UPPER (
                                                           c_arc_tables.m38_archive_table)
                                               AND owner = l_archive_owner))
                LOOP
                    EXECUTE IMMEDIATE
                           'ALTER TABLE '
                        || l_archive_owner
                        || '.'
                        || c_arc_tables.m38_archive_table
                        || ' ADD '
                        || c_new_cols.column_name
                        || ' '
                        || c_new_cols.data_type
                        || CASE
                               WHEN c_new_cols.data_type IN
                                        ('CHAR', 'NVARCHAR2', 'VARCHAR2')
                               THEN
                                   '(' || c_new_cols.data_length || ')'
                               WHEN c_new_cols.data_type IN
                                        ('FLOAT', 'LONG', 'NUMBER')
                               THEN
                                      '('
                                   || c_new_cols.data_precision
                                   || ','
                                   || c_new_cols.data_scale
                                   || ')'
                               ELSE
                                   ''
                           END
                        || ' '
                        || CASE c_new_cols.nullable
                               WHEN 'Y' THEN 'NULL '
                               ELSE 'NOT NULL '
                           END;

                    dfn_ntp.sp_arc_update_audit_log (
                        pa14_audit_type         => 1,   --1 - INFO | 2 - ERROR
                        pa14_arc_table_id_m38   => c_arc_tables.m38_id,
                        pa14_status             => 1, --0 - Failed | 1 - Success | 2 - Partially Executed with Errors
                        pa14_narration          =>    'SET_ARCHIVE_READY => '
                                                   || c_arc_tables.m38_source_table
                                                   || ' | New Column ['
                                                   || c_new_cols.column_name
                                                   || ' '
                                                   || c_new_cols.data_type
                                                   || '] Added');
                END LOOP;

                -- sync length
                FOR c_modify_cols
                    IN (SELECT src.column_name,
                               src.data_type,
                               src.data_length,
                               src.data_precision,
                               src.data_scale,
                               src.nullable
                          FROM (SELECT column_name,
                                       data_type,
                                       nullable,
                                       data_length,
                                       data_precision,
                                       data_scale,
                                       owner
                                  FROM all_tab_columns
                                 WHERE     table_name =
                                               UPPER (
                                                   c_arc_tables.m38_source_table)
                                       AND owner = 'DFN_NTP') src,
                               (SELECT column_name,
                                       data_type,
                                       nullable,
                                       data_length,
                                       data_precision,
                                       data_scale,
                                       owner
                                  FROM all_tab_columns
                                 WHERE     table_name =
                                               UPPER (
                                                   c_arc_tables.m38_source_table)
                                       AND owner = l_archive_owner) arc
                         WHERE     src.column_name = arc.column_name
                               AND src.data_length <> arc.data_length)
                LOOP
                    EXECUTE IMMEDIATE
                           'ALTER TABLE '
                        || l_archive_owner
                        || '.'
                        || c_arc_tables.m38_archive_table
                        || ' MODIFY '
                        || c_modify_cols.column_name
                        || ' '
                        || c_modify_cols.data_type
                        || CASE
                               WHEN c_modify_cols.data_type IN
                                        ('CHAR', 'NVARCHAR2', 'VARCHAR2')
                               THEN
                                   '(' || c_modify_cols.data_length || ')'
                               WHEN c_modify_cols.data_type IN
                                        ('FLOAT', 'LONG', 'NUMBER')
                               THEN
                                      '('
                                   || c_modify_cols.data_precision
                                   || ','
                                   || c_modify_cols.data_scale
                                   || ')'
                               ELSE
                                   ''
                           END;

                    dfn_ntp.sp_arc_update_audit_log (
                        pa14_audit_type         => 1,   --1 - INFO | 2 - ERROR
                        pa14_arc_table_id_m38   => c_arc_tables.m38_id,
                        pa14_status             => 1, --0 - Failed | 1 - Success | 2 - Partially Executed with Errors
                        pa14_narration          =>    'SET_ARCHIVE_READY => '
                                                   || c_arc_tables.m38_source_table
                                                   || ' | Column Length ['
                                                   || c_modify_cols.column_name
                                                   || ' '
                                                   || c_modify_cols.data_type
                                                   || CASE
                                                          WHEN c_modify_cols.data_type IN
                                                                   ('CHAR',
                                                                    'NVARCHAR2',
                                                                    'VARCHAR2')
                                                          THEN
                                                                 '('
                                                              || c_modify_cols.data_length
                                                              || ')'
                                                          WHEN c_modify_cols.data_type IN
                                                                   ('FLOAT',
                                                                    'LONG',
                                                                    'NUMBER')
                                                          THEN
                                                                 '('
                                                              || c_modify_cols.data_precision
                                                              || ','
                                                              || c_modify_cols.data_scale
                                                              || ')'
                                                          ELSE
                                                              ''
                                                      END
                                                   || '] Modified');
                END LOOP;

                -- check null
                FOR c_null_cols
                    IN (SELECT src.column_name, src.nullable, src.data_type
                          FROM (SELECT column_name,
                                       nullable,
                                       data_type,
                                       owner
                                  FROM all_tab_columns
                                 WHERE     table_name =
                                               UPPER (
                                                   c_arc_tables.m38_source_table)
                                       AND owner = 'DFN_NTP') src,
                               (SELECT column_name,
                                       nullable,
                                       data_type,
                                       owner
                                  FROM all_tab_columns
                                 WHERE     table_name =
                                               UPPER (
                                                   c_arc_tables.m38_source_table)
                                       AND owner = l_archive_owner) arc
                         WHERE     src.column_name = arc.column_name
                               AND src.nullable <> arc.nullable)
                LOOP
                    EXECUTE IMMEDIATE
                           'ALTER TABLE '
                        || l_archive_owner
                        || '.'
                        || c_arc_tables.m38_archive_table
                        || ' MODIFY '
                        || c_null_cols.column_name
                        || ' '
                        || CASE c_null_cols.nullable
                               WHEN 'Y' THEN 'NULL'
                               ELSE 'NOT NULL '
                           END;

                    dfn_ntp.sp_arc_update_audit_log (
                        pa14_audit_type         => 1,   --1 - INFO | 2 - ERROR
                        pa14_arc_table_id_m38   => c_arc_tables.m38_id,
                        pa14_status             => 1, --0 - Failed | 1 - Success | 2 - Partially Executed with Errors
                        pa14_narration          =>    'SET_ARCHIVE_READY => '
                                                   || c_arc_tables.m38_source_table
                                                   || ' | Column Nullable ['
                                                   || c_null_cols.column_name
                                                   || ' '
                                                   || CASE c_null_cols.nullable
                                                          WHEN 'Y'
                                                          THEN
                                                              'NULL'
                                                          ELSE
                                                              'NOT NULL '
                                                      END
                                                   || '] Modified');
                END LOOP;
            END IF;

            SELECT fn_aggregate_list (data)
              INTO l_column_diff
              FROM (SELECT (   column_name
                            || ' | '
                            || data_type
                            || ' | '
                            || CASE nullable
                                   WHEN 'Y' THEN 'NULLABLE'
                                   ELSE 'NOT NULLABLE'
                               END)
                               AS data
                      FROM all_tab_columns
                     WHERE     table_name = c_arc_tables.m38_source_table
                           AND owner = 'DFN_NTP'
                    MINUS
                    SELECT (   column_name
                            || ' | '
                            || data_type
                            || ' | '
                            || CASE nullable
                                   WHEN 'Y' THEN 'NULLABLE'
                                   ELSE 'NOT NULLABLE'
                               END)
                               AS data
                      FROM all_tab_columns
                     WHERE     table_name = c_arc_tables.m38_archive_table
                           AND owner = l_archive_owner);

            IF l_column_diff IS NOT NULL OR l_column_diff <> ''
            THEN
                UPDATE m38_arc_table_configuration
                   SET m38_is_archive_ready = 0
                 WHERE m38_id = c_arc_tables.m38_id;

                dfn_ntp.sp_arc_update_audit_log (
                    pa14_audit_type         => 2,       --1 - INFO | 2 - ERROR
                    pa14_arc_table_id_m38   => c_arc_tables.m38_id,
                    pa14_status             => 0, --0 - Failed | 1 - Success | 2 - Partially Executed with Errors
                    pa14_narration          =>    'SET_ARCHIVE_READY => '
                                               || c_arc_tables.m38_source_table
                                               || ' | Column Difference ['
                                               || l_column_diff
                                               || '] Found');
            ELSE
                UPDATE m38_arc_table_configuration
                   SET m38_is_archive_ready = 1
                 WHERE m38_id = c_arc_tables.m38_id;

                dfn_ntp.sp_arc_update_audit_log (
                    pa14_audit_type         => 1,       --1 - INFO | 2 - ERROR
                    pa14_arc_table_id_m38   => c_arc_tables.m38_id,
                    pa14_status             => 1, --0 - Failed | 1 - Success | 2 - Partially Executed with Errors
                    pa14_narration          =>    'SET_ARCHIVE_READY => '
                                               || c_arc_tables.m38_source_table
                                               || ' | Ready to archive');
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                dfn_ntp.sp_arc_update_audit_log (
                    pa14_audit_type         => 2,       --1 - INFO | 2 - ERROR
                    pa14_arc_table_id_m38   => c_arc_tables.m38_id,
                    pa14_status             => 0, --0 - Failed | 1 - Success | 2 - Partially Executed with Errors
                    pa14_narration          =>    'SET_ARCHIVE_READY => '
                                               || c_arc_tables.m38_source_table
                                               || ' | '
                                               || SUBSTR (SQLERRM, 1, 512));
        END;
    END LOOP;
END;
/
