cd 01_disable_objects
sqlplus %str4%@%1 @run.dfn_ntp.disable_objects.sql

cd ..\02_broker_institution_setup
sqlplus %str5%@%1 @run.dfn_mig.broker_institution_setup.sql

cd ..\03_institute_wise_master_data
sqlplus %str5%@%1 @run.dfn_mig.institute_wise_master_data.sql

cd ..\04_migration_scripts
sqlplus %str5%@%1 @run.dfn_mig.migration_scripts.sql

cd ..\05_user_setup
sqlplus %str5%@%1 @run.dfn_mig.user_setup.sql

cd ..\06_post_migration
sqlplus %str5%@%1 @run.dfn_mig.post_migration.sql

cd ..\07_reset_sequences
sqlplus %str4%@%1 @run.dfn_ntp.reset_sequences.sql

cd ..\08_app_seq_store
sqlplus %str4%@%1 @run.dfn_ntp.app_seq_store.sql

cd ..\09_enable_objects
sqlplus %str4%@%1 @run.dfn_ntp.enable_objects.sql

cd ..\

start summary.exe