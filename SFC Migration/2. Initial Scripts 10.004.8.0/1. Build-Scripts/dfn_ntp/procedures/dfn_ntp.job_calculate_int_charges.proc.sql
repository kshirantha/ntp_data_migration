CREATE OR REPLACE PROCEDURE dfn_ntp.job_calculate_int_charges
IS
    l_dependant_job_status   NUMBER;
    l_dependant_job          VARCHAR (100);
    l_current_job_id         NUMBER;
    l_current_job_log_id     NUMBER;
BEGIN
    SELECT v07_id
      INTO l_current_job_id
      FROM v07_db_jobs
     WHERE v07_job_name = 'CALCULATE_INT_CHARGES';

    job_sch_verify_job_dependancy (l_dependant_job_status,
                                   l_dependant_job,
                                   l_current_job_id);

    IF (l_dependant_job_status > 0)
    THEN
        job_sch_insert_job_history (l_current_job_log_id, l_current_job_id);

        sp_calc_incident_od_interest;

        sp_calc_incident_with_interest;

        sp_calculate_margin_interest ();

        COMMIT;

        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            1,
            'CALCULATE_INT_CHARGES Executed Successfully');
    ELSE
        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            3,
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job CALCULATE_INT_CHARGES Will Not Execute');

        job_sch_send_notification (
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job CALCULATE_INT_CHARGES Will Not Execute');
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
               'ERROR!!! CALCULATE_INT_CHARGES Execution Failed -> '
            || SUBSTR (SQLERRM, 1, 512));
END;
/
