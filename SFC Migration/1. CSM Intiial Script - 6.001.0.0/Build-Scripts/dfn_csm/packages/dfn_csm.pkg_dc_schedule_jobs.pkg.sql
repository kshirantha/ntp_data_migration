CREATE OR REPLACE PACKAGE dfn_csm.pkg_dc_schedule_jobs
IS
    PROCEDURE update_job_history (ps02_id           IN NUMBER,
                                  pstatus           IN NUMBER,
                                  ps02_narriation   IN VARCHAR2);

    PROCEDURE verify_job_dependancy (pstatus OUT NUMBER, ps02_id IN NUMBER);

    PROCEDURE sp_populate_exection_dtls;

    PROCEDURE insert_job_history (pkey OUT NUMBER, ps02_job_id IN NUMBER);
END;                                                           -- Package spec
/



CREATE OR REPLACE PACKAGE BODY dfn_csm.pkg_dc_schedule_jobs
IS
    PROCEDURE update_job_history (ps02_id           IN NUMBER,
                                  pstatus           IN NUMBER,
                                  ps02_narriation   IN VARCHAR2)
    IS
    BEGIN
        UPDATE s02_db_jobs_execution_log s02
           SET s02.s02_end_time = SYSDATE,
               s02_status = pstatus,
               s02_narriation = ps02_narriation
         WHERE s02_id = ps02_id;
    END;

    PROCEDURE verify_job_dependancy (pstatus OUT NUMBER, ps02_id IN NUMBER)
    IS
        l_s01_dep_job_id   NUMBER;
        l_s02_job_log_id   NUMBER;
    BEGIN
        SELECT a.s01_dependancy_job_id
          INTO l_s01_dep_job_id
          FROM s01_db_jobs a
         WHERE s01_id = ps02_id;

        IF (l_s01_dep_job_id > 0)
        THEN
            BEGIN
                SELECT MAX (a.s02_id)
                  INTO l_s02_job_log_id
                  FROM s02_db_jobs_execution_log a
                 WHERE     a.s02_job_id = ps02_id
                       AND TRUNC (s02_start_time) = TRUNC (SYSDATE)
                       AND s02_status = 1;

                pstatus := 1;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    pstatus := -1;                        -- dependacy not ran
            END;
        ELSE
            pstatus := 1;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            pstatus := 1;                                     -- no dependancy
    END;


    PROCEDURE sp_populate_exection_dtls
    IS
        l_s02_job_log_id       NUMBER;
        l_s02_dep_job_status   NUMBER;
    BEGIN
        pkg_dc_schedule_jobs.verify_job_dependancy (l_s02_dep_job_status, 1);

        IF (l_s02_dep_job_status > 0)
        THEN
            pkg_dc_schedule_jobs.insert_job_history (l_s02_job_log_id, 1);
            pkg_dc_execution_summary.sp_populate_exection_dtls;
            pkg_dc_schedule_jobs.update_job_history (l_s02_job_log_id, 1, '');
            COMMIT;
        ELSE
            DBMS_OUTPUT.put_line (
                'Dependancy job was not ran, Current job will not execute');
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            pkg_dc_schedule_jobs.update_job_history (
                l_s02_job_log_id,
                3,
                SUBSTR (SQLERRM, 1, 512));
            COMMIT;
    END;

    PROCEDURE insert_job_history (pkey OUT NUMBER, ps02_job_id IN NUMBER)
    IS
    BEGIN
        SELECT seq_s02_id.NEXTVAL INTO pkey FROM DUAL;

        INSERT INTO s02_db_jobs_execution_log (s02_id,
                                               s02_job_id,
                                               s02_execution_type,
                                               s02_start_time)
             VALUES (pkey,
                     ps02_job_id,
                     1,
                     SYSDATE);
    END;
END;
/
