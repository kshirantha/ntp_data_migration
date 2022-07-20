CREATE TABLE dfn_ntp.t16_eod_status
(
    t16_start_time                 DATE,
    t16_date                       VARCHAR2 (20 BYTE) NOT NULL,
    t16_status                     NUMBER (3, 0) NOT NULL,
    t16_end_time                   DATE,
    t16_error_count                NUMBER (4, 0),
    t16_description                VARCHAR2 (200 BYTE),
    t16_primary_institute_id_m02   NUMBER (3, 0) DEFAULT 1
)
/

COMMENT ON TABLE dfn_ntp.t16_eod_status IS
    'Stores the status of EOD process. EOD may consists of few steps involving both OMS and BOS.
1) First OMS will compare and finalize persisted values
2) BOS will update exchange FIX file comparing the differences
3) OMS will process the difference identified by BOS'
/