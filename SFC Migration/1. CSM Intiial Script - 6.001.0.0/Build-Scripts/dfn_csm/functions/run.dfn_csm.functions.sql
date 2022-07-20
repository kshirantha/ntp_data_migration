spool log.run.dfn_csm.functions replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

@@dfn_csm.fn_get_fixml_seq_id.func.sql

spool off
