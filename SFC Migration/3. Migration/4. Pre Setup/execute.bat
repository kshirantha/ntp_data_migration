cd 01_ntp_temporary_objects
sqlplus %str4%@%1 @run.dfn_ntp.ntp_temporary_objects.sql

cd ..\02_grants
sqlplus %str4%@%1 @run.dfn_ntp.grants.sql

cd ..\03_mappings
sqlplus %str5%@%1 @run.dfn_mig.mappings.sql

cd ..\04_pre_migration
sqlplus %str5%@%1 @run.dfn_mig.pre_migration.sql

cd ..\05_dfn_ntp_pending_changes
sqlplus %str4%@%1 @run.dfn_ntp.pending_changes.sql

cd ..\06_dfn_arc_pending_changes
sqlplus %str3%@%1 @run.dfn_arc.pending_changes.sql

cd ..\

start summary.exe