-- This dfn_dba user creation script should be run after intial script as nologging_ts is created during intial scripts

DROP USER dfn_dba CASCADE;

DROP TABLESPACE dfn_dba_ts INCLUDING CONTENTS AND DATAFILES;

DECLARE
    l_oradata      VARCHAR2 (1000);
    l_count        NUMBER (1);
    l_tablespace   VARCHAR2 (100);
BEGIN
    SELECT   file_name
      INTO   l_oradata
      FROM   dba_data_files
     WHERE   tablespace_name = 'SYSTEM';

    l_oradata := SUBSTR (l_oradata, 1, LENGTH (l_oradata) - 12);

    l_tablespace := 'DFN_DBA_TS';

    SELECT   COUNT ( * )
      INTO   l_count
      FROM   dba_tablespaces
     WHERE   tablespace_name = l_tablespace;

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE (   'create tablespace '
                           || l_tablespace
                           || ' datafile '''
                           || l_oradata
                           || LOWER (l_tablespace)
                           || '01.dbf'' size 20m autoextend on');
    END IF;
END;
/



CREATE USER dfn_dba IDENTIFIED BY password DEFAULT TABLESPACE dfn_dba_ts
QUOTA UNLIMITED ON dfn_dba_ts QUOTA UNLIMITED ON nologging_ts TEMPORARY TABLESPACE temp;

GRANT CREATE EXTERNAL JOB, CREATE JOB, CREATE MATERIALIZED VIEW, CREATE PUBLIC SYNONYM, CREATE SESSION, CREATE SYNONYM, CREATE VIEW, MANAGE SCHEDULER, RESOURCE, UNLIMITED TABLESPACE TO dfn_dba;

GRANT READ ON DIRECTORY DUMPDIR TO dfn_dba;

GRANT WRITE ON DIRECTORY DUMPDIR TO dfn_dba;

GRANT DBA TO dfn_dba;



GRANT SELECT ON dba_mviews TO dfn_dba;

GRANT SELECT ON dba_ts_quotas TO dfn_dba;

GRANT SELECT ON dba_tablespaces TO dfn_dba;

GRANT SELECT ON dba_source TO dfn_dba;

GRANT SELECT ON dba_directories TO dfn_dba;

GRANT SELECT ON dba_views TO dfn_dba;

GRANT SELECT ON dba_users TO dfn_dba;

GRANT SELECT ON dba_tab_privs TO dfn_dba;

GRANT SELECT ON dba_tab_comments TO dfn_dba;

GRANT SELECT ON dba_tab_columns TO dfn_dba;

GRANT SELECT ON dba_synonyms TO dfn_dba;

GRANT SELECT ON dba_sequences TO dfn_dba;

GRANT SELECT ON dba_sys_privs TO dfn_dba;

GRANT SELECT ON dba_role_privs TO dfn_dba;

GRANT SELECT ON dba_objects TO dfn_dba;

GRANT SELECT ON dba_col_comments TO dfn_dba;


CREATE OR REPLACE PACKAGE dfn_dba.pkg_mdc_utils
    AUTHID CURRENT_USER
IS
    /*
        DOC> Name           : PKG_MDC_UTILS
        DOC> Purpose        : To generate DDLs, table inserts and table datapump exports.
        DOC> Author         : Buddy
        DOC> Date Created   : 20080130-131015
        DOC> Setup          : create or replace directory dumpdir as 'c:\temp';
        DOC>                  grant create any table, select any table to mubasher_dba;
        DOC>                  grant read, write on directory dumpdir to mubasher_dba;
        DOC> Change History : select to_char (sysdate, 'yyyymmdd-hh24miss') from dual;
        DOC>    20080131-123400 : B$TEMP table now holds only the source table structure. No data duplication.
        DOC>    20080212-174121 : Added CLOB, NCLOB and BLOB data type support.
        DOC>    20080521-000518 : Added the DDL extraction routines and replaced the DUMP_CLOB procedure to use DBMS_LOB.
        DOC>    20080801-143102 : Added GEN_DPUMP data loader/unloader. Now this guy handles DATA nicely.
        DOC>                    : GEN_DPUMP is hard coded to use ONLY mubasher_dba schema. Do not bitch about it.
    */
    PROCEDURE gen_inserts (p_owner      IN VARCHAR2,
                           p_table      IN VARCHAR2,
                           p_query      IN VARCHAR2 DEFAULT NULL,
                           p_dir        IN VARCHAR2,
                           p_filename   IN VARCHAR2);

    FUNCTION insert_clob (p_dir IN VARCHAR2, p_filename VARCHAR2)
        RETURN CLOB;

    FUNCTION insert_nclob (p_dir IN VARCHAR2, p_filename VARCHAR2)
        RETURN NCLOB;

    FUNCTION insert_blob (p_dir IN VARCHAR2, p_filename VARCHAR2)
        RETURN BLOB;

    PROCEDURE ddl_master (
        p_owner         IN dba_objects.owner%TYPE,
        p_object_name   IN dba_objects.object_name%TYPE,
        p_object_type   IN dba_objects.object_type%TYPE,
        p_dir           IN dba_directories.directory_name%TYPE);

    PROCEDURE ddl_bulkme;

    PROCEDURE ddl_bulk_schema (p_owner IN dba_objects.owner%TYPE);

    PROCEDURE dump_clob (p_dir        IN VARCHAR2,
                         p_filename   IN VARCHAR2,
                         p_clob       IN CLOB);

    PROCEDURE gen_dpump (p_owner                IN VARCHAR2,
                         p_table                IN VARCHAR2,
                         p_query                IN VARCHAR2 DEFAULT NULL,
                         p_dir                  IN VARCHAR2,
                         p_version              IN VARCHAR2,
                         p_by_pass_dba_privls   IN NUMBER DEFAULT 1 -- 0 : No | 1 : Yes
                                                                   );

    PROCEDURE ddl_tablespace (
        p_tablespace   IN dba_tablespaces.tablespace_name%TYPE,
        p_dir          IN dba_directories.directory_name%TYPE);
END;
/

