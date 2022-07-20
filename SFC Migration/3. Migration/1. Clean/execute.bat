cd 01_dfn_mig_clean
sqlplus %str5%@%1 @run.clean.sql

cd ..\02_dfn_ntp_clean
sqlplus %str4%@%1 @run.clean.sql

cd ..\03_dfn_price_clean
sqlplus %str6%@%1 @run.clean.sql

cd ..\

start summary.exe