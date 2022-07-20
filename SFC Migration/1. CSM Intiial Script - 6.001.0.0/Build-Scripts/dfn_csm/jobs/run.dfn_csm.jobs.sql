spool log.run.dfn_csm.jobs replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

@@dfn_csm.dbms_scheduler.job.sql

spool off
