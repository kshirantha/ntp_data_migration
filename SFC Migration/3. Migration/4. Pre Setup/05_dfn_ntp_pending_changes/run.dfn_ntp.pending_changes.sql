SPOOL log.run.dfn_ntp.pending_changes.sql REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_ntp.pending_patch_changes.sql

SPOOL OFF

EXIT
