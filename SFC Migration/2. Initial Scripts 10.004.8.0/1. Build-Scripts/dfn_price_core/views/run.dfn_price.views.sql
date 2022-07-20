spool log.run.dfn_price.views replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

select 'symbol_data' as view_name from dual;
@@dfn_price.symbol_data.view.sql


spool off
