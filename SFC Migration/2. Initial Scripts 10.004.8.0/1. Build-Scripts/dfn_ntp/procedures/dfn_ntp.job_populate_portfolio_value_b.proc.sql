CREATE OR REPLACE PROCEDURE dfn_ntp.job_populate_portfolio_value_b
IS
    l_dependant_job_status   NUMBER;
    l_dependant_job          VARCHAR (100);
    l_current_job_id         NUMBER;
    l_current_job_log_id     NUMBER;
BEGIN
    SELECT v07_id
      INTO l_current_job_id
      FROM v07_db_jobs
     WHERE v07_job_name = 'PORTFOLIO_VALUATION_B';

    job_sch_verify_job_dependancy (l_dependant_job_status,
                                   l_dependant_job,
                                   l_current_job_id);

    IF (l_dependant_job_status > 0)
    THEN
        job_sch_insert_job_history (l_current_job_log_id, l_current_job_id);

        INSERT INTO h50_daily_portfolio_value_b (h50_date,
                                                 h50_portfolio_id_u07,
                                                 h50_value)
            SELECT TRUNC (SYSDATE), u07_id, pf_value_with_pledge
              FROM vw_u07_portfolio_value;

        COMMIT;

        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            1,
            'PORTFOLIO_VALUATION_B Executed Successfully');
    ELSE
        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            3,
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job PORTFOLIO_VALUATION_B Will Not Execute');

        job_sch_send_notification (
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job PORTFOLIO_VALUATION_B Will Not Execute');
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
               'ERROR!!! PORTFOLIO_VALUATION_B Execution Failed -> '
            || SUBSTR (SQLERRM, 1, 512));
END;
/
