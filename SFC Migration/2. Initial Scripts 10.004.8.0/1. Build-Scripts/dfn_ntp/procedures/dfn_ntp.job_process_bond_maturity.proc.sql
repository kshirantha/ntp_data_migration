CREATE OR REPLACE PROCEDURE dfn_ntp.job_process_bond_maturity
IS
    l_dependant_job_status   NUMBER;
    l_dependant_job          VARCHAR (100);
    l_current_job_id         NUMBER;
    l_current_job_log_id     NUMBER;
    l_v07_job_description    v07_db_jobs.v07_job_description%TYPE;
BEGIN
    SELECT v07_id, v07_job_description
      INTO l_current_job_id, l_v07_job_description
      FROM v07_db_jobs
     WHERE v07_job_name = 'BOND_MATURITY';

    job_sch_verify_job_dependancy (l_dependant_job_status,
                                   l_dependant_job,
                                   l_current_job_id);
    job_sch_insert_job_history (l_current_job_log_id, l_current_job_id);

    IF (l_dependant_job_status > 0)
    THEN
        dfn_ntp.sp_process_bond_maturity (l_date => func_get_eod_date);
        COMMIT;

        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            1,
            l_v07_job_description || ' Executed Successfully');
    ELSE
        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            3,
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job '
            || l_v07_job_description
            || ' Will Not Execute');

        job_sch_send_notification (
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job '
            || l_v07_job_description
            || ' Will Not Execute');
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        job_sch_update_job_history (l_current_job_id,
                                    l_current_job_log_id,
                                    3,
                                    SUBSTR (SQLERRM, 1, 512));

        job_sch_send_notification (
               'ERROR!!! '
            || l_v07_job_description
            || ' Execution Failed -> '
            || SUBSTR (SQLERRM, 1, 512));

        COMMIT;
END;
/
