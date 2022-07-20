SPOOL log.run.dfn_mig.pre_migration REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_mig.log_table.sql
@@dfn_mig.mapping_tables.sql
@@dfn_mig.migration_params.sql
@@dfn_mig.fn_get_new_entity.func.sql
@@dfn_mig.primary_key_usage.tab.sql
@@dfn_mig.fn_use_new_key.func.sql

SPOOL OFF

EXIT
