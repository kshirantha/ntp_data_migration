SPOOL log.run.dfn_mig.pre_check_tables REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_mig.pre_check_table_count_wise.tab.sql
@@dfn_mig.pre_check_table_data_level.tab.sql


SPOOL OFF

EXIT