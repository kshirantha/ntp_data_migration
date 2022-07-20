-- Table DFN_NTP.A01_DB_JOBS_EXECUTION_LOG

CREATE TABLE dfn_ntp.a01_db_jobs_execution_log
(
    a01_id                     NUMBER (20, 0),
    a01_job_id_v07             NUMBER (10, 0),
    a01_execution_type         NUMBER (2, 0),
    a01_start_time             DATE,
    a01_end_time               DATE,
    a01_status                 NUMBER (2, 0),
    a01_manually_executed_by   NUMBER (10, 0),
    a01_narriation             VARCHAR2 (4000)
)
/

-- Constraints for  DFN_NTP.A01_DB_JOBS_EXECUTION_LOG


  ALTER TABLE dfn_ntp.a01_db_jobs_execution_log ADD CONSTRAINT pk_a01 PRIMARY KEY (a01_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.a01_db_jobs_execution_log MODIFY (a01_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a01_db_jobs_execution_log MODIFY (a01_job_id_v07 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a01_db_jobs_execution_log MODIFY (a01_execution_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a01_db_jobs_execution_log MODIFY (a01_start_time NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.A01_DB_JOBS_EXECUTION_LOG

COMMENT ON COLUMN dfn_ntp.a01_db_jobs_execution_log.a01_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.a01_db_jobs_execution_log.a01_execution_type IS
    '1 - Automatic | 2 - Manual'
/
COMMENT ON COLUMN dfn_ntp.a01_db_jobs_execution_log.a01_status IS
    '1 - Fully Completed | 2 - Partially Completed | 3 - Failed'
/
-- End of DDL Script for Table DFN_NTP.A01_DB_JOBS_EXECUTION_LOG
