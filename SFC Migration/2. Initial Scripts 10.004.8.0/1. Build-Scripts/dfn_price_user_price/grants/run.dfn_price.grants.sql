SPOOL log.run.dfn_price.grants REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'grants' AS grants FROM DUAL;

@@dfn_price.grants.grnt.sql

SPOOL OFF