SPOOL log.run.dfn_mig.broker_institution_setup REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@01_dfn_ntp.m150_broker.data.sql
COMMIT
/

@@02_dfn_ntp.m02_institute.data.sql
COMMIT
/

SPOOL OFF

EXIT