CREATE OR REPLACE PACKAGE BODY dfn_dba.pkg_mdc_utils
IS
    PROCEDURE ddl_tab_comments (
        p_owner        IN     dba_tab_comments.owner%TYPE,
        p_table_name   IN     dba_tab_comments.table_name%TYPE,
        p_clob            OUT CLOB)
    IS
        l_crlf      VARCHAR2 (10) := CHR (10);
        l_sqlterm   VARCHAR2 (10) := '/';
    BEGIN
        FOR i
            IN (SELECT    'COMMENT ON TABLE '
                       || LOWER (owner || '.' || table_name)
                       || ' IS '''
                       || REPLACE (a.comments, '''', '''''')
                       || ''''
                       || l_crlf
                       || l_sqlterm
                       || l_crlf
                           bsql
                  FROM dba_tab_comments a
                 WHERE     a.owner = p_owner
                       AND a.table_name = p_table_name
                       AND a.comments IS NOT NULL)
        LOOP
            p_clob := p_clob || i.bsql;
        END LOOP;
    END ddl_tab_comments;

    PROCEDURE ddl_col_comments (
        p_owner        IN     dba_tab_comments.owner%TYPE,
        p_table_name   IN     dba_tab_comments.table_name%TYPE,
        p_clob            OUT CLOB)
    IS
        l_crlf      VARCHAR2 (10) := CHR (10);
        l_sqlterm   VARCHAR2 (10) := '/';
    BEGIN
        FOR i
            IN (SELECT    'COMMENT ON COLUMN '
                       || LOWER (
                                 owner
                              || '.'
                              || table_name
                              || '.'
                              || column_name)
                       || ' IS '''
                       || REPLACE (a.comments, '''', '''''')
                       || ''''
                       || l_crlf
                       || l_sqlterm
                       || l_crlf
                           bsql
                  FROM dba_col_comments a
                 WHERE     a.owner = p_owner
                       AND a.table_name = p_table_name
                       AND a.comments IS NOT NULL)
        LOOP
            p_clob := p_clob || i.bsql;
        END LOOP;
    END ddl_col_comments;

    PROCEDURE ddl_grants (
        p_owner        IN     dba_tab_privs.owner%TYPE,
        p_table_name   IN     dba_tab_privs.table_name%TYPE,
        p_clob            OUT CLOB)
    IS
        l_crlf      VARCHAR2 (10) := CHR (10);
        l_sqlterm   VARCHAR2 (10) := '/';
        l_clob      CLOB;
    BEGIN
        FOR i
            IN (SELECT    'GRANT '
                       || LOWER (privilege)
                       || ' ON '
                       || LOWER (table_name)
                       || ' TO '
                       || LOWER (grantee)
                       || DECODE (grantable,
                                  'YES', ' WITH GRANT OPTION',
                                  NULL)
                       || l_crlf
                       || l_sqlterm
                       || l_crlf
                           bsql
                  FROM dba_tab_privs
                 WHERE owner = p_owner AND table_name = p_table_name)
        LOOP
            p_clob := p_clob || i.bsql;
        END LOOP;
    END ddl_grants;

    FUNCTION gen_rand_str
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN LOWER (DBMS_RANDOM.string ('x', 10));
    END;

    FUNCTION insert_blob (p_dir IN VARCHAR2, p_filename VARCHAR2)
        RETURN BLOB
    IS
        l_dest_blob    BLOB;
        l_src_blob     BFILE := BFILENAME (p_dir, p_filename);
        l_dst_offset   NUMBER := 1;
        l_src_offset   NUMBER := 1;
    BEGIN
        DBMS_LOB.createtemporary (l_dest_blob, TRUE);
        DBMS_LOB.open (l_src_blob, DBMS_LOB.lob_readonly);
        DBMS_LOB.loadblobfromfile (
            dest_lob      => l_dest_blob,
            src_bfile     => l_src_blob,
            amount        => DBMS_LOB.getlength (l_src_blob),
            dest_offset   => l_dst_offset,
            src_offset    => l_src_offset);
        DBMS_LOB.close (l_src_blob);
        RETURN l_dest_blob;
    END insert_blob;

    FUNCTION insert_nclob (p_dir IN VARCHAR2, p_filename VARCHAR2)
        RETURN NCLOB
    IS
        l_dest_nclob   NCLOB;
        l_src_nclob    BFILE := BFILENAME (p_dir, p_filename);
        l_dst_offset   NUMBER := 1;
        l_src_offset   NUMBER := 1;
        l_lang_ctx     NUMBER := DBMS_LOB.default_lang_ctx;
        l_warning      NUMBER;
    BEGIN
        DBMS_LOB.createtemporary (l_dest_nclob, TRUE);
        DBMS_LOB.open (l_src_nclob, DBMS_LOB.lob_readonly);
        DBMS_LOB.loadclobfromfile (
            dest_lob       => l_dest_nclob,
            src_bfile      => l_src_nclob,
            amount         => DBMS_LOB.getlength (l_src_nclob),
            dest_offset    => l_dst_offset,
            src_offset     => l_src_offset,
            bfile_csid     => DBMS_LOB.default_csid,
            lang_context   => l_lang_ctx,
            warning        => l_warning);
        DBMS_LOB.close (l_src_nclob);
        RETURN l_dest_nclob;
    END insert_nclob;

    FUNCTION insert_clob (p_dir IN VARCHAR2, p_filename VARCHAR2)
        RETURN CLOB
    IS
        l_dest_clob    CLOB;
        l_src_clob     BFILE := BFILENAME (p_dir, p_filename);
        l_dst_offset   NUMBER := 1;
        l_src_offset   NUMBER := 1;
        l_lang_ctx     NUMBER := DBMS_LOB.default_lang_ctx;
        l_warning      NUMBER;
    BEGIN
        DBMS_LOB.createtemporary (l_dest_clob, TRUE);
        DBMS_LOB.open (l_src_clob, DBMS_LOB.lob_readonly);
        DBMS_LOB.loadclobfromfile (
            dest_lob       => l_dest_clob,
            src_bfile      => l_src_clob,
            amount         => DBMS_LOB.getlength (l_src_clob),
            dest_offset    => l_dst_offset,
            src_offset     => l_src_offset,
            bfile_csid     => DBMS_LOB.default_csid,
            lang_context   => l_lang_ctx,
            warning        => l_warning);
        DBMS_LOB.close (l_src_clob);
        RETURN l_dest_clob;
    END insert_clob;

    PROCEDURE dump_clob (p_dir        IN VARCHAR2,
                         p_filename   IN VARCHAR2,
                         p_clob       IN CLOB)
    IS
        l_chunk_size   PLS_INTEGER := 3000;
        l_file         UTL_FILE.file_type;
    BEGIN
        l_file :=
            UTL_FILE.fopen (p_dir,
                            p_filename,
                            'wb',
                            max_linesize   => 32767);

        FOR i IN 1 .. CEIL (LENGTH (p_clob) / l_chunk_size)
        LOOP
            UTL_FILE.put_raw (
                l_file,
                UTL_RAW.cast_to_raw (
                    SUBSTR (p_clob, (i - 1) * l_chunk_size + 1, l_chunk_size)));
            UTL_FILE.fflush (l_file);
        END LOOP;

        UTL_FILE.fclose (l_file);
    END dump_clob;

    PROCEDURE dump_nclob (p_dir        IN VARCHAR2,
                          p_filename   IN VARCHAR2,
                          p_nclob      IN NCLOB)
    IS
        l_file           UTL_FILE.file_type;
        l_buffer         NVARCHAR2 (32767);
        l_amount         BINARY_INTEGER := 32767;
        l_pos            INTEGER := 1;
        l_nclob_length   NUMBER;
    BEGIN
        l_nclob_length := DBMS_LOB.getlength (p_nclob);
        l_file :=
            UTL_FILE.fopen (p_dir,
                            p_filename,
                            'w',
                            32767);

        WHILE l_pos < l_nclob_length
        LOOP
            DBMS_LOB.read (p_nclob,
                           l_amount,
                           l_pos,
                           l_buffer);
            UTL_FILE.put_nchar (l_file, l_buffer);
            l_pos := l_pos + l_amount;
        END LOOP;

        UTL_FILE.fclose (l_file);
    END;

    PROCEDURE dump_blob (p_dir        IN VARCHAR2,
                         p_filename   IN VARCHAR2,
                         p_blob       IN BLOB)
    IS
        l_file          UTL_FILE.file_type;
        l_buffer        RAW (32767);
        l_amount        BINARY_INTEGER := 32767;
        l_pos           INTEGER := 1;
        l_blob_length   NUMBER;
    BEGIN
        l_blob_length := DBMS_LOB.getlength (p_blob);
        l_file :=
            UTL_FILE.fopen (p_dir,
                            p_filename,
                            'w',
                            32767);

        WHILE l_pos < l_blob_length
        LOOP
            DBMS_LOB.read (p_blob,
                           l_amount,
                           l_pos,
                           l_buffer);
            UTL_FILE.put_raw (l_file, l_buffer, TRUE);
            l_pos := l_pos + l_amount;
        END LOOP;

        UTL_FILE.fclose (l_file);
    END;

    PROCEDURE gen_inserts (p_owner      IN VARCHAR2,
                           p_table      IN VARCHAR2,
                           p_query      IN VARCHAR2 DEFAULT NULL,
                           p_dir        IN VARCHAR2,
                           p_filename   IN VARCHAR2)
    IS
        l_output             UTL_FILE.file_type;
        l_thecursor          INTEGER DEFAULT DBMS_SQL.open_cursor;
        l_columnvalue        VARCHAR2 (32000);
        l_columnvalue_blob   BLOB;
        l_status             INTEGER;
        l_colcnt             NUMBER DEFAULT 0;
        l_separator          VARCHAR2 (10) DEFAULT '';
        l_master_separator   VARCHAR2 (10) := ', ';
        l_cnt                NUMBER DEFAULT 0;
        l_data_type          VARCHAR2 (100);
        l_column_list        VARCHAR2 (4000);
        l_query              VARCHAR2 (4000);
        l_lob_filename       VARCHAR2 (1000);
    BEGIN
        EXECUTE IMMEDIATE
            ('alter session set nls_date_format = ''yyyymmddhh24miss''');

        FOR i IN (SELECT table_name
                    FROM user_tables
                   WHERE table_name = 'B$TEMP')
        LOOP
            EXECUTE IMMEDIATE 'drop table b$temp purge';
        END LOOP;

        --Filter out unsupported data types
        FOR i
            IN (  SELECT column_name
                    FROM all_tab_columns
                   WHERE     owner = p_owner
                         AND table_name = p_table
                         AND data_type NOT IN ('LONG')
                ORDER BY column_id)
        LOOP
            l_column_list := l_column_list || ', ' || i.column_name;
        END LOOP;

        l_column_list := SUBSTR (l_column_list, 3);

        EXECUTE IMMEDIATE
               'create table b$temp as select '
            || l_column_list
            || ' from '
            || p_owner
            || '.'
            || p_table
            || ' where 1 = 2';

        l_query :=
            'select * from ' || p_owner || '.' || p_table || ' ' || p_query;
        l_output :=
            UTL_FILE.fopen (p_dir,
                            p_filename,
                            'w',
                            32767);
        DBMS_SQL.parse (l_thecursor, l_query, DBMS_SQL.native);

        FOR i IN (  SELECT column_id, data_type
                      FROM user_tab_columns
                     WHERE table_name = 'B$TEMP'
                  ORDER BY column_id)
        LOOP
            l_colcnt := i.column_id;

            IF i.data_type = 'BLOB'
            THEN
                DBMS_SQL.define_column (l_thecursor,
                                        i.column_id,
                                        l_columnvalue_blob);
            ELSE
                DBMS_SQL.define_column (l_thecursor,
                                        i.column_id,
                                        l_columnvalue,
                                        2000);
            END IF;
        END LOOP;

        l_status := DBMS_SQL.execute (l_thecursor);

        LOOP
            EXIT WHEN (DBMS_SQL.fetch_rows (l_thecursor) <= 0);
            l_separator := '';
            UTL_FILE.put (
                l_output,
                   'insert into '
                || LOWER (p_owner || '.' || p_table)
                || CHR (10));
            UTL_FILE.put (l_output,
                          '(' || LOWER (l_column_list) || ')' || CHR (10));
            UTL_FILE.put (l_output, 'values ' || CHR (10) || '(');

            FOR i IN 1 .. l_colcnt
            LOOP
                SELECT data_type
                  INTO l_data_type
                  FROM user_tab_columns
                 WHERE table_name = 'B$TEMP' AND column_id = i;

                IF l_data_type NOT IN ('BLOB')
                THEN
                    DBMS_SQL.COLUMN_VALUE (l_thecursor, i, l_columnvalue);

                    IF l_columnvalue IS NULL
                    THEN
                        l_columnvalue := 'NULL';
                    ELSIF l_data_type IN ('VARCHAR2', 'CHAR')
                    THEN
                        l_columnvalue :=
                               ''''
                            || REPLACE (l_columnvalue, '''', '''''')
                            || '''';
                    ELSIF l_data_type IN ('NCHAR', 'NVARCHAR2')
                    THEN
                        l_columnvalue :=
                               'UNISTR('''
                            || REPLACE (ASCIISTR (l_columnvalue),
                                        '''',
                                        '''''')
                            || ''')';
                    ELSIF l_data_type IN ('DATE', 'TIMESTAMP(6)')
                    THEN
                        l_columnvalue :=
                               'TO_DATE('''
                            || TO_CHAR (TO_DATE (l_columnvalue),
                                        'YYYYMMDDHH24MISS')
                            || ''',''YYYYMMDDHH24MISS'')';
                    ELSIF l_data_type = 'CLOB'
                    THEN
                        l_lob_filename := gen_rand_str || '.clob.data';
                        dump_clob (p_dir        => p_dir,
                                   p_filename   => l_lob_filename,
                                   p_clob       => l_columnvalue);
                        l_columnvalue :=
                               'pkg_mdc_utils.insert_clob('''
                            || p_dir
                            || ''','''
                            || l_lob_filename
                            || ''')';
                    ELSIF l_data_type = 'NCLOB'
                    THEN
                        l_lob_filename := gen_rand_str || '.nclob.data';
                        dump_nclob (p_dir        => p_dir,
                                    p_filename   => l_lob_filename,
                                    p_nclob      => l_columnvalue);
                        l_columnvalue :=
                               'pkg_mdc_utils.insert_nclob('''
                            || p_dir
                            || ''','''
                            || l_lob_filename
                            || ''')';
                    END IF;
                ELSIF l_data_type IN ('BLOB')
                THEN
                    DBMS_SQL.COLUMN_VALUE (l_thecursor,
                                           i,
                                           l_columnvalue_blob);

                    IF l_columnvalue_blob IS NULL
                    THEN
                        l_columnvalue := 'NULL';
                    ELSE
                        l_lob_filename := gen_rand_str || '.blob.data';
                        dump_blob (p_dir        => p_dir,
                                   p_filename   => l_lob_filename,
                                   p_blob       => l_columnvalue_blob);
                        l_columnvalue :=
                               'pkg_mdc_utils.insert_blob('''
                            || p_dir
                            || ''','''
                            || l_lob_filename
                            || ''')';
                    END IF;
                END IF;

                UTL_FILE.put (l_output, l_separator || l_columnvalue);
                l_separator := l_master_separator;
            END LOOP;

            UTL_FILE.put (l_output, ')' || CHR (10) || '/' || CHR (10));
            UTL_FILE.new_line (l_output);
            l_cnt := l_cnt + 1;
        END LOOP;

        DBMS_SQL.close_cursor (l_thecursor);
        UTL_FILE.fclose (l_output);

        FOR i IN (SELECT table_name
                    FROM user_tables
                   WHERE table_name = 'B$TEMP')
        LOOP
            EXECUTE IMMEDIATE 'drop table b$temp purge';
        END LOOP;
    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_SQL.close_cursor (l_thecursor);
            UTL_FILE.fclose (l_output);
            DBMS_OUTPUT.put_line (l_columnvalue);

            FOR i IN (SELECT table_name
                        FROM user_tables
                       WHERE table_name = 'B$TEMP')
            LOOP
                EXECUTE IMMEDIATE 'drop table b$temp purge';
            END LOOP;

            RAISE;
    END gen_inserts;

    PROCEDURE gen_dpump (p_owner                IN VARCHAR2,
                         p_table                IN VARCHAR2,
                         p_query                IN VARCHAR2 DEFAULT NULL,
                         p_dir                  IN VARCHAR2,
                         p_version              IN VARCHAR2,
                         p_by_pass_dba_privls   IN NUMBER DEFAULT 1 -- 0 : No | 1 : Yes
                                                                   )
    IS
        row_count           NUMBER := 0;
        l_str               CLOB;
        l_count             NUMBER := 0;
        l_file_exists       BOOLEAN := FALSE;
        l_file_length       NUMBER := 0;
        l_block_size        NUMBER := 0;
        l_file_name         VARCHAR2 (400)
                                := LOWER (p_owner || '.' || p_table || '.dat');
        l_et_clob           CLOB;
        l_clob              CLOB;
        l_user              all_users.username%TYPE;
        l_user_dba_status   NUMBER;
        e_exception_name    EXCEPTION;
        PRAGMA EXCEPTION_INIT (e_exception_name, -20120);
    BEGIN
        BEGIN
            SELECT USER INTO l_user FROM DUAL;

            SELECT COUNT (1)
              INTO l_user_dba_status
              FROM user_role_privs
             WHERE granted_role = 'DBA';

            IF (p_by_pass_dba_privls = 0 AND l_user_dba_status < 1)
            THEN
                RAISE e_exception_name;
            END IF;
        EXCEPTION
            WHEN e_exception_name
            THEN
                raise_application_error (-20120,
                                         'User should have DBA privileges');
        END;

        --Clean up code
        SELECT COUNT (*)
          INTO l_count
          FROM user_tables
         WHERE table_name = 'E_TMP';

        IF l_count = 1
        THEN
            EXECUTE IMMEDIATE 'drop table e_tmp';
        END IF;

        UTL_FILE.fgetattr (p_dir,
                           l_file_name,
                           l_file_exists,
                           l_file_length,
                           l_block_size);

        IF l_file_exists
        THEN
            UTL_FILE.fremove (p_dir, l_file_name);
        END IF;

        l_str :=
               'create table e_tmp organization external ( type oracle_datapump default directory '
            || p_dir
            || ' access parameters ( version '''
            || p_version
            || ''')'
            || ' location ('''
            || l_file_name
            || ''')) as select * from '
            || p_owner
            || '.'
            || p_table
            || ' '
            || p_query;

        EXECUTE IMMEDIATE DBMS_LOB.SUBSTR (l_str, 32765, 1);

        l_clob :=
               '
whenever sqlerror exit
set echo off
set define off
set sqlblanklines on
set sqlt off

declare
        e_exception_name exception;
        pragma exception_init(e_exception_name,-20120);
        l_user all_users.username%type;
        l_user_dba_status  NUMBER;

begin
        select user into l_user from dual;
end;
'
            || CHR (47)
            || '

declare
  l_count number;
begin
  select count(*) into l_count from user_objects where object_name = ''E_TMP'' ;

  if l_count = 1
  then
     execute immediate ''drop table '
            || 'e_tmp'';
  end if;
end;
'
            || CHR (47)
            || '
';

        SELECT REPLACE (
                   REPLACE (
                       REPLACE (
                           DBMS_METADATA.get_ddl ('TABLE', 'E_TMP', l_user),
                           '"' || l_user || '".',
                           ''),
                       'NOT NULL ENABLE',
                       ''),
                   ';',
                   '')
          INTO l_et_clob
          FROM DUAL;

        l_clob := l_clob || l_et_clob || CHR (10) || '/' || CHR (10);
        l_clob :=
               l_clob
            || '

begin
  insert into '
            || LOWER (p_owner || '.' || p_table)
            || ' select * from e_tmp;

  commit;
end;
'
            || CHR (47)
            || '

declare
  l_count number;
begin
  select count(*) into l_count from user_objects where object_name = ''E_TMP'' ;

  if l_count = 1
  then
     execute immediate ''drop table '
            || 'e_tmp'';
  end if;
end;
'
            || CHR (47)
            || '

set sqlt on

';
        dump_clob (p_dir        => p_dir,
                   p_filename   => l_file_name || '.sql',
                   p_clob       => l_clob);

        EXECUTE IMMEDIATE 'drop table e_tmp';
    END gen_dpump;

    PROCEDURE ddl_tab (p_owner        IN all_tables.owner%TYPE,
                       p_table_name   IN all_tables.table_name%TYPE,
                       p_dir          IN all_directories.directory_name%TYPE)
    IS
        b_iot_type              all_tables.iot_type%TYPE;
        l_clob                  CLOB;
        l_tab                   CLOB;
        l_tab_grants            CLOB;
        l_tab_comments          CLOB;
        l_tab_col_comments      CLOB;
        l_tab_constraints       CLOB;
        l_tab_ref_constraints   CLOB;
        l_tab_idx               CLOB;
        l_object_type           all_objects.object_type%TYPE := 'TABLE';
        ex_object_not_found2    EXCEPTION;
        PRAGMA EXCEPTION_INIT (ex_object_not_found2, -31608);
    BEGIN
        SELECT iot_type
          INTO b_iot_type
          FROM all_tables
         WHERE owner = p_owner AND table_name = p_table_name;

        IF NVL (b_iot_type, 'TABLE') != 'IOT_OVERFLOW'
        THEN
            DBMS_METADATA.set_transform_param (
                DBMS_METADATA.session_transform,
                'STORAGE',
                FALSE);
            DBMS_METADATA.set_transform_param (
                DBMS_METADATA.session_transform,
                'SEGMENT_ATTRIBUTES',
                FALSE);
            DBMS_METADATA.set_transform_param (
                DBMS_METADATA.session_transform,
                'CONSTRAINTS_AS_ALTER',
                TRUE);
            DBMS_METADATA.set_transform_param (
                DBMS_METADATA.session_transform,
                'SQLTERMINATOR',
                TRUE);
            DBMS_METADATA.set_transform_param (
                DBMS_METADATA.session_transform,
                'PRETTY',
                TRUE);
            DBMS_METADATA.set_transform_param (
                DBMS_METADATA.session_transform,
                'CONSTRAINTS',
                FALSE);
            DBMS_METADATA.set_transform_param (
                DBMS_METADATA.session_transform,
                'REF_CONSTRAINTS',
                FALSE);

            SELECT DBMS_METADATA.get_ddl ('TABLE', p_table_name, p_owner)
              INTO l_tab
              FROM DUAL;

            BEGIN
                SELECT DBMS_METADATA.get_dependent_ddl ('OBJECT_GRANT',
                                                        p_table_name,
                                                        p_owner)
                  INTO l_tab_grants
                  FROM DUAL;
            EXCEPTION
                WHEN ex_object_not_found2
                THEN
                    l_tab_grants := NULL;
            END;

            BEGIN
                SELECT DBMS_METADATA.get_dependent_ddl ('COMMENT',
                                                        p_table_name,
                                                        p_owner)
                  INTO l_tab_comments
                  FROM DUAL;
            EXCEPTION
                WHEN ex_object_not_found2
                THEN
                    l_tab_comments := NULL;
            END;

            BEGIN
                SELECT DBMS_METADATA.get_dependent_ddl ('INDEX',
                                                        p_table_name,
                                                        p_owner)
                  INTO l_tab_idx
                  FROM DUAL;
            EXCEPTION
                WHEN ex_object_not_found2
                THEN
                    l_tab_idx := NULL;
            END;

            BEGIN
                SELECT DBMS_METADATA.get_dependent_ddl ('CONSTRAINT',
                                                        p_table_name,
                                                        p_owner)
                  INTO l_tab_constraints
                  FROM DUAL;
            EXCEPTION
                WHEN ex_object_not_found2
                THEN
                    l_tab_constraints := NULL;
            END;

            BEGIN
                SELECT DBMS_METADATA.get_dependent_ddl ('REF_CONSTRAINT',
                                                        p_table_name,
                                                        p_owner)
                  INTO l_tab_ref_constraints
                  FROM DUAL;
            EXCEPTION
                WHEN ex_object_not_found2
                THEN
                    l_tab_ref_constraints := NULL;
            END;

            l_clob :=
                   l_tab
                || l_tab_idx
                || l_tab_constraints
                || l_tab_ref_constraints
                || l_tab_grants
                || l_tab_comments --|| l_tab_col_comments
                                 ;
            dump_clob (p_dir,
                       LOWER (p_owner || '.' || p_table_name || '.tab.sql'),
                       l_clob);
        END IF;
    END ddl_tab;

    PROCEDURE ddl_seq (
        p_owner           IN dba_sequences.sequence_owner%TYPE,
        p_sequence_name   IN dba_sequences.sequence_name%TYPE,
        p_dir             IN dba_directories.directory_name%TYPE)
    IS
        l_clob      CLOB;
        l_crlf      VARCHAR2 (10) := CHR (10);
        l_tab       VARCHAR2 (10) := '  ';
        l_sqlterm   VARCHAR2 (10) := '/';
        l_grants    CLOB;
    BEGIN
        FOR i
            IN (SELECT    'CREATE SEQUENCE '
                       || LOWER (sequence_name)
                       || l_crlf
                       || l_tab
                       || ' INCREMENT BY '
                       || a.increment_by
                       || l_crlf
                       || l_tab
                       || ' START WITH '
                       || TO_CHAR (a.min_value + 1)
                       || l_crlf
                       || l_tab
                       || ' MINVALUE '
                       || a.min_value
                       || l_crlf
                       || l_tab
                       || ' MAXVALUE '
                       || a.max_value
                       || l_crlf
                       || l_tab
                       || DECODE (a.cycle_flag, 'Y', ' CYCLE ', ' NOCYCLE')
                       || l_crlf
                       || l_tab
                       || DECODE (a.order_flag, 'Y', ' ORDER ', ' NOORDER ')
                       || l_crlf
                       || l_tab
                       || CASE
                              WHEN a.cache_size > 0
                              THEN
                                  ' CACHE ' || a.cache_size
                              ELSE
                                  ' NOCACHE '
                          END
                       || l_crlf
                       || l_sqlterm
                           bsql
                  FROM dba_sequences a
                 WHERE     a.sequence_owner = p_owner
                       AND a.sequence_name = p_sequence_name)
        LOOP
            ddl_grants (p_owner, p_sequence_name, l_grants);
            l_clob := i.bsql || l_crlf || l_grants;
        END LOOP;

        dump_clob (p_dir,
                   LOWER (p_owner || '.' || p_sequence_name || '.seq.sql'),
                   l_clob);
    END ddl_seq;

    PROCEDURE ddl_proc (
        p_owner            IN dba_source.owner%TYPE,
        p_procedure_name   IN dba_source.name%TYPE,
        p_dir              IN dba_directories.directory_name%TYPE)
    IS
        l_clob      CLOB := 'CREATE OR REPLACE ';
        l_sqlterm   VARCHAR2 (10) := '/';
        l_grants    CLOB;
        l_crlf      VARCHAR2 (10) := CHR (10);
    BEGIN
        FOR i
            IN (  SELECT *
                    FROM dba_source
                   WHERE     owner LIKE p_owner
                         AND TYPE = 'PROCEDURE'
                         AND name = p_procedure_name
                ORDER BY line)
        LOOP
            l_clob := l_clob || i.text;
        END LOOP;

        l_clob := l_clob || l_crlf || l_sqlterm;
        ddl_grants (p_owner, p_procedure_name, l_grants);
        l_clob := l_clob || l_crlf || l_grants;
        dump_clob (p_dir,
                   LOWER (p_owner || '.' || p_procedure_name || '.proc.sql'),
                   l_clob);
    END ddl_proc;

    PROCEDURE ddl_pkg (
        p_owner          IN dba_source.owner%TYPE,
        p_package_name   IN dba_source.name%TYPE,
        p_dir            IN dba_directories.directory_name%TYPE)
    IS
        l_clob_pkg   CLOB := 'CREATE OR REPLACE ';
        l_clob_pkb   CLOB := 'CREATE OR REPLACE ';
        l_clob       CLOB;
        l_sqlterm    VARCHAR2 (10) := '/';
        l_count      NUMBER := 0; --Used for a sanity check.
        l_crlf       VARCHAR2 (10) := CHR (10);
        l_grants     CLOB;
    BEGIN
        --Get the SPEC
        FOR i
            IN (  SELECT *
                    FROM dba_source
                   WHERE     owner LIKE p_owner
                         AND TYPE = 'PACKAGE'
                         AND name = p_package_name
                ORDER BY line)
        LOOP
            l_clob_pkg := l_clob_pkg || i.text;
            l_count := l_count + 1;
        END LOOP;

        l_clob_pkg := l_clob_pkg || l_crlf || l_sqlterm;

        IF l_count = 0
        THEN
            l_clob_pkg := NULL;
        END IF;

        --Initialize
        l_count := 0;

        --Get the BODY
        FOR i
            IN (  SELECT *
                    FROM dba_source
                   WHERE     owner LIKE p_owner
                         AND TYPE = 'PACKAGE BODY'
                         AND name = p_package_name
                ORDER BY line)
        LOOP
            l_clob_pkb := l_clob_pkb || i.text;
            l_count := l_count + 1;
        END LOOP;

        l_clob_pkb := l_clob_pkb || l_crlf || l_sqlterm;

        IF l_count = 0
        THEN
            l_clob_pkb := NULL;
        END IF;

        l_clob := l_clob_pkg || l_crlf || l_crlf || l_clob_pkb;
        ddl_grants (p_owner, p_package_name, l_grants);
        l_clob := l_clob || l_crlf || l_grants;
        dump_clob (p_dir,
                   LOWER (p_owner || '.' || p_package_name || '.pkg.sql'),
                   l_clob);
    END ddl_pkg;

    PROCEDURE ddl_trig (
        p_owner          IN dba_source.owner%TYPE,
        p_trigger_name   IN dba_source.name%TYPE,
        p_dir            IN dba_directories.directory_name%TYPE)
    IS
        l_clob      CLOB := 'CREATE OR REPLACE ';
        l_sqlterm   VARCHAR2 (10) := '/';
        l_crlf      VARCHAR2 (10) := CHR (10);
    BEGIN
        FOR i
            IN (  SELECT *
                    FROM dba_source
                   WHERE     owner LIKE p_owner
                         AND TYPE = 'TRIGGER'
                         AND name = p_trigger_name
                ORDER BY line)
        LOOP
            l_clob := l_clob || i.text;
        END LOOP;

        l_clob := l_clob || l_crlf || l_sqlterm;
        dump_clob (p_dir,
                   LOWER (p_owner || '.' || p_trigger_name || '.trig.sql'),
                   l_clob);
    END ddl_trig;

    PROCEDURE ddl_mview (
        p_owner        IN all_users.username%TYPE,
        p_mview_name   IN dba_mviews.mview_name%TYPE,
        p_dir          IN dba_directories.directory_name%TYPE)
    IS
        l_crlf      VARCHAR2 (10) := CHR (10);
        l_sqlterm   VARCHAR2 (10) := '/';
        l_clob      CLOB;
    BEGIN
        DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                           'STORAGE',
                                           FALSE);
        DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                           'SEGMENT_ATTRIBUTES',
                                           FALSE);
        DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                           'CONSTRAINTS_AS_ALTER',
                                           TRUE);
        DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                           'SQLTERMINATOR',
                                           TRUE);
        DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform,
                                           'PRETTY',
                                           TRUE);

        FOR i IN (SELECT *
                    FROM dba_mviews
                   WHERE owner = p_owner AND mview_name = p_mview_name)
        LOOP
            SELECT DBMS_METADATA.get_ddl ('MATERIALIZED_VIEW',
                                          i.mview_name,
                                          i.owner)
              INTO l_clob
              FROM DUAL;
        END LOOP;

        dump_clob (p_dir,
                   LOWER (p_owner || '.' || p_mview_name || '.mview.sql'),
                   l_clob);
    END;

    PROCEDURE ddl_view (p_owner       IN all_users.username%TYPE,
                        p_view_name   IN dba_views.view_name%TYPE,
                        p_dir         IN dba_directories.directory_name%TYPE)
    IS
        l_crlf          VARCHAR2 (10) := CHR (10);
        l_sqlterm       VARCHAR2 (10) := '/';
        l_column_list   CLOB;
        l_clob          CLOB
            :=    'CREATE OR REPLACE FORCE VIEW '
               || LOWER (p_owner)
               || '.'
               || LOWER (p_view_name)
               || ' ('
               || l_crlf;
        l_grants        CLOB;
        l_comments      CLOB;
    BEGIN
        FOR i
            IN (  SELECT    '   '
                         || CASE
                                WHEN     a.column_name = UPPER (a.column_name)
                                     AND INSTR (a.column_name, '/') = 0
                                THEN
                                    LOWER (a.column_name)
                                ELSE
                                    '"' || a.column_name || '"'
                            END
                             column_name
                    FROM dba_tab_columns a
                   WHERE a.owner = p_owner AND a.table_name = p_view_name
                ORDER BY a.column_id)
        LOOP
            l_column_list := l_column_list || i.column_name || ',' || l_crlf;
        END LOOP;

        l_column_list := SUBSTR (l_column_list, 1, LENGTH (l_column_list) - 2);
        l_clob := l_clob || l_column_list || ' )' || l_crlf || 'AS ' || l_crlf;

        FOR i IN (SELECT *
                    FROM dba_views
                   WHERE owner = p_owner AND view_name = p_view_name)
        LOOP
            l_clob := l_clob || i.text;
        END LOOP;

        l_clob := l_clob || l_crlf || l_sqlterm;
        ddl_grants (p_owner, p_view_name, l_grants);
        ddl_tab_comments (p_owner, p_view_name, l_comments);
        l_clob := l_clob || l_crlf || l_grants || l_crlf || l_comments;
        dump_clob (p_dir,
                   LOWER (p_owner || '.' || p_view_name || '.view.sql'),
                   l_clob);
    END;

    PROCEDURE ddl_syno (
        p_owner          IN dba_source.owner%TYPE,
        p_synonym_name   IN dba_synonyms.synonym_name%TYPE,
        p_dir            IN dba_directories.directory_name%TYPE)
    IS
        l_crlf      VARCHAR2 (10) := CHR (10);
        l_sqlterm   VARCHAR2 (10) := '/';
        l_clob      CLOB;
    BEGIN
        FOR i
            IN (SELECT    'CREATE OR REPLACE SYNONYM '
                       || LOWER (owner)
                       || '.'
                       || LOWER (synonym_name)
                       || ' FOR '
                       || LOWER (table_owner)
                       || '.'
                       || LOWER (table_name)
                       || l_crlf
                       || l_sqlterm
                           bsql
                  FROM dba_synonyms
                 WHERE owner = p_owner AND synonym_name = p_synonym_name)
        LOOP
            l_clob := i.bsql;
        END LOOP;

        dump_clob (p_dir,
                   LOWER (p_owner || '.' || p_synonym_name || '.syno.sql'),
                   l_clob);
    END;

    PROCEDURE ddl_func (
        p_owner           IN dba_source.owner%TYPE,
        p_function_name   IN dba_source.name%TYPE,
        p_dir             IN dba_directories.directory_name%TYPE)
    IS
        l_clob      CLOB := 'CREATE OR REPLACE ';
        l_grants    CLOB;
        l_sqlterm   VARCHAR2 (10) := '/';
        l_crlf      VARCHAR2 (10) := CHR (10);
    BEGIN
        FOR i
            IN (  SELECT *
                    FROM dba_source
                   WHERE     owner LIKE p_owner
                         AND TYPE = 'FUNCTION'
                         AND name = p_function_name
                ORDER BY line)
        LOOP
            l_clob := l_clob || i.text;
        END LOOP;

        l_clob := l_clob || l_crlf || l_sqlterm;
        ddl_grants (p_owner, p_function_name, l_grants);
        l_clob := l_clob || l_crlf || l_grants;
        dump_clob (p_dir,
                   LOWER (p_owner || '.' || p_function_name || '.func.sql'),
                   l_clob);
    END ddl_func;

    PROCEDURE ddl_type (p_owner       IN dba_source.owner%TYPE,
                        p_type_name   IN dba_source.name%TYPE,
                        p_dir         IN dba_directories.directory_name%TYPE)
    IS
        l_crlf      VARCHAR2 (10) := CHR (10);
        l_sqlterm   VARCHAR2 (10) := '/';
        l_clob      CLOB;
    BEGIN
        FOR i
            IN (  SELECT    DECODE (line, 1, 'CREATE OR REPLACE ', '  ')
                         || REGEXP_REPLACE (text, '( ){2,}', ' ')
                             bsql
                    FROM dba_source
                   WHERE     owner = p_owner
                         AND TYPE LIKE 'TYPE'
                         AND name = p_type_name
                ORDER BY line)
        LOOP
            l_clob := l_clob || i.bsql;
        END LOOP;

        l_clob := l_clob || l_crlf || l_sqlterm;
        dump_clob (p_dir,
                   LOWER (p_owner || '.' || p_type_name || '.type.sql'),
                   l_clob);
    END;

    PROCEDURE ddl_master (
        p_owner         IN dba_objects.owner%TYPE,
        p_object_name   IN dba_objects.object_name%TYPE,
        p_object_type   IN dba_objects.object_type%TYPE,
        p_dir           IN dba_directories.directory_name%TYPE)
    IS
    BEGIN
        IF p_object_type = 'SEQUENCE'
        THEN
            ddl_seq (p_owner, p_object_name, p_dir);
        ELSIF p_object_type = 'PROCEDURE'
        THEN
            ddl_proc (p_owner, p_object_name, p_dir);
        ELSIF p_object_type = 'PACKAGE'
        THEN
            ddl_pkg (p_owner, p_object_name, p_dir);
        ELSIF p_object_type = 'TRIGGER'
        THEN
            ddl_trig (p_owner, p_object_name, p_dir);
        ELSIF p_object_type = 'MATERIALIZED VIEW'
        THEN
            ddl_mview (p_owner, p_object_name, p_dir);
        ELSIF p_object_type = 'TABLE'
        THEN
            ddl_tab (p_owner, p_object_name, p_dir);
        ELSIF p_object_type = 'VIEW'
        THEN
            ddl_view (p_owner, p_object_name, p_dir);
        ELSIF p_object_type = 'SYNONYM'
        THEN
            ddl_syno (p_owner, p_object_name, p_dir);
        ELSIF p_object_type = 'FUNCTION'
        THEN
            ddl_func (p_owner, p_object_name, p_dir);
        ELSIF p_object_type = 'TYPE'
        THEN
            ddl_type (p_owner, p_object_name, p_dir);
        ELSIF p_object_type IN ('LOB', 'PACKAGE BODY', 'INDEX')
        THEN
            NULL;
        ELSE
            DBMS_OUTPUT.put_line (
                   'DDL-NotImplemented-'
                || p_owner
                || '.'
                || p_object_name
                || '.'
                || p_object_type);
        END IF;
    END;

    PROCEDURE ddl_user (p_user   IN dba_users.username%TYPE,
                        p_dir    IN dba_directories.directory_name%TYPE)
    IS
        l_crlf       VARCHAR2 (10) := CHR (10);
        l_sqlterm    VARCHAR2 (10) := '/';
        l_clob       CLOB;
        l_sysprivs   CLOB;
        l_tabprivs   CLOB;
        l_defts      dba_tablespaces.tablespace_name%TYPE;
        l_tempts     dba_tablespaces.tablespace_name%TYPE;
    BEGIN
        l_clob := 'create user ' || p_user || ' identified by password';

        SELECT default_tablespace
          INTO l_defts
          FROM dba_users
         WHERE username = p_user;

        l_clob := l_clob || ' default tablespace ' || l_defts || l_crlf;

        FOR i IN (SELECT tablespace_name
                    FROM dba_ts_quotas
                   WHERE username = p_user)
        LOOP
            l_clob :=
                l_clob || 'quota unlimited on ' || i.tablespace_name || ' ';
        END LOOP;

        SELECT temporary_tablespace
          INTO l_tempts
          FROM dba_users
         WHERE username = p_user;

        l_clob :=
               l_clob
            || 'temporary tablespace '
            || l_tempts
            || ';'
            || l_crlf
            || l_crlf;

        FOR i IN (SELECT privilege
                    FROM dba_sys_privs
                   WHERE grantee = p_user
                  UNION
                  SELECT granted_role
                    FROM dba_role_privs
                   WHERE grantee = p_user)
        LOOP
            l_sysprivs := l_sysprivs || ' ' || i.privilege || ',';
        END LOOP;

        IF (LENGTH (l_sysprivs) > 0)
        THEN
            l_sysprivs := TRIM (TRAILING ',' FROM l_sysprivs);
            l_clob :=
                l_clob || 'grant' || l_sysprivs || ' to ' || p_user || ';';
        END IF;

        l_clob := l_clob || l_crlf || l_crlf;

        FOR i IN (SELECT privilege, table_name
                    FROM dba_tab_privs
                   WHERE grantee = p_user AND owner = 'SYS')
        LOOP
            IF (i.privilege = 'READ' OR i.privilege = 'WRITE')
            THEN
                l_tabprivs :=
                       l_tabprivs
                    || 'grant '
                    || i.privilege
                    || ' on directory '
                    || i.table_name
                    || ' to '
                    || p_user
                    || ';'
                    || l_crlf;
            ELSE
                l_tabprivs :=
                       l_tabprivs
                    || 'grant '
                    || i.privilege
                    || ' on '
                    || i.table_name
                    || ' to '
                    || p_user
                    || ';'
                    || l_crlf;
            END IF;
        END LOOP;

        l_clob := l_clob || l_tabprivs;

        l_clob := l_clob || l_crlf;
        dump_clob (p_dir,
                   LOWER ('sys' || '.' || p_user || '.user.sql'),
                   LOWER (l_clob));
    END;

    PROCEDURE ddl_tablespace (
        p_tablespace   IN dba_tablespaces.tablespace_name%TYPE,
        p_dir          IN dba_directories.directory_name%TYPE)
    IS
        l_crlf       VARCHAR2 (10) := CHR (10);
        l_sqlterm    VARCHAR2 (10) := '/';
        l_clob       CLOB;
        l_sysprivs   CLOB;
        l_tabprivs   CLOB;
        l_defts      dba_tablespaces.tablespace_name%TYPE;
        l_tempts     dba_tablespaces.tablespace_name%TYPE;
    BEGIN
        l_clob := 'set serveroutput on

declare
    l_oradata varchar2(1000);
    l_count number(1);
    l_tablespace varchar2(100);
begin

    select file_name into l_oradata
          from dba_data_files
         where tablespace_name = ''SYSTEM'';

    l_oradata := substr(l_oradata,1,length(l_oradata)-12);

';
        l_clob :=
               l_clob
            || '    l_tablespace := '''
            || p_tablespace
            || ''';'
            || l_crlf;
        l_clob :=
               l_clob
            || l_crlf
            || '    select count(*) into l_count
      from dba_tablespaces
     where tablespace_name = l_tablespace;

    if l_count = 0 then
        execute immediate (''create tablespace ''||l_tablespace|| '' datafile ''''''||l_oradata || lower(l_tablespace)||''01.dbf'''' size 100m autoextend on'');
    end if;

end;
/';


        l_clob := l_clob || l_crlf;
        dump_clob (p_dir,
                   LOWER ('sys' || '.' || p_tablespace || '.tbsp.sql'),
                   l_clob);
    END;

    PROCEDURE ddl_bulkme
    IS
    BEGIN
        FOR i IN (SELECT username
                    FROM dba_users
                   WHERE username LIKE ('MUBASHER_%'))
        LOOP
            ddl_user (p_user => i.username, p_dir => 'DUMPDIR');


            FOR j IN (SELECT tablespace_name
                        FROM dba_ts_quotas
                       WHERE username = i.username)
            LOOP
                ddl_tablespace (j.tablespace_name, 'DUMPDIR');
            END LOOP;
        END LOOP;
    END ddl_bulkme;

    PROCEDURE ddl_bulk_schema (p_owner IN dba_objects.owner%TYPE)
    IS
    BEGIN
        FOR i IN (SELECT *
                    FROM dba_objects
                   WHERE owner = p_owner)
        LOOP
            ddl_master (p_owner         => i.owner,
                        p_object_name   => i.object_name,
                        p_object_type   => i.object_type,
                        p_dir           => 'DUMPDIR');
        END LOOP;

        ddl_user (p_user => p_owner, p_dir => 'DUMPDIR');

        FOR i IN (SELECT tablespace_name
                    FROM dba_ts_quotas
                   WHERE username = p_owner)
        LOOP
            ddl_tablespace (i.tablespace_name, 'DUMPDIR');
        END LOOP;
    END ddl_bulk_schema;
END;
/