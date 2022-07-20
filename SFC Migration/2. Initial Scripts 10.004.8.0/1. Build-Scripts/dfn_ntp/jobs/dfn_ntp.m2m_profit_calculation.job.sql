DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_scheduler_jobs
     WHERE job_name = 'M2M_PROFIT_CALCULATION' AND owner = 'DFN_NTP';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.drop_job (job_name => 'DFN_NTP.M2M_PROFIT_CALCULATION');
    END IF;
END;
/

DECLARE
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.M2M_PROFIT_CALCULATION',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'DECLARE pstat NUMBER (10); pmsg VARCHAR2 (100); BEGIN DFN_NTP.SP_JOB_SCHEDULAR_ACTION(''M2M_PROFIT_CALCULATION'', pstat , pmsg); END;',
        start_date        => TRUNC (SYSDATE) + 1 / 96,
        repeat_interval   => 'FREQ=HOURLY; INTERVAL=1',
        enabled           => TRUE,
        comments          => 'M2M Profit Calculation at Every 1 Hour');
END;
/
