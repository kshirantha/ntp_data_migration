DECLARE
    l_count   NUMBER := 0;
    l_table   VARCHAR2 (20) := 'error_log';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' (
    mig_table    VARCHAR2 (100 BYTE),
    source_key   VARCHAR2 (4000 BYTE),
    target_key   VARCHAR2 (4000 BYTE),
    error_msg    VARCHAR2 (4000 BYTE),
    mig_action   VARCHAR2 (10 BYTE),
    log_date     DATE DEFAULT SYSDATE
    )';

        EXECUTE IMMEDIATE 'CREATE INDEX idx_error_log
             ON error_log (mig_table ASC)
            ';
    END IF;
END;
/
