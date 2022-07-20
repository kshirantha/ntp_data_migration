CREATE OR REPLACE PROCEDURE dfn_ntp.job_sch_update_job_history (
    p_job_id       IN NUMBER,
    p_log_id       IN NUMBER,
    p_status       IN NUMBER,
    p_narriation   IN VARCHAR2)
IS
BEGIN
    UPDATE a01_db_jobs_execution_log
       SET a01_end_time = SYSDATE,
           a01_status = p_status,
           a01_narriation = p_narriation
     WHERE a01_id = p_log_id;

    IF p_status = 1
    THEN
        UPDATE v07_db_jobs
           SET v07_last_success_date = SYSDATE
         WHERE v07_id = p_job_id;
    END IF;
END;
/
/
