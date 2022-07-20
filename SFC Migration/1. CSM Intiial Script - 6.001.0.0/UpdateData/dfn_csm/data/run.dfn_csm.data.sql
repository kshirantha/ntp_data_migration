set define on
column dcol new_value SYSTIMESTAMP noprint
select TO_CHAR (SYSTIMESTAMP, 'YYYYMMDDhh24miss') dcol from dual;
spool log.&SYSTIMESTAMP..run.dfn_csm.data replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

@@dfn_csm.data_fixes.data.sql

spool off
