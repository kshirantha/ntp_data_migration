CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_a01_db_jobs_execution_log
(
    a01_id,
    a01_job_id_v07,
    a01_start_time,
    a01_end_time,
    a01_execution_type,
    a01_narriation,
    a01_status,
    a01_manually_executed_by,
    job_name,
    manually_executed_by_name,
    execution_type,
    status
)
AS
    SELECT a01.a01_id,
           a01.a01_job_id_v07,
           a01.a01_start_time,
           a01.a01_end_time,
           a01.a01_execution_type,
           a01.a01_narriation,
           a01.a01_status,
           a01.a01_manually_executed_by,
           v07_job_names.v07_job_name AS job_name,
           u17_manually_executed_by.u17_full_name
               AS manually_executed_by_name,
           CASE
               WHEN a01.a01_execution_type = 1 THEN 'Automatic'
               WHEN a01.a01_execution_type = 2 THEN 'Manual'
           END
               AS execution_type,
           CASE
               WHEN a01.a01_status = 1 THEN 'Fully Completed'
               WHEN a01.a01_status = 2 THEN 'Partially Completed'
               WHEN a01.a01_status = 3 THEN 'Failed'
           END
               AS status
      FROM a01_db_jobs_execution_log a01
           LEFT JOIN u17_employee u17_manually_executed_by
               ON a01.a01_manually_executed_by =
                      u17_manually_executed_by.u17_id
           LEFT JOIN v07_db_jobs v07_job_names
               ON a01.a01_job_id_v07 = v07_job_names.v07_id;
/
