SET PAGESIZE 300
set feedback off
set heading off
SPOOL COMA.SQL
SELECT
 'ALTER ' ||
 DECODE( object_type, 'PACKAGE BODY', 'PACKAGE', object_type) || ' ' ||
 lower(object_name) ||
 DECODE( object_type, 'PACKAGE BODY', ' COMPILE BODY;', ' COMPILE;') fix
FROM user_objects
WHERE object_type IN ( 'FUNCTION',
    'PACKAGE',
    'PACKAGE BODY',
    'PROCEDURE',
    'TRIGGER',
    'VIEW',
    'SYNONYM',
    'MATERIALIZED VIEW')
AND status = 'INVALID'
/
SPOOL OFF
set feedback on
@COMA
SET PAGESIZE 80
set feedback on
set heading on
EXIT
