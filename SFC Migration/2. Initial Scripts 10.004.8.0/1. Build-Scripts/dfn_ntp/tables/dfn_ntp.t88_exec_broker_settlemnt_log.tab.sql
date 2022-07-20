CREATE TABLE dfn_ntp.t88_exec_broker_settlemnt_log
(
    t88_id_t83               NUMBER (18, 0) NOT NULL,
    t88_t02_last_db_seq_id   NUMBER (20, 0) NOT NULL
)
/



CREATE INDEX dfn_ntp.t88_t88_id_t83
    ON dfn_ntp.t88_exec_broker_settlemnt_log (t88_id_t83 ASC)
/