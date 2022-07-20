SPOOL log.run.dfn_arc.archival_migration REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_arc.archival_migration.sql

SPOOL OFF

EXIT