CREATE OR REPLACE FUNCTION fn_get_new_entity (
    p_mapping_table   IN VARCHAR2,
    p_old_column      IN VARCHAR2,
    p_new_column      IN VARCHAR2,
    p_old_entity      IN NUMBER)
    RETURN NUMBER
IS
    l_query        VARCHAR2 (4000);
    l_new_entity   NUMBER;
BEGIN
    l_query :=
           'SELECT '
        || p_new_column
        || ' FROM '
        || p_mapping_table
        || ' WHERE '
        || p_old_column
        || ' = '
        || p_old_entity;

    EXECUTE IMMEDIATE l_query INTO l_new_entity;

    RETURN l_new_entity;
END;
/