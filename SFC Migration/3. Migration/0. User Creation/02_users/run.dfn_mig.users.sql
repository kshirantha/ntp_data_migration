SPOOL log.run.dfn_mig.tablespaces REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@sys.dfn_mig.user.sql

SPOOL OFF

EXIT