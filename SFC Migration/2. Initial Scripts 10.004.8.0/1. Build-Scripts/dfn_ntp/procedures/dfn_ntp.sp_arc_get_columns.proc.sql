CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_get_columns (
    ptable           IN     VARCHAR2,
    powner           IN     VARCHAR2 DEFAULT 'DFN_ARC',
    p_name_columns      OUT VARCHAR2)
IS
    l_columns   VARCHAR2 (32000) := ' ';
BEGIN
    FOR c_column IN (  SELECT column_name, data_type, nullable
                         FROM all_tab_columns
                        WHERE table_name = ptable AND owner = powner
                     ORDER BY column_id)
    LOOP
        IF l_columns = ' '
        THEN
            l_columns := c_column.column_name;
        ELSE
            l_columns := l_columns || ', ' || c_column.column_name;
        END IF;

        p_name_columns := l_columns;
    END LOOP;
END;
/
