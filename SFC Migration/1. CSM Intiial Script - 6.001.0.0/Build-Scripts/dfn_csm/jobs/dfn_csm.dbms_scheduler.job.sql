BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'DFN_CSM.POPULATE_EXECUTION_TABLE',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'BEGIN dfn_csm.pkg_dc_schedule_jobs.sp_populate_exection_dtls; END;',
        start_date        => TRUNC (SYSDATE - 1) + 63 / 96,
        repeat_interval   => 'FREQ=DAILY',
        enabled           => TRUE,
        comments          => 'Execution populate jobs run at 3.45 pm'
    );
	
END;
/