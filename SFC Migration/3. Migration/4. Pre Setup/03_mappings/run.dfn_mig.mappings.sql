SPOOL log.run.dfn_mig.mappings REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@01a_dfn_mig.map01_approval_status_v01.tab.sql
@@01b_dfn_mig.map01_approval_status_v01.data.sql
COMMIT
/
@@02a_dfn_mig.map02_audit_activity_m82.tab.sql
@@02b_dfn_mig.map02_audit_activity_m82.data.sql
COMMIT
/
@@03a_dfn_mig.map03_approval_entity_id.tab.sql
@@03b_dfn_mig.map03_approval_entity_id.data.sql
COMMIT
/
@@04a_dfn_mig.map04_entitlements_v04.tab.sql
@@04b_dfn_mig.map04_entitlements_v04.data.sql
COMMIT
/
@@05a_dfn_mig.map05_employee_type_m11.tab.sql
@@05b_dfn_mig.map05_employee_type_m11.data.sql
COMMIT
/
@@06a_dfn_mig.map06_country_m05.tab.sql
@@06b_dfn_mig.map06_country_m05.data.sql
COMMIT
/
@@07a_dfn_mig.map07_city_m06.tab.sql
@@07b_dfn_mig.map07_city_m06.data.sql
COMMIT
/
@@08a_dfn_mig.map08_identity_types_m15.tab.sql
@@08b_dfn_mig.map08_identity_types_m15.data.sql
COMMIT
/
@@09a_dfn_mig.map09_uploadable_documents_m61.tab.sql
@@09b_dfn_mig.map09_uploadable_documents_m61.data.sql
COMMIT
/
@@10a_dfn_mig.map10_marital_status_m128.tab.sql
@@10b_dfn_mig.map10_marital_status_m128.data.sql
COMMIT
/
@@11a_dfn_mig.map11_titles_m130.tab.sql
@@11b_dfn_mig.map11_titles_m130.data.sql
COMMIT
/
@@12a_dfn_mig.map12_notification_items_m99.tab.sql
@@12b_dfn_mig.map12_notification_items_m99.data.sql
COMMIT
/
@@13a_dfn_mig.map13_notification_sub_items_m100.tab.sql
@@13b_dfn_mig.map13_notification_sub_items_m100.data.sql
COMMIT
/
@@14a_dfn_mig.map14_notify_subitem_schd_m103.tab.sql
@@14b_dfn_mig.map14_notify_subitem_schd_m103.data.sql
COMMIT
/
@@15a_dfn_mig.map15_transaction_codes_m97.tab.sql
@@15b_dfn_mig.map15_transaction_codes_m97.data.sql
COMMIT
/
@@16a_dfn_mig.map16_optional_exchangs_m01.tab.sql
@@16b_dfn_mig.map16_optional_exchangs_m01.data.sql
COMMIT
/
@@17a_dfn_mig.map17_customer_category_v01_86.tab.sql
@@17b_dfn_mig.map17_customer_category_v01_86.data.sql
COMMIT
/
@@99x_dfn_mig.missing_mappings.data.sql
COMMIT
/

SPOOL OFF

EXIT