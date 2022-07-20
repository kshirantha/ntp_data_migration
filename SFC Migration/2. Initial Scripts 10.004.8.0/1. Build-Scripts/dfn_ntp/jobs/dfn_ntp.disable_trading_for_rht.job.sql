DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_scheduler_jobs
     WHERE job_name = 'DISABLE_TRADING_FOR_RHT' AND owner = 'DFN_NTP';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.drop_job (job_name => 'DFN_NTP.DISABLE_TRADING_FOR_RHT');
    END IF;
END;
/

DECLARE
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.DISABLE_TRADING_FOR_RHT',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'DECLARE pstat NUMBER (10); pmsg VARCHAR2 (100); BEGIN DFN_NTP.SP_JOB_SCHEDULAR_ACTION(''DISABLE_TRADING_FOR_RHT'', pstat , pmsg); END;',
        start_date        => TRUNC (SYSDATE) + 12 / 96,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Disable Trading for Tradeable Rights At 3.00 AM');
END;
/