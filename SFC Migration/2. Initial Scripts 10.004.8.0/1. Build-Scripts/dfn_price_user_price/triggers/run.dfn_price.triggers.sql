SPOOL log.run.dfn_price.triggers REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'trg_insert_new_symbol' AS trigger_name FROM DUAL;

@@dfn_price.trg_insert_new_symbol.trig.sql

SELECT 'trg_update_symbol_data' AS trigger_name FROM DUAL;

@@dfn_price.trg_update_symbol_data.trig.sql

SELECT 'trg_update_symbol_prices' AS trigger_name FROM DUAL;

@@dfn_price.trg_update_symbol_prices.trig.sql

SPOOL OFF