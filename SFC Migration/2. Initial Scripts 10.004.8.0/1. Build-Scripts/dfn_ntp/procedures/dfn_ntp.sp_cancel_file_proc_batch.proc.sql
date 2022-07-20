CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cancel_file_proc_batch (
    p_key                OUT NUMBER,
    p_user_id         IN     NUMBER,
    p_cancel_reason   IN     VARCHAR,
    p_batch_id        IN     NUMBER DEFAULT NULL)
IS
    l_qry       VARCHAR2 (15000);
    l_log_key   NUMBER;
    l_is_auto   NUMBER;
BEGIN
    UPDATE t80_file_processing_batches
       SET t80_status_id_v01 = 19,
           t80_status_changed_by_id_u17 = p_user_id,
           t80_status_changed_date = SYSDATE,
           t80_cancel_reason = p_cancel_reason
     WHERE t80_id = p_batch_id;

    UPDATE t23_share_txn_requests
       SET t23_status_id_v01 = 19,
           t23_status_changed_by_id_u17 = p_user_id,
           t23_status_changed_date = SYSDATE
     WHERE t23_batch_id = p_batch_id AND t23_status_id_v01 NOT IN (17, 3);

    SELECT seq_t81_id.NEXTVAL INTO l_log_key FROM DUAL;

    UPDATE m40_file_processing_job_config a
       SET a.m40_job_status_id_v01 = 19,
           a.m40_status_changed_by_id_u17 = p_user_id,
           a.m40_status_changed_date = SYSDATE
     WHERE m40_id IN (SELECT t80.t80_config_id_m40
                        FROM t80_file_processing_batches t80
                       WHERE t80_id = p_batch_id AND t80_batch_type = 1); -- If only automate batches (batch type = 1)

    sp_add_t81_batch_logs (
        p_key           => l_log_key,
        p_batch_id      => p_batch_id,
        p_log_type      => 2,
        p_log_message   => 'Cancelled by user ' || p_user_id);

    p_key := 1;
EXCEPTION
    WHEN OTHERS
    THEN
        p_key := -1;
        RETURN;
END;
/