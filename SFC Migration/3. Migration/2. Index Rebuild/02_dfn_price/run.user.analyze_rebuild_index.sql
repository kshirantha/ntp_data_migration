SPOOL log.run.user.analyze_rebuild_index REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@01_user.user_index_stats.tab.sql
@@02_user.sp_index_rebuild.proc.sql
@@03_user.execute_analyze_and_rebuild.sql

SPOOL OFF

EXIT