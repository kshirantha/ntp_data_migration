CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_sp_data_query (
    psearchcriteria    VARCHAR2,
    l_qry              VARCHAR2,
    psortby            VARCHAR2,
    ptorownumber       NUMBER,
    pfromrownumber     NUMBER)
    RETURN VARCHAR2
IS
    s1   VARCHAR2 (15000);
BEGIN
    IF (psearchcriteria IS NOT NULL)
    THEN
        s1 := ' WHERE ' || psearchcriteria;
    ELSE
        s1 := '';
    END IF;

    IF (pfromrownumber IS NOT NULL)
    THEN
        IF psortby IS NOT NULL
        THEN
            s1 :=
                   'SELECT t2.*
FROM (SELECT t1.*, rownum rnum
        FROM (SELECT t3.*, row_number() OVER(ORDER BY '
                || psortby
                || ') runm
              FROM ('
                || l_qry
                || ') t3'
                || s1
                || ') t1 WHERE rownum <= '
                || ptorownumber
                || ') t2 WHERE rnum >= '
                || pfromrownumber;
        ELSE
            s1 :=
                   'SELECT t2.* FROM (SELECT t1.*, rownum rn FROM (
      SELECT * FROM ('
                || l_qry
                || ')'
                || s1
                || ') t1 WHERE rownum <= '
                || ptorownumber
                || ') t2 WHERE rn >= '
                || pfromrownumber;
        END IF;
    ELSE
        IF psortby IS NOT NULL
        THEN
            s1 :=
                   'SELECT * FROM ('
                || l_qry
                || ' ) '
                || s1
                || ' ORDER BY '
                || psortby;
        ELSE
            s1 := 'SELECT * FROM (' || l_qry || ' ) ' || s1;
        END IF;
    END IF;

    RETURN s1;
--EXCEPTION
--   WHEN exception_name
--   THEN
--       statements;
END;
/