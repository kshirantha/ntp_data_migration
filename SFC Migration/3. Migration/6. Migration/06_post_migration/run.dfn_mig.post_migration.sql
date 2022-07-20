SPOOL log.run.dfn_mig.post_migration REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@01_post_migration_direct.sql
COMMIT
/
@@02_post_migration_review.sql
COMMIT
/
SPOOL OFF

EXIT