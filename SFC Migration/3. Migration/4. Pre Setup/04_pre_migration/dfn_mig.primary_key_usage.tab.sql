DECLARE
    l_count   NUMBER := 0;
    l_table   VARCHAR2 (20) := 'primary_key_usage';
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
                table_name    VARCHAR2 (100 BYTE),
                use_new_id    NUMBER (1, 0)
            )';
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM primary_key_usage;

    IF (l_count = 0)
    THEN
        INSERT INTO primary_key_usage
             VALUES ('U01_CUSTOMER', 0);

        INSERT INTO primary_key_usage
             VALUES ('U09_CUSTOMER_LOGIN', 0);

        INSERT INTO primary_key_usage
             VALUES ('M02_INSTITUTE', 0);

        INSERT INTO primary_key_usage
             VALUES ('U17_EMPLOYEE', 0);

        INSERT INTO primary_key_usage
             VALUES ('U06_CASH_ACCOUNT', 0);

        INSERT INTO primary_key_usage
             VALUES ('U07_TRADING_ACCOUNT', 0);

        INSERT INTO primary_key_usage
             VALUES ('T01_ORDER', 0);

        INSERT INTO primary_key_usage
             VALUES ('T20_PENDING_PLEDGE', 0);
    END IF;
END;
/

COMMIT;