cd dfn_ntp
sqlplus %str4%@%1 @master.sql

cd ..\dfn_price
sqlplus %str6%@%1 @master.sql

cd ..\

start summary.exe