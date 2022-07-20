DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_scheduler_jobs
     WHERE job_name = 'UPDATE_CASH_ACCOUNTS' AND owner = 'DFN_NTP';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.drop_job (job_name => 'DFN_NTP.UPDATE_CASH_ACCOUNTS');
    END IF;
END;
/

DECLARE
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.UPDATE_CASH_ACCOUNTS',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'DECLARE pstat NUMBER (10); pmsg VARCHAR2 (100); BEGIN DFN_NTP.SP_JOB_SCHEDULAR_ACTION(''UPDATE_CASH_ACCOUNTS'', pstat , pmsg); END;',
        start_date        => TRUNC (SYSDATE) + 93 / 96,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Update Cash Accounts At 11.15 PM');
END;
/