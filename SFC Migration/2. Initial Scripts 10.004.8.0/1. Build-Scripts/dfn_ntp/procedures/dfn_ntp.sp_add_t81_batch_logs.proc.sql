CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_t81_batch_logs (
    p_key              OUT NUMBER,
    p_batch_id      IN     NUMBER,
    p_log_type      IN     NUMBER,
    p_log_message   IN     VARCHAR)
IS
BEGIN
    SELECT seq_t81_id.NEXTVAL INTO p_key FROM DUAL;


    INSERT INTO t81_file_processing_log (t81_id,
                                         t81_batch_id_t80,
                                         t81_date,
                                         t81_log_type,
                                         t81_description,
                                         t81_custom_type)
         VALUES (p_key,
                 p_batch_id,
                 SYSDATE,
                 p_log_type,
                 p_log_message,
                 '1');
EXCEPTION
    WHEN OTHERS
    THEN
        p_key := -1;
END;                                                              -- Procedure
/
