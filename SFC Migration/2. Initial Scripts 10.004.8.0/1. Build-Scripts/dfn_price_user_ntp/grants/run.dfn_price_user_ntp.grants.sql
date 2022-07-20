SPOOL log.run.dfn_price_user_ntp.grants REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'dfn_price_user_ntp' AS grants FROM DUAL;

@@dfn_price.dfn_price_user_ntp.grnt.sql

SPOOL OFF