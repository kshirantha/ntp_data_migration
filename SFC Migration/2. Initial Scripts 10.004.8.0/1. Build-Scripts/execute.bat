cd dfn_ntp
sqlplus %str4%@%1 @master.sql

cd ..\dfn_arc
sqlplus %str3%@%1 @master.sql

cd ..\dfn_algo
sqlplus %str2%@%1 @master.sql

cd ..\dfn_price_core
sqlplus %str6%@%1 @master.sql

cd ..\dfn_price_user_ntp
sqlplus %str4%@%1 @master.sql

cd ..\dfn_price_user_price
sqlplus %str6%@%1 @master.sql

cd ..\dfn_csm
sqlplus %str7%@%1 @master.sql

cd ..\

call recompile %str1%  %str2%  %str3%  %str4% %str5% %str6% %str7%

start summary.exe