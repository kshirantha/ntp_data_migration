CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_t80_batch (
    p_key                       OUT NUMBER,
    p_config_id              IN     NUMBER,
    p_user_id                IN     NUMBER,
    p_is_auto                IN     NUMBER DEFAULT 0,
    p_primary_institute_id   IN     NUMBER,
    p_file_date              IN     DATE)
IS
BEGIN
    SELECT seq_t80_id.NEXTVAL INTO p_key FROM DUAL;


    INSERT INTO t80_file_processing_batches (t80_id,
                                             t80_config_id_m40,
                                             t80_job_time,
                                             t80_created_by_id_u17,
                                             t80_created_date,
                                             t80_modified_by_id_u17,
                                             t80_modified_date,
                                             t80_status_id_v01,
                                             t80_status_changed_by_id_u17,
                                             t80_status_changed_date,
                                             t80_batch_type,
                                             t80_custom_type,
                                             t80_primary_institute_id_m02,
                                             t80_file_date)
         VALUES (p_key,
                 p_config_id,
                 SYSDATE,
                 p_user_id,
                 SYSDATE,
                 NULL,
                 NULL,
                 1,
                 p_user_id,
                 SYSDATE,
                 p_is_auto,
                 1,
                 p_primary_institute_id,
                 p_file_date);
EXCEPTION
    WHEN OTHERS
    THEN
        p_key := -1;
END;                                                              -- Procedure
/
