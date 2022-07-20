cd 01_archival_migration
sqlplus %str3%@%1 @run.dfn_arc.archival_migration.sql

cd ..\

start summary.exe