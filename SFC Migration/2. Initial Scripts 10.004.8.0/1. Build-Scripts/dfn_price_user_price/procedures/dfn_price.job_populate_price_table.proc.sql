CREATE OR REPLACE PROCEDURE dfn_price.job_populate_price_table
IS
    l_dependant_job_status   NUMBER;
    l_dependant_job          VARCHAR (100);
    l_current_job_id         NUMBER;
    l_current_job_log_id     NUMBER;
BEGIN
    SELECT v07_id
      INTO l_current_job_id
      FROM dfn_ntp.v07_db_jobs
     WHERE v07_job_name = 'POPULATE_PRICE_TABLE';

    dfn_ntp.job_sch_verify_job_dependancy (l_dependant_job_status,
                                           l_dependant_job,
                                           l_current_job_id);

    dfn_ntp.job_sch_insert_job_history (l_current_job_log_id,
                                        l_current_job_id);

    IF (l_dependant_job_status > 0)
    THEN
        sp_esp_eod ();

        COMMIT;

        dfn_ntp.job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            1,
            'POPULATE_PRICE_TABLE Executed Successfully');
    ELSE
        dfn_ntp.job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            3,
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job POPULATE_PRICE_TABLE Will Not Execute');

        dfn_ntp.job_sch_send_notification (
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job POPULATE_PRICE_TABLE Will Not Execute');
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        COMMIT;

        dfn_ntp.job_sch_update_job_history (l_current_job_id,
                                            l_current_job_log_id,
                                            3,
                                            SUBSTR (SQLERRM, 1, 512));

        dfn_ntp.job_sch_send_notification (
               'ERROR!!! POPULATE_PRICE_TABLE Execution Failed -> '
            || SUBSTR (SQLERRM, 1, 512));
END;
/

DROP PROCEDURE dfn_price.job_populate_price_table
/