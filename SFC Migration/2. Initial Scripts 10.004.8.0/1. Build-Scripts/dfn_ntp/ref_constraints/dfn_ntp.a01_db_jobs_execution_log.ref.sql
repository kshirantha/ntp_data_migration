-- Foreign Key for  DFN_NTP.A01_DB_JOBS_EXECUTION_LOG


  ALTER TABLE dfn_ntp.a01_db_jobs_execution_log ADD CONSTRAINT fk_a01_job_id FOREIGN KEY (a01_job_id_v07)
   REFERENCES dfn_ntp.v07_db_jobs (v07_id) ENABLE NOVALIDATE
/
-- End of REF DDL Script for Table DFN_NTP.A01_DB_JOBS_EXECUTION_LOG
