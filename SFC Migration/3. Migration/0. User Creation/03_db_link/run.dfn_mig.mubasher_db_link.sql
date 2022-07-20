SPOOL log.run.dfn_mig.mubasher_db_link REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_mig.mubasher_db_link.sql

SPOOL OFF

EXIT