CREATE OR REPLACE PROCEDURE dfn_ntp.sp_bulk_process_finalize (
    p_t86_id                   IN NUMBER,
    p_t80_ref                  IN NUMBER,
    p_txn_type                 IN NUMBER,
    p_is_manual                IN NUMBER,
    p_primary_institution_id   IN NUMBER,
    p_is_start                 IN NUMBER,
    p_server                   IN VARCHAR,
    p_is_final                 IN NUMBER)
IS
    l_log_key         NUMBER;
    l_status          NUMBER;
    l_pending_count   NUMBER;
    l_total_count     NUMBER;
BEGIN
    l_status := 18;

    IF p_is_start = 1
    THEN
        IF p_is_manual = 0
        THEN
            UPDATE t86_bulk_cash_holding_process
               SET t86_status_id_v01 = 18,
                   t86_status_changed_date = SYSDATE,
                   t86_picked_servers =
                       CASE
                           WHEN t86_picked_servers IS NULL THEN p_server
                           ELSE t86_picked_servers || '~' || p_server
                       END
             WHERE t86_id = p_t86_id;
        END IF;


        UPDATE t80_file_processing_batches
           SET t80_status_id_v01 = 18, t80_status_changed_date = SYSDATE
         WHERE t80_id = p_t80_ref;

        SELECT seq_t81_id.NEXTVAL INTO l_log_key FROM DUAL;

        sp_add_t81_batch_logs (
            p_key           => l_log_key,
            p_batch_id      => p_t80_ref,
            p_log_type      => 2,
            p_log_message   =>    'Processing Start By OMS [Server Id: '
                               || p_server
                               || ']');
    ELSIF p_is_final = 0
    THEN
        IF p_txn_type = 1 OR p_txn_type = 2 OR p_txn_type = 3
        THEN
            SELECT seq_t81_id.NEXTVAL INTO l_log_key FROM DUAL;

            sp_add_t81_batch_logs (
                p_key           => l_log_key,
                p_batch_id      => p_t80_ref,
                p_log_type      => 2,
                p_log_message   =>    'Message received By OMS [Server Id: '
                                   || p_server
                                   || ']');

            SELECT COUNT (*)
              INTO l_pending_count
              FROM t23_share_txn_requests t23
             WHERE     t23.t23_status_id_v01 IN
                           (1,
                            2,
                            101,
                            102,
                            103,
                            104,
                            105,
                            106,
                            107,
                            108,
                            109,
                            110)
                   AND t23_batch_id = p_t80_ref;

            IF l_pending_count = 0
            THEN
                IF p_is_manual = 0 AND p_is_start = 0
                THEN
                    UPDATE t86_bulk_cash_holding_process
                       SET t86_status_id_v01 = 17,
                           t86_status_changed_date = SYSDATE,
                           t86_processed_servers =
                               CASE
                                   WHEN t86_processed_servers IS NULL
                                   THEN
                                       p_server
                                   ELSE
                                          t86_processed_servers
                                       || '~'
                                       || p_server
                               END
                     WHERE t86_id = p_t86_id;
                END IF;


                SELECT seq_t81_id.NEXTVAL INTO l_log_key FROM DUAL;

                l_status := 17;

                UPDATE t80_file_processing_batches
                   SET t80_status_id_v01 = l_status,
                       t80_status_changed_date = SYSDATE
                 WHERE t80_id = p_t80_ref;

                UPDATE m40_file_processing_job_config a
                   SET a.m40_job_status_id_v01 = l_status
                 WHERE m40_id IN (SELECT t80.t80_config_id_m40
                                    FROM t80_file_processing_batches t80
                                   WHERE t80_id = p_t80_ref);



                sp_add_t81_batch_logs (
                    p_key           => l_log_key,
                    p_batch_id      => p_t80_ref,
                    p_log_type      => 2,
                    p_log_message   => 'All records processed');

                UPDATE u53_process_detail
                   SET u53_status_id_v01 = l_status,
                       u53_failed_reason = NULL,
                       u53_updated_by_id_u17 = 0,
                       u53_updated_date_time = SYSDATE
                 WHERE     u53_code = 'WEEKLY'
                       AND u53_primary_institute_id_m02 =
                               p_primary_institution_id;
            ELSE
                l_status := 27;

                IF p_is_manual = 0 AND p_is_start = 0
                THEN
                    UPDATE t86_bulk_cash_holding_process
                       SET t86_status_id_v01 = l_status,
                           t86_status_changed_date = SYSDATE,
                           t86_processed_servers =
                               CASE
                                   WHEN t86_processed_servers IS NULL
                                   THEN
                                       p_server
                                   ELSE
                                          t86_processed_servers
                                       || '~'
                                       || p_server
                               END
                     WHERE t86_id = p_t86_id;
                END IF;

                UPDATE t80_file_processing_batches
                   SET t80_status_id_v01 = l_status,
                       t80_status_changed_date = SYSDATE
                 WHERE t80_id = p_t80_ref;


                sp_add_t81_batch_logs (
                    p_key           => l_log_key,
                    p_batch_id      => p_t80_ref,
                    p_log_type      => 2,
                    p_log_message   =>    'Partially Processed. '
                                       || l_pending_count
                                       || 'Records remains to process');
            END IF;
        END IF;
    END IF;
END;
/
