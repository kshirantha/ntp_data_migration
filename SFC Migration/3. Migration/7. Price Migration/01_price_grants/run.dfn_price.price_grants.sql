SPOOL log.run.dfn_price.price_grants REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_price.price_grants.sql

SPOOL OFF

EXIT