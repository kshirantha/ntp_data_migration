-- Table DFN_NTP.T65_TRADE_PROCESSING_EXECUTION

CREATE TABLE dfn_ntp.t65_trade_processing_execution
(
    t65_tp_req_id_t17        VARCHAR2 (22 BYTE) NOT NULL,
    t65_order_exec_id_t02    VARCHAR2 (50 BYTE) NOT NULL,
    t65_last_db_seq_id_t02   NUMBER (22, 0) NOT NULL
)
/

CREATE UNIQUE INDEX dfn_ntp.idx_t65_t65_composite
    ON dfn_ntp.t65_trade_processing_execution (t65_tp_req_id_t17 DESC,
                                               t65_last_db_seq_id_t02 DESC)
/

