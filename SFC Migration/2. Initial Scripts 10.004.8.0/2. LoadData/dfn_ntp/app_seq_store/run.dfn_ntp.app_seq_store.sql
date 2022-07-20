SPOOL log.run.dfn_ntp.app_seq_store REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'app_seq_store' AS script_name FROM DUAL;

@@dfn_ntp.app_seq_store.sql

SPOOL OFF
