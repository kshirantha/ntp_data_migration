CREATE OR REPLACE PROCEDURE dfn_ntp.sp_upload_weekly_file (
    p_key                         OUT VARCHAR,
    p_blob_code                IN     VARCHAR,
    p_blob_description         IN     VARCHAR,
    p_blob_data                IN     BLOB,
    p_blob_compressed          IN     NUMBER,
    p_blob_uploaded_by         IN     NUMBER,
    p_position_date            IN     VARCHAR,
    p_ext_table_directory      IN     VARCHAR,
    p_ext_table_mapped_file    IN     VARCHAR,
    p_primary_institution_id   IN     NUMBER DEFAULT 1,
    p_batch_id                 IN     NUMBER)
IS
    l_pending_txn          NUMBER;
    l_concurrent_process   NUMBER;
    l_blob_id              NUMBER;
    l_error_reason         NVARCHAR2 (4000);
BEGIN
    BEGIN
        SELECT NVL (MIN (t80_id), 0)
          INTO l_pending_txn
          FROM t80_file_processing_batches t80
         WHERE     t80_config_id_m40 IN
                       (SELECT m42_config_id_m40
                          FROM m42_file_processing_tables m42
                         WHERE m42.m42_table_name IN
                                   ('T23_SHARE_TXN_REQUESTS'))
               AND t80.t80_status_id_v01 IN (18, 28, 1)
               AND t80.t80_primary_institute_id_m02 =
                       p_primary_institution_id
               AND t80.t80_id <> p_batch_id;

        SELECT COUNT (*)
          INTO l_concurrent_process
          FROM u53_process_detail t23
         WHERE u53_code = p_blob_code AND u53_status_id_v01 = 19;

        IF l_pending_txn > 0
        THEN
            p_key := -3 || '|' || l_pending_txn;
            RETURN;
        ELSIF l_concurrent_process > 0
        THEN
            p_key := -4;
            RETURN;
        ELSE
            UPDATE u53_process_detail
               SET u53_status_id_v01 = 19,
                   u53_failed_reason = NULL,
                   u53_updated_by_id_u17 = p_blob_uploaded_by,
                   u53_updated_date_time = SYSDATE
             WHERE     u53_code = 'WEEKLY'
                   AND u53_primary_institute_id_m02 =
                           p_primary_institution_id;


            sp_upload_file_to_ext_table (p_key,
                                         p_blob_code,
                                         p_blob_description,
                                         p_blob_data,
                                         p_blob_compressed,
                                         p_blob_uploaded_by,
                                         p_position_date,
                                         p_ext_table_directory,
                                         p_ext_table_mapped_file,
                                         p_primary_institution_id);

            IF p_key > 0
            THEN
                INSERT INTO t32_weekly_reconciliation (
                                t32_broker_code,
                                t32_equator_no,
                                t32_symbol,
                                t32_isin,
                                t32_current_qty,
                                t32_available_qty,
                                t32_pledged_qty,
                                t32_position_date,
                                t32_change_date,
                                t32_primary_institute_id_m02,
                                t32_batch_id_t80)
                    SELECT e03.*, p_primary_institution_id, p_batch_id
                      FROM e03_weekly_reconciliation e03;
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            p_key := -1;
    END;
END;
/
