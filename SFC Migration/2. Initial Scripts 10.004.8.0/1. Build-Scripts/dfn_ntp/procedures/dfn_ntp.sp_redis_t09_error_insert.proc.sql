CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redis_t09_error_insert (
    t09c_error    t09_txn_single_entry_v3%ROWTYPE,
    p_query       CLOB,
    p_error       VARCHAR2)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    BEGIN
        INSERT INTO t09_error_records
            SELECT t09c_error.t09_db_seq_id,
                   t09c_error.t09_audit_key,
                   p_query,
                   SYSDATE,
                   p_error
              FROM DUAL;

        COMMIT;
    END;
END;
/
/
