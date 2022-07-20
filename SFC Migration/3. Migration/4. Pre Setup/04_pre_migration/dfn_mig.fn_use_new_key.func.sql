CREATE OR REPLACE FUNCTION fn_use_new_key (p_table_name IN VARCHAR2)
    RETURN NUMBER
IS
    l_query        VARCHAR2 (4000);
    l_use_new_id   NUMBER;
BEGIN
    l_query :=
        'SELECT NVL(MIN(use_new_id), 1)
            FROM dfn_mig.primary_key_usage
        WHERE table_name = ''' || p_table_name || '''';

    EXECUTE IMMEDIATE l_query INTO l_use_new_id;

    RETURN l_use_new_id;
END;
/