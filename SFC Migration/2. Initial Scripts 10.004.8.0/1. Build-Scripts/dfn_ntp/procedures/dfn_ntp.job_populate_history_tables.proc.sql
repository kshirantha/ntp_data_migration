CREATE OR REPLACE PROCEDURE dfn_ntp.job_populate_history_tables
IS
    l_dependant_job_status   NUMBER;
    l_dependant_job          VARCHAR (100);
    l_current_job_id         NUMBER;
    l_current_job_log_id     NUMBER;
BEGIN
    SELECT v07_id
      INTO l_current_job_id
      FROM v07_db_jobs
     WHERE v07_job_name = 'POPULATE_HISTORY_TABLES';

    job_sch_verify_job_dependancy (l_dependant_job_status,
                                   l_dependant_job,
                                   l_current_job_id);

    job_sch_insert_job_history (l_current_job_log_id, l_current_job_id);

    IF (l_dependant_job_status > 0)
    THEN
        dfn_ntp.sp_h02_populate_cash ();
        COMMIT;

        dfn_ntp.sp_h01_populate_holding ();
        COMMIT;

        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            1,
            'POPULATE_HISTORY_TABLES Executed Successfully');
    ELSE
        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            3,
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job POPULATE_HISTORY_TABLES Will Not Execute');

        job_sch_send_notification (
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job POPULATE_HISTORY_TABLES Will Not Execute');
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        COMMIT;

        job_sch_update_job_history (l_current_job_id,
                                    l_current_job_log_id,
                                    3,
                                    SUBSTR (SQLERRM, 1, 512));

        job_sch_send_notification (
               'ERROR!!! POPULATE_HISTORY_TABLES Execution Failed -> '
            || SUBSTR (SQLERRM, 1, 512));
END;
/