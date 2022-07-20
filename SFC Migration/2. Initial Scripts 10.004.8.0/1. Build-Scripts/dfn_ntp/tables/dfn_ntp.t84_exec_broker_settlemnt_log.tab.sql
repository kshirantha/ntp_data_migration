CREATE TABLE dfn_ntp.t84_exec_broker_settlemnt_log
(
    t84_id_t83               NUMBER (18, 0) NOT NULL,
    t84_t02_last_db_seq_id   NUMBER (20, 0) NOT NULL
)
/



CREATE INDEX dfn_ntp.t84_t84_id_t83
    ON dfn_ntp.t84_exec_broker_settlemnt_log (t84_id_t83 ASC)
/

DROP TABLE dfn_ntp.t84_exec_broker_settlemnt_log
/