spool log.run.dfn_csm.packages replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

@@dfn_csm.pkg_clearing.pkg.sql
@@dfn_csm.pkg_dc_schedule_jobs.pkg.sql
@@dfn_csm.pkg_dc_t03_audit.pkg.sql
@@dfn_csm.pkg_settlement.pkg.sql
@@dfn_csm.pkg_dc_execution_summary.pkg.sql

spool off
