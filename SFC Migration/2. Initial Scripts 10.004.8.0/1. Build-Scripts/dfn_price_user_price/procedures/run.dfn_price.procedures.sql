SPOOL log.run.dfn_price.procedures REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'sp_esp_eod' AS procedure_name FROM DUAL;

@@dfn_price.sp_esp_eod.proc.sql

SELECT 'job_populate_price_table' AS procedure_name FROM DUAL;

@@dfn_price.job_populate_price_table.proc.sql

SPOOL OFF