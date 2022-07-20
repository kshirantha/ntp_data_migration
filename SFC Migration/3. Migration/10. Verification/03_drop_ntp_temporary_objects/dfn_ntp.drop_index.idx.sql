DECLARE
    l_count        NUMBER;
    l_table        VARCHAR2 (50) := 'T02_TRANSACTION_LOG';
    l_index_name   VARCHAR2 (100) := 'IDX_T02_TEMP_MIG';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_indexes
     WHERE UPPER (index_name) = UPPER (l_index_name);

    IF l_count > 0
    THEN
        EXECUTE IMMEDIATE 'DROP INDEX ' || l_index_name;
    END IF;
END;
/