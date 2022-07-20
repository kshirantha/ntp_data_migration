CREATE TABLE dfn_ntp.redis_process_seq
(
    dbseqid                NUMBER (20, 0),
    created_date           DATE,
    start_date             TIMESTAMP (6),
    end_date               TIMESTAMP (6),
    process_time_in_sec    INTERVAL DAY (2) TO SECOND (6),
    row_count              NUMBER (10, 0),
    return_value           NUMBER (1, 0),
    is_app_req             NUMBER (1, 0) DEFAULT 0,
    order_processed_time   INTERVAL DAY (2) TO SECOND (6),
    chacc_processed_time   INTERVAL DAY (2) TO SECOND (6),
    hold_processed_time    INTERVAL DAY (2) TO SECOND (6),
    t02_processed_time     INTERVAL DAY (2) TO SECOND (6),
    t09_processed_time     INTERVAL DAY (2) TO SECOND (6),
    t01_trans_type         NUMBER (2, 0)
)
/



CREATE INDEX dfn_ntp.ix_prsq_created_date
    ON dfn_ntp.redis_process_seq ("CREATED_DATE" DESC)
/