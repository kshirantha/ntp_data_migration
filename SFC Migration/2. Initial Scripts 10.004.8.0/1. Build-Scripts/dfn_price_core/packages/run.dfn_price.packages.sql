spool log.run.dfn_price.package replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

select 'eod_service_pkg' as package_name from dual;
@@dfn_price.eod_service_pkg.pkg.sql


spool off
