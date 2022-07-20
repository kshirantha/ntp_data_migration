SPOOL log.run.cleanup REPLACE

SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_mig.truncate_mig_data.sql

SPOOL OFF

EXIT