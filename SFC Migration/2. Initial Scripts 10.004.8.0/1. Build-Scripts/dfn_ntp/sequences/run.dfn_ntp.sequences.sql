SPOOL log.run.dfn_ntp.sequences REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON


SELECT 'order_audit_seq' AS sequence_name FROM DUAL;

@@dfn_ntp.order_audit_seq.seq.sql

SELECT 'seq_a01_job' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_a01_job.seq.sql

SELECT 'seq_a05_cache_mon_audit_log' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_a05_cache_mon_audit_log.seq.sql

SELECT 't02_transaction_log_seq' AS sequence_name FROM DUAL;

@@dfn_ntp.t02_transaction_log_seq.seq.sql

SELECT 'seq_t23_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t23_id.seq.sql

SELECT 'seq_t22_order_audit' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t22_order_audit.seq.sql

SELECT 'seq_z10_ver_audit_log' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_z10_ver_audit_log.seq.sql

SELECT 'seq_a13_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_a13_id.seq.sql

SELECT 'trade_confirmation_no_seq' AS sequence_name FROM DUAL;

@@dfn_ntp.trade_confirmation_no_seq.seq.sql

SELECT 't63_tc_request_list_seq' AS sequence_name FROM DUAL;

@@dfn_ntp.t63_tc_request_list_seq.seq.sql

SELECT 't64_trade_confirmation_seq' AS sequence_name FROM DUAL;

@@dfn_ntp.t64_trade_confirmation_seq.seq.sql

SELECT 'seq_m161_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_m161_id.seq.sql

SELECT 'seq_t07_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t07_id.seq.sql

SELECT 'seq_a21_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_a21_id.seq.sql

SELECT 'seq_t70_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t70_id.seq.sql

SELECT 'seq_a15_falcon_msg' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_a15_falcon_msg.seq.sql

SELECT 'seq_t77_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t77_id.seq.sql

SELECT 'seq_h26_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_h26_id.seq.sql

SELECT 'seq_t78_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t78_id.seq.sql

SELECT 'seq_t79_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t79_id.seq.sql

SELECT 'seq_a50_id_b' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_a50_id_b.seq.sql

SELECT 'seq_t86_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t86_id.seq.sql

SELECT 'seq_t87_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t87_id.seq.sql

SELECT 'seq_t80_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t80_id.seq.sql

SELECT 'seq_t90_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t90_id.seq.sql

SELECT 'seq_t81_id' AS sequence_name FROM DUAL;

@@dfn_ntp.seq_t81_id.seq.sql

SPOOL OFF