CREATE OR REPLACE PROCEDURE dfn_ntp.job_update_incentive
IS
   l_dependant_job_status   NUMBER;
   l_dependant_job          VARCHAR (100);
   l_current_job_id         NUMBER;
   l_current_job_log_id     NUMBER;
BEGIN
   SELECT v07_id
     INTO l_current_job_id
     FROM v07_db_jobs
    WHERE v07_job_name = 'UPDATE_INCENTIVE';

   job_sch_verify_job_dependancy (l_dependant_job_status,
                                  l_dependant_job,
                                  l_current_job_id);
   job_sch_insert_job_history (l_current_job_log_id, l_current_job_id);

   IF (l_dependant_job_status > 0)
   THEN
      sp_update_incentive_for_dealrs ();
      sp_update_incentive_for_ib ();
      sp_update_incentive_for_rm ();
      sp_update_incentive_for_refcus ();
      COMMIT;

      job_sch_update_job_history (l_current_job_id,
                                  l_current_job_log_id,
                                  1,
                                  'UPDATE_INCENTIVE Executed Successfully');
   ELSE
      job_sch_update_job_history (
         l_current_job_id,
         l_current_job_log_id,
         3,
            'ERROR!!! Dependancy Job '
         || l_dependant_job
         || ' Not Executed! Current Job UPDATE_INCENTIVE Will Not Execute');

      job_sch_send_notification (
            'ERROR!!! Dependancy Job '
         || l_dependant_job
         || ' Not Executed! Current Job UPDATE_INCENTIVE Will Not Execute');
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
            'ERROR!!! UPDATE_INCENTIVE Execution Failed -> '
         || SUBSTR (SQLERRM, 1, 512));
END;
/