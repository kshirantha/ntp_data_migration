CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_v07_db_jobs
(
    v07_id,
    v07_job_name,
    v07_job_description,
    v07_dependancy_job_id,
    dependancy_job_name,
    v07_last_success_date
)
AS
    SELECT v07.v07_id,
           v07.v07_job_name,
           v07.v07_job_description,
           v07.v07_dependancy_job_id,
           v07_dependancy.v07_job_name AS dependancy_job_name,
           v07.v07_last_success_date
      FROM     v07_db_jobs v07
           LEFT JOIN
               v07_db_jobs v07_dependancy
           ON v07.v07_dependancy_job_id = v07_dependancy.v07_id;
/
