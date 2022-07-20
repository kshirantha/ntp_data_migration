SPOOL log.run.dfn_mig.price_migration REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_mig.esp_todays_snapshots.data.sql
COMMIT
/
@@dfn_mig.esp_transactions_complete.data.sql
COMMIT
/

SPOOL OFF

EXIT