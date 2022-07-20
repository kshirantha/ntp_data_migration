DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_scheduler_jobs
     WHERE job_name = 'DAILY_OWNED_HOLDING_B' AND owner = 'DFN_NTP';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.drop_job (job_name => 'DFN_NTP.DAILY_OWNED_HOLDING_B');
    END IF;
END;
/

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.DAILY_OWNED_HOLDING_B',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'DECLARE pstat NUMBER (10); pmsg VARCHAR2 (100); BEGIN DFN_NTP.SP_JOB_SCHEDULAR_ACTION(''DAILY_OWNED_HOLDING_B'', pstat , pmsg); END;',
        start_date        => TRUNC (SYSDATE) + 12 / 96,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Populate Symbol wise holding pattern daily at 3 AM');
END;
/