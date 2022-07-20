DECLARE
    l_oradata      VARCHAR2 (1000);
    l_count        NUMBER (1);
    l_tablespace   VARCHAR2 (100);
BEGIN
    SELECT file_name
      INTO l_oradata
      FROM dba_data_files
     WHERE tablespace_name = 'SYSTEM';

    l_oradata := SUBSTR (l_oradata, 1, LENGTH (l_oradata) - 12);

    l_tablespace := 'DFN_MIG_TS';

    SELECT COUNT (*)
      INTO l_count
      FROM dba_tablespaces
     WHERE tablespace_name = l_tablespace;

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE
            (   'create tablespace '
             || l_tablespace
             || ' datafile '''
             || l_oradata
             || LOWER (l_tablespace)
             || '01.dbf'' size 20m autoextend on');
    END IF;
END;
/
