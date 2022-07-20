SPOOL log.run.dfn_mig.institute_wise_master_data REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@01_dfn_ntp.v00_sys_config_broker_wise.data.sql
COMMIT
/
@@02_dfn_ntp.v20_default_master_data.data.sql
COMMIT
/
@@03_dfn_ntp.m35_customer_settl_group.data.sql
COMMIT
/
@@04_dfn_ntp.m126_rules.data.sql
COMMIT
/
@@05_dfn_ntp.m45_permission_groups.data.sql
COMMIT
/
@@06_dfn_ntp.m46_permission_grp_entlements.data.sql
COMMIT
/
@@07_dfn_ntp.u53_process_detail.data.sql
COMMIT
/
@@08_dfn_ntp.m39_price_qty_factors.data.sql
COMMIT
/
@@99_dfn_ntp.sfc_specific_configurations.data.sql
COMMIT
/
SPOOL OFF

EXIT