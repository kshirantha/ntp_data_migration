DECLARE
    l_count    NUMBER := 0;
    l_table    VARCHAR2 (50) := 'map15_transaction_codes_m97';
    l_map_id   VARCHAR2 (50) := '15';
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
        map'
            || l_map_id
            || '_oms_code  VARCHAR2 (10 BYTE),
        map'
            || l_map_id
            || '_ntp_code  VARCHAR2 (10 BYTE),
        map'
            || l_map_id
            || '_name      VARCHAR2 (1000 BYTE)
    )';

        EXECUTE IMMEDIATE
               'ALTER TABLE '
            || l_table
            || ' ADD CONSTRAINT map'
            || l_map_id
            || '_uk 
             UNIQUE (map'
            || l_map_id
            || '_oms_code, map'
            || l_map_id
            || '_ntp_code)
            ';
    END IF;
END;
/