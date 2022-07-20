SPOOL log.run.dfn_mig.pre_check_scripts_data_level REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@141_i_dfn_ntp.u06_cash_account.data.sql
COMMIT
/
@@168_i_dfn_ntp.u24_holdings.data.sql
COMMIT
/

SPOOL OFF

EXIT