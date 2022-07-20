CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_sp_row_count_query (
    psearchcriteria    VARCHAR2,
    l_qry              VARCHAR2)
    RETURN VARCHAR2
IS
    s2   VARCHAR2 (15000);
BEGIN
    IF (psearchcriteria IS NOT NULL)
    THEN
        s2 :=
               'SELECT COUNT(*) FROM ('
            || l_qry
            || ') WHERE '
            || psearchcriteria;
    ELSE
        s2 := 'SELECT COUNT(*) FROM (' || l_qry || ')';
    END IF;

    RETURN s2;
--EXCEPTION
--    WHEN exception_name
--   THEN
--       statements;
END;
/