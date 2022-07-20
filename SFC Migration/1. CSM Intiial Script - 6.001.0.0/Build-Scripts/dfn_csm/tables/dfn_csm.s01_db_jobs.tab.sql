DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.s01_db_jobs';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('s01_db_jobs');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.s01_db_jobs
(
    s01_id                  NUMBER (10, 0) NOT NULL,
    s01_job_name            VARCHAR2 (50 BYTE) NOT NULL,
    s01_job_description     VARCHAR2 (255 BYTE),
    s01_dependancy_job_id   NUMBER (10, 0) DEFAULT -1,
    s01_last_success_date   DATE
)
/





ALTER TABLE dfn_csm.s01_db_jobs
ADD CONSTRAINT s01_job_name_uk UNIQUE (s01_job_name)
USING INDEX
/

ALTER TABLE dfn_csm.s01_db_jobs
ADD CONSTRAINT s01_pk PRIMARY KEY (s01_id)
USING INDEX
/

COMMENT ON COLUMN dfn_csm.s01_db_jobs.s01_id IS 'PK'
/
