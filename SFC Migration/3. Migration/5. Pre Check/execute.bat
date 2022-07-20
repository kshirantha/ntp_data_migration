cd 01_pre_check_tables
sqlplus %str5%@%1 @run.dfn_mig.pre_check_tables.sql

cd ..\02_pre_check_scripts_count_wise
sqlplus %str5%@%1 @run.dfn_mig.pre_check_scripts_count_wise.sql

cd ..\03_pre_check_scripts_data_level
sqlplus %str5%@%1 @run.dfn_mig.pre_check_scripts_data_level.sql

cd ..\

start summary.exe