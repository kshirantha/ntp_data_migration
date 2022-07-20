-- Error Log --

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE table_name = UPPER ('ERROR_LOG') AND owner = 'DFN_MIG';

    IF (l_count = 1)
    THEN
        EXECUTE IMMEDIATE 'DROP TABLE DFN_MIG.ERROR_LOG';
    END IF;
END;
/

COMMIT;

DECLARE
    l_count   NUMBER := 0;
BEGIN
    FOR i IN (SELECT *
                FROM all_tables
               WHERE owner = 'DFN_MIG')
    LOOP
        EXECUTE IMMEDIATE 'DELETE FROM ' || i.table_name;
    END LOOP;
END;
/

COMMIT;

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE table_name = UPPER ('MIGRATION_PARAMS') AND owner = 'DFN_MIG';

    IF (l_count = 1)
    THEN
        EXECUTE IMMEDIATE 'DELETE FROM MIGRATION_PARAMS WHERE CODE IN (''BROKERAGE_ID'', ''BROKERAGE_NAME'')';
    END IF;
END;
/

COMMIT;