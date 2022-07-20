spool log.run.dfn_csm.sequences replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

@@dfn_csm.seq_a00_id.seq.sql
@@dfn_csm.seq_a01_id.seq.sql
@@dfn_csm.seq_a02_id.seq.sql
@@dfn_csm.seq_a03_id.seq.sql
@@dfn_csm.seq_a05_id.seq.sql
@@dfn_csm.seq_a08_id.seq.sql
@@dfn_csm.seq_a09_id.seq.sql
@@dfn_csm.seq_a10_id.seq.sql
@@dfn_csm.seq_a11_id.seq.sql
@@dfn_csm.seq_a12_id.seq.sql
@@dfn_csm.seq_a13_id.seq.sql
@@dfn_csm.seq_a14_id.seq.sql
@@dfn_csm.seq_a15_id.seq.sql
@@dfn_csm.seq_m07_id.seq.sql
@@dfn_csm.seq_s02_id.seq.sql
@@dfn_csm.seq_t01_id.seq.sql
@@dfn_csm.seq_t02_id.seq.sql
@@dfn_csm.seq_t04_id.seq.sql
@@dfn_csm.seq_t05_id.seq.sql

spool off
