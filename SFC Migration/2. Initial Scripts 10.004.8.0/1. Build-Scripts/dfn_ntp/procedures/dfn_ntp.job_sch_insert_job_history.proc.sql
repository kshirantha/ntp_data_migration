CREATE OR REPLACE PROCEDURE dfn_ntp.job_sch_insert_job_history (
    pkey          OUT NUMBER,
    p_job_id   IN     NUMBER)
IS
BEGIN
    SELECT seq_a01_job.NEXTVAL INTO pkey FROM DUAL;

    INSERT INTO a01_db_jobs_execution_log (a01_id,
                                           a01_job_id_v07,
                                           a01_execution_type,
                                           a01_start_time)
         VALUES (pkey,
                 p_job_id,
                 1,
                 SYSDATE);
END;
/
/
