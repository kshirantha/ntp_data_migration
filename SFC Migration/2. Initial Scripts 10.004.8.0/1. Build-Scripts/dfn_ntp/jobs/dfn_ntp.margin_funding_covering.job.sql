DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_scheduler_jobs
     WHERE job_name = 'MARGIN_FUNDING_COVERING' AND owner = 'DFN_NTP';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.drop_job (job_name => 'DFN_NTP.MARGIN_FUNDING_COVERING');
    END IF;
END;
/

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.MARGIN_FUNDING_COVERING',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'DECLARE pstat NUMBER (10); pmsg VARCHAR2 (100); BEGIN DFN_NTP.SP_JOB_SCHEDULAR_ACTION(''MARGIN_FUNDING_COVERING'', pstat , pmsg); END;',
        start_date        => TRUNC (SYSDATE) + 19 / 24,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Margin Funding Covering at 7.00 PM');
END;
/

BEGIN
    DBMS_SCHEDULER.drop_job ('DFN_NTP.MARGIN_FUNDING_COVERING');

    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_NTP.MARGIN_FUNDING_COVERING',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'BEGIN JOB_MARGIN_FUNDING_COVERING_B; END;',
        start_date        => TRUNC (SYSDATE) + 19 / 24,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Margin Funding Covering at 7.00 PM');
END;
/
