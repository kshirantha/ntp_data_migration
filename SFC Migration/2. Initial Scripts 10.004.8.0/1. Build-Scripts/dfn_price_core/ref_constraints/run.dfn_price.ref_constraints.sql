spool log.run.dfn_price.ref_constraint replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

select 'esp_markets_descriptions' as table_name from dual;
@@dfn_price.esp_markets_descriptions.ref.sql
select 'esp_exchange_descriptions' as table_name from dual;
@@dfn_price.esp_exchange_descriptions.ref.sql
select 'esp_transactions_complete' as table_name from dual;
@@dfn_price.esp_transactions_complete.ref.sql
select 'esp_sectors' as table_name from dual;
@@dfn_price.esp_sectors.ref.sql
select 'esp_sectors_descriptions' as table_name from dual;
@@dfn_price.esp_sectors_descriptions.ref.sql


spool off
