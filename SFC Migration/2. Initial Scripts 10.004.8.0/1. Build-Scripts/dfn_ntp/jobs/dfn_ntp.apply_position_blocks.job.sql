DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_scheduler_jobs
     WHERE job_name = 'APPLY_POSITION_BLOCKS' AND owner = 'DFN_NTP';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.drop_job (job_name => 'DFN_NTP.APPLY_POSITION_BLOCKS');
    END IF;
END;
/

DECLARE
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.APPLY_POSITION_BLOCKS',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'DECLARE pstat NUMBER (10); pmsg VARCHAR2 (100); BEGIN DFN_NTP.SP_JOB_SCHEDULAR_ACTION(''APPLY_POSITION_BLOCKS'', pstat , pmsg); END;',
        start_date        => TRUNC (SYSDATE) + 1 / 96,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Apply Cash Block At 12.15 AM');
END;
/
