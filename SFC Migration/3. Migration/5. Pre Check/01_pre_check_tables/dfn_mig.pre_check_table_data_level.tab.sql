DECLARE
    l_count   NUMBER := 0;
    l_table   VARCHAR2 (50) := 'pre_check_table_data_level';
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
	target_table          VARCHAR2 (100 BYTE),
    source_table          VARCHAR2 (100 BYTE),
    verify_condition      VARCHAR2 (100 BYTE),
    entity_key            VARCHAR2 (500 BYTE),
    source_value          NUMBER (30, 10),
    target_value          NUMBER (30, 10),
	difference            NUMBER (30, 10)    
    )';
    END IF;
END;
/

TRUNCATE TABLE pre_check_table_data_level;