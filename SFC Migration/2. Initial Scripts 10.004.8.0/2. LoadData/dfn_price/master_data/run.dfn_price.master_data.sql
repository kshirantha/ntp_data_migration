SPOOL log.run.dfn_price.master_data REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'esp_exchangemaster' AS script_name FROM DUAL;

@@dfn_price.esp_exchangemaster.dat.sql


SPOOL OFF
