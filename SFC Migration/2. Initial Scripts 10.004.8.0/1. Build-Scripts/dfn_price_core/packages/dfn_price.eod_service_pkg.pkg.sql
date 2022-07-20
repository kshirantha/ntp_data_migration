
CREATE OR REPLACE PACKAGE DFN_PRICE.EOD_SERVICE_PKG 
IS
    PROCEDURE sp_eod_data;

    PROCEDURE generate_price_data;
END;
/
/


CREATE OR REPLACE PACKAGE BODY DFN_PRICE.EOD_SERVICE_PKG 
IS
    PROCEDURE sp_eod_data
    IS
    BEGIN
        --mubasher_oms.m77_symbols_pkg.sp_idc_symbol_map;
        null;
    END;

    FUNCTION dump_data (p_query       IN VARCHAR2,
                        p_separator   IN VARCHAR2 DEFAULT ',',
                        p_dir         IN VARCHAR2,
                        p_filename    IN VARCHAR2)
        RETURN NUMBER
    IS
        l_output        UTL_FILE.file_type;
        l_thecursor     INTEGER DEFAULT DBMS_SQL.open_cursor;
        l_columnvalue   VARCHAR2 (2000);
        l_status        INTEGER;
        l_colcnt        NUMBER DEFAULT 0;
        l_separator     VARCHAR2 (10) DEFAULT '';
        l_cnt           NUMBER DEFAULT 0;
    BEGIN
        l_output :=
            UTL_FILE.fopen (p_dir,
                            p_filename,
                            'w',
                            32767);
        DBMS_SQL.parse (l_thecursor, p_query, DBMS_SQL.native);

        FOR i IN 1 .. 255
        LOOP
            BEGIN
                DBMS_SQL.define_column (l_thecursor,
                                        i,
                                        l_columnvalue,
                                        2000);
                l_colcnt := i;
            EXCEPTION
                WHEN OTHERS
                THEN
                    IF (SQLCODE = -1007)
                    THEN
                        EXIT;
                    ELSE
                        RAISE;
                    END IF;
            END;
        END LOOP;

        DBMS_SQL.define_column (l_thecursor,
                                1,
                                l_columnvalue,
                                2000);
        l_status := DBMS_SQL.execute (l_thecursor);

        LOOP
            EXIT WHEN (DBMS_SQL.fetch_rows (l_thecursor) <= 0);
            l_separator := '';

            FOR i IN 1 .. l_colcnt
            LOOP
                DBMS_SQL.COLUMN_VALUE (l_thecursor, i, l_columnvalue);
                UTL_FILE.put (l_output, l_separator || l_columnvalue);
                l_separator := p_separator;
            END LOOP;

            UTL_FILE.new_line (l_output);
            l_cnt := l_cnt + 1;
        END LOOP;

        DBMS_SQL.close_cursor (l_thecursor);
        UTL_FILE.fclose (l_output);
        RETURN l_cnt;
    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_SQL.close_cursor (l_thecursor);
            UTL_FILE.fclose (l_output);
            RAISE;
    END;

    PROCEDURE generate_price_data
    IS
        l_numrow     NUMBER;
        l_query      VARCHAR2 (4000) := NULL;
        l_filename   VARCHAR2 (100) := NULL;
    BEGIN
        FOR x IN (  SELECT symbol
                      FROM esp_symbolmap
                     WHERE exchange = 'TDWL'
                  ORDER BY symbol)
        LOOP
            /* Taken todays_closed insttead of prvious_closed - Ref Kurram Ghory
                LAST.PRICE::='' || ROUND(DECODE
            (j.lasttradeprice,0,j.previousclosed,j.lasttradeprice),2)
            */

            l_query :=
                   'SELECT ''SECURITY.MASTER,OFS/I/PROCESS,//,'
                || x.symbol
                || ',LAST.PRICE::='' || ROUND(j.TODAYSCLOSED,2) ||
'',DATE.LAST.PRICE::='' || TO_CHAR(j.lastupdatedtime, ''YYYYMMDD'') ||
'',LOCAL.REF:3:='' || ROUND(j.previousclosed,2)  FROM esp_todays_snapshots
j where j.symbol ='
                || ''''
                || x.symbol
                || ''''
                || ' and j.exchangecode=''TDWL''';
            l_filename :=
                TO_CHAR (SYSDATE, 'YYYYMMDDHHMISS') || x.symbol || '.dfs';
            l_numrow :=
                dump_data (p_query       => l_query,
                           p_separator   => ',',
                           p_dir         => 'PRICE_EXT_DIR',
                           p_filename    => l_filename);
        END LOOP;
    END;
END;
/
/
