SPOOL log.run.drop REPLACE

SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

@@sys.drop.sql

SPOOL OFF

EXIT