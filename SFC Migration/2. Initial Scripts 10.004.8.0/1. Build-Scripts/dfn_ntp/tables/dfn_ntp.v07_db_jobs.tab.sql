-- Table DFN_NTP.V07_DB_JOBS

CREATE TABLE dfn_ntp.v07_db_jobs
(
    v07_id                  NUMBER (10, 0),
    v07_job_name            VARCHAR2 (50),
    v07_job_description     VARCHAR2 (255),
    v07_dependancy_job_id   NUMBER (10, 0) DEFAULT -1,
    v07_last_success_date   DATE
)
/

-- Constraints for  DFN_NTP.V07_DB_JOBS


  ALTER TABLE dfn_ntp.v07_db_jobs ADD CONSTRAINT idx_v07_job_name_uk UNIQUE (v07_job_name)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.v07_db_jobs ADD CONSTRAINT pk_v07 PRIMARY KEY (v07_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.v07_db_jobs MODIFY (v07_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v07_db_jobs MODIFY (v07_job_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v07_db_jobs MODIFY (v07_dependancy_job_id NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.V07_DB_JOBS

COMMENT ON COLUMN dfn_ntp.v07_db_jobs.v07_id IS 'PK'
/
-- End of DDL Script for Table DFN_NTP.V07_DB_JOBS
ALTER TABLE dfn_ntp.v07_db_jobs
 ADD (
  v07_is_one_time NUMBER (1) DEFAULT 1
 )
/
COMMENT ON COLUMN dfn_ntp.v07_db_jobs.v07_is_one_time IS
    'DB job needs to run only one time a day from scheduler'
/

BEGIN
    UPDATE dfn_ntp.v07_db_jobs
       SET v07_is_one_time = 0
     WHERE v07_id IN (17, 26);
    COMMIT;
END;
/
