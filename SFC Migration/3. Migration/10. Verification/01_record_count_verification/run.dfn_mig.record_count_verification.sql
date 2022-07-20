SPOOL log.run.dfn_mig.record_count_verification REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@1.records_count_verification_uat.sql
@@2.indirect_records_count_verification_uat.sql

SPOOL OFF

EXIT