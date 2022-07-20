sqlplus %str4%@%1 @CLEANOBJ.sql
sqlplus %str3%@%1 @CLEANOBJ.sql
sqlplus %str6%@%1 @CLEANOBJ.sql
sqlplus %str5%@%1 @CLEANOBJ.sql
sqlplus %str2%@%1 @CLEANOBJ.sql
sqlplus %str7%@%1 @CLEANOBJ.sql

call recompile %str1% %str3% %str4% %str5% %str6% %str7%

start summary.exe