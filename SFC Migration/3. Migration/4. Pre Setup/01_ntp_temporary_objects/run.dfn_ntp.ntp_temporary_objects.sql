SPOOL log.run.dfn_ntp.ntp_temporary_objects REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_ntp.create_index.idx.sql
@@dfn_ntp.truncate_table.proc.sql
@@dfn_ntp.sp_stat_gather.proc.sql

SPOOL OFF

EXIT
