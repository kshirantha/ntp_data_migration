SET PAGESIZE 300
SET LINESIZE 4000
SET FEEDBACK OFF
SET HEADING OFF
SPOOL CLEAN.SQL

SELECT    'ALTER TABLE '
       || owner
       || '.'
       || table_name
       || ' drop CONSTRAINT '
       || constraint_name
       || ';'
  FROM user_constraints
 WHERE constraint_type = 'R'
/

SELECT 'drop table ' || object_name || ';'
  FROM user_objects
 WHERE object_type = 'TABLE' AND object_name NOT LIKE '%IOT_OVER%'
/

SELECT 'drop SEQUENCE ' || object_name || ';'
  FROM user_objects
 WHERE object_type = 'SEQUENCE'
/

SELECT 'drop FUNCTION ' || object_name || ';'
  FROM user_objects
 WHERE object_type = 'FUNCTION'
/

SELECT 'drop TYPE ' || object_name || ';'
  FROM user_objects
 WHERE object_type = 'TYPE'
/

SELECT 'drop view ' || object_name || ';'
  FROM user_objects
 WHERE object_type = 'VIEW'
/

SELECT 'drop procedure ' || object_name || ';'
  FROM user_objects
 WHERE object_type = 'PROCEDURE'
/

SELECT 'drop package ' || object_name || ';'
  FROM user_objects
 WHERE object_type = 'PACKAGE'
/

/* For SFC This is Not Allowed
SELECT 'BEGIN DBMS_SCHEDULER.drop_job (job_name => '''
       || object_name
       || ''', force => TRUE, defer => FALSE); END;'
	   || chr(10)
	   || '/'
  FROM user_objects
 WHERE object_type = 'JOB'
/
*/

SELECT 'purge user_recyclebin;' FROM DUAL
/

SELECT 'EXIT;' FROM DUAL
/

SPOOL OFF
SET FEEDBACK ON
@CLEAN
SET PAGESIZE 80
SET FEEDBACK ON
SET HEADING ON
EXIT