-- Table DFN_NTP.REDIS_PROCESS_VALIDATION_ERROR

CREATE TABLE dfn_ntp.redis_process_validation_error
(
    dbseqid        NUMBER (10, 0),
    error_desc     VARCHAR2 (4000),
    created_date   DATE,
    start_date     TIMESTAMP (6),
    is_process     NUMBER (1, 0) DEFAULT 0,
    error_mode     NUMBER (1, 0)
)
/



-- End of DDL Script for Table DFN_NTP.REDIS_PROCESS_VALIDATION_ERROR
