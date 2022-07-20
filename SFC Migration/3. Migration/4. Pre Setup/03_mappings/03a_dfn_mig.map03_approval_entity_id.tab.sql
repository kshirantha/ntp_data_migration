DECLARE
    l_count    NUMBER := 0;
    l_table    VARCHAR2 (50) := 'map03_approval_entity_id';
    l_map_id   VARCHAR2 (50) := '03';
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
        map03_oms_id          NUMBER (25, 0),
        map03_ntp_id          NUMBER (25, 0),
        map03_name            VARCHAR2 (1000 BYTE),
        map03_mapping_table   VARCHAR2 (1000 BYTE),
        map03_old_column      VARCHAR2 (100 BYTE),
        map03_new_column      VARCHAR2 (100 BYTE),
        map03_type            NUMBER (1, 0)
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
            || '_ntp_id, map'
            || l_map_id
            || '_mapping_table)
            ';

        EXECUTE IMMEDIATE
               'COMMENT ON COLUMN '
            || l_table
            || '.MAP03_TYPE IS '
            || '''0 : Default | 1 : Institution | 2 : Other''';
    END IF;
END;
/