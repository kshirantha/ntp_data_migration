EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_A01_JOB', p_table_name=> 'A01_DB_JOBS_EXECUTION_LOG', p_table_id_column=> 'A01_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_A05_CACHE_MON_AUDIT_LOG', p_table_name=> 'A05_CACHE_MON_AUDIT_LOG', p_table_id_column=> 'A05_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_A13_ID', p_table_name=> 'A13_CASH_HOLDING_ADJUST_LOG', p_table_id_column=> 'A13_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_A21_ID', p_table_name=> 'A21_MINIMUM_COMMISSION_AUDIT', p_table_id_column=> 'A21_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_M161_ID', p_table_name=> 'M161_PRICE_USER_POOL', p_table_id_column=> 'M161_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_T07_ID', p_table_name=> 'T07_NASTRO_ACCOUNT_LOG', p_table_id_column=> 'T07_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_T22_ORDER_AUDIT', p_table_name=> 'T22_ORDER_AUDIT', p_table_id_column=> 'T22_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_T23_ID', p_table_name=> 'T23_SHARE_TXN_REQUESTS', p_table_id_column=> 'T23_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_H26_ID', p_table_name=> 'H26_DAILY_STATUS', p_table_id_column=> 'H26_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'SEQ_Z10_VER_AUDIT_LOG', p_table_name=> 'Z10_VERSION_AUDIT_LOG', p_table_id_column=> 'Z10_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'T02_TRANSACTION_LOG_SEQ', p_table_name=> 'T02_TRANSACTION_LOG', p_table_id_column=> 'T02_CASH_ACNT_SEQ_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'T63_TC_REQUEST_LIST_SEQ', p_table_name=> 'T63_TC_REQUEST_LIST', p_table_id_column=> 'T63_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'T64_TRADE_CONFIRMATION_SEQ', p_table_name=> 'T64_TRADE_CONFIRMATION_LIST', p_table_id_column=> 'T64_ID', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'TRADE_CONFIRMATION_NO_SEQ', p_table_name=> 'T64_TRADE_CONFIRMATION_LIST', p_table_id_column=> 'T64_TRADE_CONFIRM_NO', p_reset => 0);
EXECUTE  dfn_ntp.sp_reset_seq(p_seq_name=> 'ORDER_AUDIT_SEQ', p_table_name=> 'T02_TRANSACTION_LOG', p_table_id_column=> 'T02_LAST_DB_SEQ_ID', p_reset => 0);