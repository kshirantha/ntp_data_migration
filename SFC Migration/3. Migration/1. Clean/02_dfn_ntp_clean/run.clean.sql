SPOOL log.run.cleanup REPLACE

SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_ntp.truncate_ntp_data.sql
@@dfn_ntp.institute_entitlement.data.sql -- This is to Correct Entitilement Issues in Patches

SPOOL OFF

EXIT