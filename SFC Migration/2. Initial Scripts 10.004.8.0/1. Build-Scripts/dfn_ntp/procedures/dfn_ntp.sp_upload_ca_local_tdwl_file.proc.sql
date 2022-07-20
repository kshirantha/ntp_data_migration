CREATE OR REPLACE PROCEDURE dfn_ntp.sp_upload_ca_local_tdwl_file (
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
    p_ext_table_name           IN     VARCHAR,
    p_batch_id                 IN     NUMBER)
IS
    l_pending_txn          NUMBER;
    l_concurrent_process   NUMBER;
    l_blob_id              NUMBER;
    l_error_reason         NVARCHAR2 (4000);
    l_qry                  VARCHAR2 (15000);
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
            p_key := -3;
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
             WHERE     u53_code = 'CA_LOCAL'
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
                DELETE FROM t33_corporate_actions
                      WHERE t33_primary_institute_id_m02 =
                                p_primary_institution_id;

                /*INSERT INTO t33_corporate_actions (
                                t33_broker_code,
                                t33_equator_no,
                                t33_symbol,
                                t33_isin,
                                t33_current_qty,
                                t33_available_qty,
                                t33_pledged_qty,
                                t33_position_date,
                                t33_change_date,
                                t33_primary_institute_id_m02)
                    SELECT e01.*, p_primary_institution_id
                      FROM e01_corporate_actions e01;*/

                EXECUTE IMMEDIATE
                       'INSERT INTO t33_corporate_actions ('
                    || 't33_broker_code,'
                    || 't33_equator_no,'
                    || 't33_symbol,'
                    || 't33_isin,'
                    || 't33_current_qty,'
                    || 't33_available_qty,'
                    || 't33_pledged_qty,'
                    || 't33_position_date,'
                    || 't33_change_date,'
                    || 't33_primary_institute_id_m02,'
                    || 't33_batch_id_t80)'
                    || 'SELECT e01.*, '
                    || p_primary_institution_id
                    || ',' || p_batch_id
                    || ' FROM '
                    || p_ext_table_name
                    || ' e01';
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            p_key := -1;
    END;
END;
/