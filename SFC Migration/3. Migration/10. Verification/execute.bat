cd 01_record_count_verification
sqlplus %str5%@%1 @run.dfn_mig.record_count_verification.sql

cd ..\02_data_level_verification
sqlplus %str5%@%1 @run.dfn_mig.data_level_verification.sql

cd ..\03_drop_ntp_temporary_objects
sqlplus %str4%@%1 @run.dfn_ntp.drop_temporary_objects.sql

cd ..\

start summary.exe