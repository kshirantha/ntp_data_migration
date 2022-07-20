DECLARE
    l_count    NUMBER := 0;
    l_table    VARCHAR2 (50) := 'map07_city_m06';
    l_map_id   VARCHAR2 (50) := '07';
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
            || '_oms_id        NUMBER (25, 0),
        map'
            || l_map_id
            || '_ntp_id        NUMBER (25, 0),
        map'
            || l_map_id
            || '_name   VARCHAR2 (1000 BYTE)
    )';

        EXECUTE IMMEDIATE
               'ALTER TABLE '
            || l_table
            || ' ADD CONSTRAINT map'
            || l_map_id
            || '_uk 
             UNIQUE (map'
            || l_map_id
            || '_oms_id, map'
            || l_map_id
            || '_ntp_id)
            ';
    END IF;
END;
/