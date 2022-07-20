CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_file_processing_logs
(
    t81_id,
    file_type,
    m40_id,
    t80_id,
    file_process,
    t81_date,
    t81_date_time,
    t81_log_type,
    log_type,
    t81_description,
    t81_custom_type
)
AS
    SELECT t81.t81_id,
           m40.file_type,
           m40.m40_id,
           t81.t81_batch_id_t80 AS t80_id,
           t80.m40_description AS file_process,
           t81.t81_date,
           TO_CHAR (t81.t81_date, 'MM/DD/YYYY  HH24:MI:SS') AS t81_date_time,
           t81.t81_log_type,
           CASE
               WHEN t81.t81_log_type = 1 THEN 'Info'
               WHEN t81.t81_log_type = 2 THEN 'Success'
               WHEN t81.t81_log_type = 3 THEN 'Error'
           END
               AS log_type,
           t81.t81_description,
           t81.t81_custom_type
      FROM t81_file_processing_log t81
           INNER JOIN vw_t80_file_processing_batches t80
               ON t80.t80_id = t81.t81_batch_id_t80
           INNER JOIN vw_m40_file_procs_job_conf m40
               ON m40.m40_id = t80.t80_config_id_m40
/