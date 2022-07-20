SPOOL log.run.dfn_ntp.enable_objects REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@enable_scheduled_jobs.sql SFC will Schecule Manually 
@@enable_trigger.sql

SPOOL OFF

EXIT