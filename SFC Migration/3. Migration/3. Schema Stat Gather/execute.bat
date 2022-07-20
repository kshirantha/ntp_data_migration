cd 01_dfn_ntp
sqlplus %str4%@%1 @run.user.stat_gather.sql

cd ..\02_dfn_price
sqlplus %str6%@%1 @run.user.stat_gather.sql

cd ..\

start summary.exe