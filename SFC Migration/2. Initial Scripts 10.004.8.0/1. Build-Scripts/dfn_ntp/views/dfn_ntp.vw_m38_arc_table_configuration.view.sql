CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m38_arc_table_configuration
(
    m38_id,
    m38_source_table,
    m38_archive_table,
    m38_archive_sequence,
    m38_archive_enabled,
    m38_archive_date_field,
    m38_minimum_archive_days,
    m38_filter_expression,
    m38_last_success_arc_date,
    m38_is_archive_ready,
    m38_archive_ready_sp_name,
    archive_enabled
)
AS
    SELECT m38_id,
           m38_source_table,
           m38_archive_table,
           m38_archive_sequence,
           m38_archive_enabled,
           m38_archive_date_field,
           m38_minimum_archive_days,
           m38_filter_expression,
           m38_last_success_arc_date,
           m38_is_archive_ready,
           m38_archive_ready_sp_name,
           CASE m38_archive_enabled WHEN 1 THEN 'YES' ELSE 'NO' END
               AS archive_enabled
      FROM m38_arc_table_configuration
/
