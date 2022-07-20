cd 00_drop
sqlplus sys/password@%1 as sysdba @run.drop.sql

cd ..\01_tablespaces
sqlplus sys/password@%1 as sysdba @run.dfn_mig.tablespaces.sql

cd ..\02_users
sqlplus sys/password@%1 as sysdba @run.dfn_mig.users.sql

cd ..\03_db_link
sqlplus %str5%@%1 @run.dfn_mig.mubasher_db_link.sql

cd ..\

start summary.exe