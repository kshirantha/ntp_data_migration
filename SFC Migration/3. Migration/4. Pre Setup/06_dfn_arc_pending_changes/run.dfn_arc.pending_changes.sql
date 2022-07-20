SPOOL log.run.dfn_arc.pending_changes.sql REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_arc.pending_patch_changes.sql

SPOOL OFF

EXIT
