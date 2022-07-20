CREATE TABLE dfn_ntp.t81_file_processing_log
(
    t81_id               NUMBER (10, 0),
    t81_process_id_m40   NUMBER (10, 0),
    t81_date             DATE,
    t81_log_type         NUMBER,
    t81_description      VARCHAR2 (2000 BYTE),
    t81_custom_type      VARCHAR2 (1 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.t81_file_processing_log
ADD CONSTRAINT t81_pk PRIMARY KEY (t81_id)
/

COMMENT ON COLUMN dfn_ntp.t81_file_processing_log.t81_log_type IS
    '1- Info, 2-Success 3- Error'
/

ALTER TABLE dfn_ntp.t81_file_processing_log
    RENAME COLUMN t81_process_id_m40 TO t81_batch_id_t80
/

