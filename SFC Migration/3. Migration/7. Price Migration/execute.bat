cd 01_price_grants
sqlplus %str6%@%1 @run.dfn_price.price_grants.sql

cd ..\02_price_migration
sqlplus %str5%@%1 @run.dfn_mig.price_migration.sql

cd ..\

start summary.exe