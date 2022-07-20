DECLARE
    l_count        NUMBER;
    l_table        VARCHAR2 (50) := 'T02_TRANSACTION_LOG';
    l_index_name   VARCHAR2 (100) := 'IDX_T02_TEMP_MIG';
    l_index        VARCHAR2 (100)
                       := '(T02_CASH_ACNT_ID_U06, TRUNC (T02_CREATE_DATE))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_indexes
     WHERE UPPER (index_name) = UPPER (l_index_name);

    IF l_count > 0
    THEN
        EXECUTE IMMEDIATE 'DROP INDEX ' || l_index_name;
    END IF;

    EXECUTE IMMEDIATE
        'CREATE INDEX ' || l_index_name || ' ON ' || l_table || l_index;
END;
/