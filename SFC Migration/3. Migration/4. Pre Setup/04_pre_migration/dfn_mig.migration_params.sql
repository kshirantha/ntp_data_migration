DECLARE
    l_count   NUMBER := 0;
    l_table   VARCHAR2 (20) := 'migration_params';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
            'CREATE TABLE ' || l_table || ' (
    CODE    VARCHAR2 (100 BYTE),
    VALUE   VARCHAR2 (100 BYTE)
    )';
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM migration_params;

    IF (l_count = 0)
    THEN
        INSERT INTO migration_params
             VALUES ('DEFAULT_COUNTRY', '2');

        INSERT INTO migration_params
             VALUES ('DEFAULT_CURRENCY', '19');

        INSERT INTO migration_params
             VALUES ('DEFAULT_CURRENCY_CODE', 'SAR');

        -- After Mapping

        INSERT INTO migration_params
             VALUES ('DEFAULT_EMPLOYEE_TYPE', 1);

        -- After Migration

        INSERT INTO migration_params
             VALUES ('DEFAULT_EXG_CODE', 'TDWL');
    END IF;
END;
/

COMMIT;