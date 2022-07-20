CREATE OR REPLACE PROCEDURE dfn_ntp.job_sch_verify_job_dependancy (
    p_status             OUT NUMBER,
    p_dependant_job      OUT VARCHAR2,
    p_job_id          IN     NUMBER)
IS
    l_dependant_job_id       NUMBER;
    l_dependant_job_status   NUMBER;
    l_dependant_job          VARCHAR2 (100);
    l_job_log_id             NUMBER;
BEGIN
    SELECT MAX (v07_dependancy_job_id), MAX (v07_job_name)
      INTO l_dependant_job_id, l_dependant_job
      FROM v07_db_jobs
     WHERE v07_id = p_job_id;

    IF (l_dependant_job_id > 0)
    THEN
        BEGIN
            SELECT MAX (v07_job_name)
              INTO l_dependant_job
              FROM v07_db_jobs
             WHERE v07_id = l_dependant_job_id;

            p_dependant_job := l_dependant_job;

            SELECT MAX (a01_id)
              INTO l_job_log_id
              FROM a01_db_jobs_execution_log
             WHERE     a01_job_id_v07 = l_dependant_job_id
                   AND TRUNC (a01_start_time) <= TRUNC (SYSDATE);

            IF l_job_log_id > 0
            THEN
                SELECT a01_status
                  INTO l_dependant_job_status
                  FROM a01_db_jobs_execution_log
                 WHERE a01_id = l_job_log_id;

                IF l_dependant_job_status = 1
                THEN
                    p_status := 1;
                ELSE
                    p_status := -1;
                END IF;
            ELSE
                p_status := -1;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                p_status := -1;
        END;
    ELSE
        p_status := 1;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        p_status := -1;
END;
/