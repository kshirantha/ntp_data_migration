SPOOL log.run.dfn_ntp.reset_sequences REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@01_reset_sequences.sql
COMMIT
/
@@02_grant_privileges.sql
COMMIT
/

SPOOL OFF

EXIT