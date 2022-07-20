DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_scheduler_jobs
     WHERE job_name = 'CAPITALIZE_CUSTODY_CHARGES' AND owner = 'DFN_NTP';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.drop_job (job_name => 'DFN_NTP.CAPITALIZE_CUSTODY_CHARGES');
    END IF;
END;
/


DECLARE
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.CAPITALIZE_CUSTODY_CHARGES',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'DECLARE pstat NUMBER (10); pmsg VARCHAR2 (100); BEGIN DFN_NTP.SP_JOB_SCHEDULAR_ACTION(''CAPITALIZE_CUSTODY_CHARGES'', pstat , pmsg); END;',
        start_date        => TRUNC (SYSDATE) + 87 / 96,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Capitalize Custody Charges At 9.45 PM');
END;
/
