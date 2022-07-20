-- Table DFN_NTP.T09_ERROR_RECORDS

CREATE TABLE dfn_ntp.t09_error_records
(
    t09_db_seq_id    NUMBER (10, 0),
    t09_audit_key    VARCHAR2 (200),
    t09_col_values   CLOB,
    created_date     DATE DEFAULT SYSDATE,
    t09_error        VARCHAR2 (4000)
)
/



-- End of DDL Script for Table DFN_NTP.T09_ERROR_RECORDS

ALTER TABLE DFN_NTP.T09_ERROR_RECORDS 
 MODIFY (
  T09_DB_SEQ_ID NUMBER (20, 0)

 )
/

CREATE INDEX dfn_ntp.idx_t09_created_date
    ON dfn_ntp.t09_error_records (created_date DESC)
/