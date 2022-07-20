CREATE OR REPLACE PROCEDURE dfn_ntp.job_oms_cache_update
IS
    l_dependant_job_status   NUMBER;
    l_dependant_job          VARCHAR (100);
    l_current_job_id         NUMBER;
    l_current_job_log_id     NUMBER;
BEGIN
    SELECT v07_id
    INTO l_current_job_id
    FROM v07_db_jobs
    WHERE v07_job_name = 'OMS_CACHE_UPDATE';

    job_sch_verify_job_dependancy (l_dependant_job_status,
                                   l_dependant_job,
                                   l_current_job_id);

    job_sch_insert_job_history (l_current_job_log_id, l_current_job_id);

    IF (l_dependant_job_status > 0)
    THEN
        UPDATE v00_sys_config
        SET v00_value = TO_CHAR (SYSDATE, 'yyyy-MM-dd HH24:MI:SS')
        WHERE v00_key = 'EOD_OMS_CACHE_CLEAR_SCHEDULE_TIME';

        INSERT INTO t58_cache_clear_request (t58_id,
                                             t58_table_id,
                                             t58_store_keys_json,
                                             t58_clear_all,
                                             t58_custom_type,
                                             t58_status,
                                             t58_created_date,
                                             t58_priority,
                                             t58_server_id)
        VALUES (fn_get_next_sequnce ('T58_CACHE_CLEAR_REQUEST'),
                'V00_SYS_CONFIG',
                NULL,
                1, -- t58_clear_all
                1,
                0,
                SYSDATE,
                1,
                NULL);

        COMMIT;
        job_sch_update_job_history (l_current_job_id,
                                    l_current_job_log_id,
                                    1,
                                    'OMS_CACHE_UPDATE Executed Successfully');
    ELSE
        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            3,
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job OMS_CACHE_UPDATE Will Not Execute');

        job_sch_send_notification (
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job OMS_CACHE_UPDATE Will Not Execute');
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
               'ERROR!!! OMS_CACHE_UPDATE Execution Failed -> '
            || SUBSTR (SQLERRM, 1, 512));
END;
/