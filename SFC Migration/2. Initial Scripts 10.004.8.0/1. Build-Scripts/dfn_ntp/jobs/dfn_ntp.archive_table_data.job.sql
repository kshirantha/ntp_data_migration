DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_scheduler_jobs
     WHERE job_name = 'ARCHIVE_TABLE_DATA' AND owner = 'DFN_NTP';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.drop_job (job_name => 'DFN_NTP.ARCHIVE_TABLE_DATA');
    END IF;
END;
/

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.ARCHIVE_TABLE_DATA',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'DECLARE pstat NUMBER (10); pmsg VARCHAR2 (100); BEGIN DFN_NTP.SP_JOB_SCHEDULAR_ACTION(''ARCHIVE_TABLE_DATA'', pstat , pmsg); END;',
        start_date        => TRUNC (SYSDATE) + 1 / 24,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Archive table data based on configurations as 1.00 AM');
END;
/

