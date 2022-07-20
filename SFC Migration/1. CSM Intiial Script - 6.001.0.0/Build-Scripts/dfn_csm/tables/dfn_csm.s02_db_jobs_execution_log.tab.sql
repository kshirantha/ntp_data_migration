DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.s02_db_jobs_execution_log';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('s02_db_jobs_execution_log');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.s02_db_jobs_execution_log
(
    s02_id               NUMBER (20, 0) NOT NULL,
    s02_job_id           NUMBER (10, 0) NOT NULL,
    s02_execution_type   NUMBER (2, 0) NOT NULL,
    s02_start_time       DATE NOT NULL,
    s02_end_time         DATE,
    s02_status           NUMBER (2, 0),
    s02_narriation       VARCHAR2 (4000 BYTE)
)
/



ALTER TABLE dfn_csm.s02_db_jobs_execution_log
ADD CONSTRAINT s02_pk PRIMARY KEY (s02_id)
USING INDEX
/

COMMENT ON COLUMN dfn_csm.s02_db_jobs_execution_log.s02_execution_type IS
    '1-Automatic, 2-Manual'
/
COMMENT ON COLUMN dfn_csm.s02_db_jobs_execution_log.s02_id IS 'PK'
/
COMMENT ON COLUMN dfn_csm.s02_db_jobs_execution_log.s02_job_id IS
    'FK FROM S18'
/
COMMENT ON COLUMN dfn_csm.s02_db_jobs_execution_log.s02_status IS
    '1-Fully Completed, 2-Partially Completed, 3-Failed'
/
