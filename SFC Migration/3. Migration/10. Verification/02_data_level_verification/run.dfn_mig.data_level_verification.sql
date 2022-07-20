SPOOL log.run.dfn_mig.data_level_verification REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@1.dfn_position_data_verification.sql
COMMIT
/
@@2.dfn_general_data_verification.sql
COMMIT
/
@@3.sfc_mig_doc_specific_data_verification.sql
COMMIT
/

SPOOL OFF

EXIT