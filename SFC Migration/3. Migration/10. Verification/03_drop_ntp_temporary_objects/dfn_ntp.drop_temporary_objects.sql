DECLARE
    l_count   NUMBER := 0;
    l_object   VARCHAR2 (50) := 'truncate_table';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_objects
     WHERE object_name = UPPER (l_object);

    IF (l_count = 1)
    THEN
        EXECUTE IMMEDIATE 'DROP PROCEDURE ' || l_object || '';
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_object   VARCHAR2 (50) := 'sp_stat_gather';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_objects
     WHERE object_name = UPPER (l_object);

    IF (l_count = 1)
    THEN
        EXECUTE IMMEDIATE 'DROP PROCEDURE ' || l_object || '';
    END IF;
END;
/
