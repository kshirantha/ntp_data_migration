SPOOL log.run.dfn_ntp.types REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 't_string_agg' AS procedure_name FROM DUAL;

@@dfn_ntp.t_string_agg.type.sql


SPOOL OFF
