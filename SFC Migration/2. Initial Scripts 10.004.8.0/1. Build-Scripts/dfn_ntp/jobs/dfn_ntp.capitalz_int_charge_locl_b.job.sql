DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_scheduler_jobs
     WHERE job_name = 'CAPITALIZE_INT_CHARGES_LOCAL' AND owner = 'DFN_NTP';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.drop_job (job_name => 'DFN_NTP.CAPITALIZE_INT_CHARGES_LOCAL');
    END IF;
END;
/

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.CAPITALIZE_INT_CHARGES_LOCAL',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'DECLARE pstat NUMBER (10); pmsg VARCHAR2 (100); BEGIN DFN_NTP.SP_JOB_SCHEDULAR_ACTION(''CAPITALIZE_INT_CHARGES_LOCAL'', pstat , pmsg); END;',
        start_date        => TRUNC (SYSDATE) + 81 / 96,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Capitalize Interest Charges At 9.45 PM');
END;
/

