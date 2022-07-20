CREATE OR REPLACE PROCEDURE dfn_ntp.sp_set_paying_agent_status (
    p_status              OUT NUMBER,
    p_session_id       IN     NUMBER,
    p_processed_by     IN     NUMBER,
    p_institution_id   IN     NUMBER,
    p_pre_processed    IN     NUMBER DEFAULT 0,
	p_attempt_count    IN     NUMBER DEFAULT 1)
IS
    l_pending_count            NUMBER := 0;
    l_processing_start_count   NUMBER := 0;
    l_countstatus              NUMBER := 0;
BEGIN

    IF p_attempt_count = 2
    THEN
        UPDATE t501_payment_detail_c
           SET t501_current_status = 1
         WHERE     t501_payment_session_id_t500 = p_session_id
               AND t501_status_id_v01 = 2;
    END IF;
	
    IF p_pre_processed = 0
    THEN
        UPDATE t501_payment_detail_c
           SET t501_status_id_v01 = 17,
               t501_last_updated_date = SYSDATE,
               t501_last_updated_by_id_u17 = p_processed_by,
               t501_payment_date = SYSDATE,
               t501_payment_confirm = 'Yes'
         WHERE t501_id IN
                  (SELECT t02_txn_refrence_id
                      FROM t02_transaction_log
                     WHERE
                           t02_master_ref = p_session_id
						   AND t02_narration = 'Paying_Agent'
                           AND t02_txn_refrence_id IS NOT NULL);

        SELECT COUNT (*)
          INTO l_pending_count
          FROM t501_payment_detail_c t501
         WHERE     t501.t501_status_id_v01 IN
                       (1, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110)
               AND t501.t501_payment_session_id_t500 = p_session_id
               AND t501.t501_institute_id_m02 = p_institution_id;

        IF l_pending_count = 0
        THEN
            p_status := 17;                                       -- Processed

            UPDATE t500_payment_sessions_c t500
               SET t500.t500_status_id_v01 = 17,
                   t500.t500_processed_by_id_u17 = p_processed_by,
                   t500.t500_processed_date = SYSDATE
             WHERE     t500.t500_id = p_session_id
                   AND t500.t500_institute_id_m02 = p_institution_id;

            INSERT
              INTO a10_entity_status_history (a10_id,
                                              a10_approval_entity_id,
                                              a10_entity_pk,
                                              a10_approval_status_id_v01,
                                              a10_status_changed_by_id_u17,
                                              a10_status_changed_date)
            VALUES (
                       (SELECT MAX (a10_id) + 1
                          FROM a10_entity_status_history),
                       500,
                       p_session_id,
                       17,
                       p_processed_by,
                       SYSDATE);
        ELSE
            SELECT COUNT (*)
              INTO l_processing_start_count
              FROM t501_payment_detail_c t501
             WHERE     t501.t501_status_id_v01 IN
                           (17,
                            2,
                            3,
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
                   AND t501.t501_payment_session_id_t500 = p_session_id
                   AND t501.t501_institute_id_m02 = p_institution_id;

            IF l_processing_start_count > 0
            THEN
                p_status := 27;                         -- Pratially Processed

                UPDATE t500_payment_sessions_c t500
                   SET t500.t500_status_id_v01 = 27,
                       t500.t500_processed_by_id_u17 = p_processed_by,
                       t500.t500_processed_date = SYSDATE
                 WHERE     t500.t500_id = p_session_id
                       AND t500.t500_institute_id_m02 = p_institution_id;

                INSERT
                  INTO a10_entity_status_history (
                           a10_id,
                           a10_approval_entity_id,
                           a10_entity_pk,
                           a10_approval_status_id_v01,
                           a10_status_changed_by_id_u17,
                           a10_status_changed_date)
                VALUES (
                           (SELECT MAX (a10_id) + 1
                              FROM a10_entity_status_history),
                           500,
                           p_session_id,
                           27,
                           p_processed_by,
                           SYSDATE);
            ELSE
                p_status := 18;                                  -- Processing

                UPDATE t500_payment_sessions_c t500
                   SET t500.t500_status_id_v01 = 18,
                       t500.t500_processed_by_id_u17 = p_processed_by,
                       t500.t500_processed_date = SYSDATE
                 WHERE     t500.t500_id = p_session_id
                       AND t500.t500_institute_id_m02 = p_institution_id;

                INSERT
                  INTO a10_entity_status_history (
                           a10_id,
                           a10_approval_entity_id,
                           a10_entity_pk,
                           a10_approval_status_id_v01,
                           a10_status_changed_by_id_u17,
                           a10_status_changed_date)
                VALUES (
                           (SELECT MAX (a10_id) + 1
                              FROM a10_entity_status_history),
                           500,
                           p_session_id,
                           18,
                           p_processed_by,
                           SYSDATE);
            END IF;
        END IF;
    ELSE
        MERGE INTO t500_payment_sessions_c t500
             USING (SELECT DISTINCT t501_payment_session_id_t500
                      FROM t501_payment_detail_c t501
                     WHERE     t501.t501_status_id_v01 = 1
                           AND t501.t501_payment_session_id_t500 =
                                   p_session_id) t501
                ON (t500.t500_id = t501.t501_payment_session_id_t500)
        WHEN MATCHED
        THEN
            UPDATE SET t500.t500_status_id_v01 = 1
                     WHERE t500.t500_id = p_session_id;

        SELECT COUNT (t501.t501_id)
          INTO l_countstatus
          FROM t501_payment_detail_c t501
         WHERE     t501.t501_payment_session_id_t500 = p_session_id
               AND t501.t501_status_id_v01 <> 3;

        IF (l_countstatus = 0)
        THEN
            UPDATE t500_payment_sessions_c t500
               SET t500.t500_status_id_v01 = 3
             WHERE t500.t500_id = p_session_id;
        ELSE
            UPDATE t500_payment_sessions_c t500
               SET t500.t500_status_id_v01 = 1
             WHERE t500.t500_id = p_session_id;
        END IF;
    END IF;
END;
/