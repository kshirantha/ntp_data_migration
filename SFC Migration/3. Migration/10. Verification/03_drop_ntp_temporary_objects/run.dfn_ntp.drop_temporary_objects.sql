SPOOL log.run.dfn_ntp.drop_temporary_objects REPLACE

WHENEVER SQLERROR EXIT
SET ECHO ON
SET DEFINE OFF
SET SQLBLANKLINES ON

@@dfn_ntp.drop_index.idx.sql
@@dfn_ntp.drop_temporary_objects.sql

SPOOL OFF

EXIT