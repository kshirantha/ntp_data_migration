cd dfn_csm
sqlplus %str7%@%1 @master.sql

cd ..\

call recompile %str1% %str3% %str4% %str5% %str6% %str7%

start summary.exe

