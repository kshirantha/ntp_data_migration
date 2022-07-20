CREATE OR REPLACE PACKAGE dfn_ntp.pkg_dc_common2
IS
    TYPE refcursor IS REF CURSOR;

    PROCEDURE sp_show_range (p_view            OUT refcursor,
                             ptableorview          VARCHAR2,
                             psortcolumn           VARCHAR2,
                             prows             OUT INT,
                             pn1                   INT,
                             pn2                   INT,
                             psearchcriteria       VARCHAR2);

    PROCEDURE sp_show_range_row_count (pkey              OUT VARCHAR2,
                                       pdynamictable         VARCHAR2,
                                       psortcolumn           VARCHAR2,
                                       pn1                   INT,
                                       pn2                   INT,
                                       psearchcriteria       VARCHAR2);

    PROCEDURE sp_show_range_dynamic_table (p_view            OUT refcursor,
                                           prows             OUT NUMBER,
                                           pdynamictable         VARCHAR2,
                                           psortcolumn           VARCHAR2,
                                           pn1                   INT,
                                           pn2                   INT,
                                           psearchcriteria       VARCHAR2);


    PROCEDURE sp_exq (psql VARCHAR2);

    TYPE t_array IS TABLE OF VARCHAR2 (4000)
        INDEX BY BINARY_INTEGER;

    FUNCTION split (p_in_string VARCHAR2, p_delim VARCHAR2)
        RETURN t_array;
END;
/
/


CREATE OR REPLACE PACKAGE BODY dfn_ntp.pkg_dc_common2
IS
    PROCEDURE sp_exq (psql VARCHAR2)
    IS
    BEGIN
        EXECUTE IMMEDIATE psql;
    END;

    PROCEDURE sp_show_range (p_view            OUT refcursor,
                             ptableorview          VARCHAR2,
                             psortcolumn           VARCHAR2,
                             prows             OUT INT,
                             pn1                   INT,
                             pn2                   INT,
                             psearchcriteria       VARCHAR2)
    IS
        s1   VARCHAR2 (2000);
        s2   VARCHAR2 (2000);
    BEGIN
        IF (psearchcriteria IS NOT NULL)
        THEN
            s1 := ' where ' || psearchcriteria;
            s2 :=
                   'SELECT count(*) FROM '
                || ptableorview
                || ' where '
                || psearchcriteria;
        ELSE
            s1 := '';
            s2 := 'SELECT count(*) FROM ' || ptableorview;
        END IF;

        IF psortcolumn IS NOT NULL
        THEN
            OPEN p_view FOR
                   'select t2.*
from (select t1.*, rownum rnum
        from (select t3.*, row_number() over(order by '
                || psortcolumn
                || ') runm
              from '
                || ptableorview
                || ' t3'
                || s1
                || ') t1 where rownum <= '
                || pn2
                || ') t2 where rnum >= '
                || pn1;
        ELSE
            OPEN p_view FOR
                   'select t2.* from (select t1.*, rownum rn from (
      select * from '
                || ptableorview
                || s1
                || ') t1 where rownum <= '
                || pn2
                || ') t2 where rn >= '
                || pn1;
        END IF;

        IF (pn1 = 1)
        THEN
            EXECUTE IMMEDIATE s2 INTO prows;
        ELSE
            prows := -2;
        END IF;
    END;

    FUNCTION split (p_in_string VARCHAR2, p_delim VARCHAR2)
        RETURN t_array
    IS
        i         FLOAT := 0;
        pos       FLOAT := 0;
        lv_str    VARCHAR2 (4000) := p_in_string;

        strings   t_array;
    BEGIN
        -- determine first chuck of string
        pos :=
            INSTR (lv_str,
                   p_delim,
                   1,
                   1);

        -- while there are chunks left, loop
        WHILE (pos != 0)
        LOOP
            -- increment counter
            i := i + 1;

            -- create array element for chuck of string

            strings (i) := SUBSTR (lv_str, 1, pos);

            -- remove chunk from string
            lv_str := SUBSTR (lv_str, pos + 1, LENGTH (lv_str));

            -- determine next chunk
            pos :=
                INSTR (lv_str,
                       p_delim,
                       1,
                       1);

            -- no last chunk, add to array
            IF pos = 0
            THEN
                strings (i + 1) := lv_str;
            END IF;
        END LOOP;

        -- return array
        RETURN strings;
    END split;

    PROCEDURE sp_show_range_row_count (pkey              OUT VARCHAR2,
                                       pdynamictable         VARCHAR2,
                                       psortcolumn           VARCHAR2,
                                       pn1                   INT,
                                       pn2                   INT,
                                       psearchcriteria       VARCHAR2)
    IS
        s2   VARCHAR2 (2000);
    BEGIN
        IF (psearchcriteria IS NOT NULL)
        THEN
            s2 :=
                   'SELECT count(*) FROM ( '
                || pdynamictable
                || ' ) where '
                || psearchcriteria;
        ELSE
            s2 := 'SELECT count(*) FROM ( ' || pdynamictable || ' )';
        END IF;

        IF (pn1 = 1)
        THEN
            EXECUTE IMMEDIATE s2 INTO pkey;
        ELSE
            pkey := '-2';
        END IF;
    END;

    PROCEDURE sp_show_range_dynamic_table (p_view            OUT refcursor,
                                           prows             OUT NUMBER,
                                           pdynamictable         VARCHAR2,
                                           psortcolumn           VARCHAR2,
                                           pn1                   INT,
                                           pn2                   INT,
                                           psearchcriteria       VARCHAR2)
    IS
        s1   VARCHAR2 (2000);
        s2   VARCHAR2 (2000);
    BEGIN
        IF (psearchcriteria IS NOT NULL)
        THEN
            s1 := ' where ' || psearchcriteria;
            s2 :=
                   'SELECT count(*) FROM ( '
                || pdynamictable
                || ' ) where '
                || psearchcriteria;
        ELSE
            s1 := '';
            s2 := 'SELECT count(*) FROM ( ' || pdynamictable || ' )';
        END IF;

        IF psortcolumn IS NOT NULL
        THEN
            OPEN p_view FOR
                   'select t2.*
from (select t1.*, rownum rnum
        from (select t3.*, row_number() over(order by '
                || psortcolumn
                || ') runm
              from ( '
                || pdynamictable
                || ' ) t3'
                || s1
                || ') t1 where rownum <= '
                || pn2
                || ') t2 where rnum >= '
                || pn1;
        ELSE
            OPEN p_view FOR
                   'select t2.* from (select t1.*, rownum rn from (
      select * from ('
                || pdynamictable
                || ' ) '
                || s1
                || ') t1 where rownum <= '
                || pn2
                || ') t2 where rn >= '
                || pn1;
        END IF;
    END;
END;
/
/
