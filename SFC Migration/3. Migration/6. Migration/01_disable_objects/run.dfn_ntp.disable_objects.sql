SPOOL log.run.dfn_ntp.disable_objects REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@disable_scheduled_jobs.sql SFC will Schecule Manually 
@@disable_trigger.sql

SPOOL OFF

EXIT