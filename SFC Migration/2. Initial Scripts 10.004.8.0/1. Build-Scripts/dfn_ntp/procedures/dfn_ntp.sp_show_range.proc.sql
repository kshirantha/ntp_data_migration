CREATE OR REPLACE PROCEDURE dfn_ntp.sp_show_range (
    p_view            OUT SYS_REFCURSOR,
    ptableorview          VARCHAR2,
    psortcolumn           VARCHAR2,
    prows             OUT INT,
    pn1                   INT,
    pn2                   INT,
    psearchcriteria       VARCHAR2)
IS
    s1            VARCHAR2 (4000);
    s2            VARCHAR2 (4000);
    i_starttime   TIMESTAMP;
BEGIN
    i_starttime := SYSTIMESTAMP;

    IF (psearchcriteria IS NOT NULL)
    THEN
        s1 := ' WHERE ' || psearchcriteria;
        s2 :=
               'SELECT COUNT(*) FROM '
            || ptableorview
            || ' WHERE '
            || psearchcriteria;
    ELSE
        s1 := '';
        s2 := 'SELECT COUNT(*) FROM ' || ptableorview;
    END IF;

    IF psortcolumn IS NOT NULL
    THEN
        OPEN p_view FOR
               'SELECT t2.*
            FROM (SELECT t1.*, rownum rnum
        FROM (SELECT t3.*, row_number() OVER(ORDER BY '
            || psortcolumn
            || ') runm
              FROM '
            || ptableorview
            || ' t3'
            || s1
            || ') t1 WHERE runm <= '
            || pn2
            || ') t2 WHERE runm >= '
            || pn1;
    ELSE
        OPEN p_view FOR
               'SELECT t2.* FROM (SELECT t1.*, rownum rn FROM (
      SELECT * FROM '
            || ptableorview
            || s1
            || ') t1 WHERE rownum <= '
            || pn2
            || ') t2 WHERE rn >= '
            || pn1;
    END IF;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
