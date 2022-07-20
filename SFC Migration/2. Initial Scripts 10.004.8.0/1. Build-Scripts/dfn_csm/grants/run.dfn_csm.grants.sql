spool log.run.dfn_csm.grants replace

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'grants' AS grants FROM DUAL;

@@dfn_csm.grants.grnt.sql

spool off
