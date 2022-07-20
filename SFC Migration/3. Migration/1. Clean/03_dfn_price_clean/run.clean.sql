SPOOL log.run.cleanup REPLACE

SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_price.truncate_price_data.sql

SPOOL OFF

EXIT