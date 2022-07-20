DECLARE
    l_count   NUMBER := 0;
    l_table   VARCHAR2 (50) := 'pre_check_table_count_wise';
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
    target_table   VARCHAR2 (100 BYTE),
    source_table   VARCHAR2 (100 BYTE),
    source_count   NUMBER (10, 0),
    error_count    NUMBER (10, 0),
    error_reason   VARCHAR2 (1000 BYTE)
    )';
    END IF;
END;
/

TRUNCATE TABLE pre_check_table_count_wise;