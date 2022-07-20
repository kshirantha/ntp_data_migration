CREATE OR REPLACE PROCEDURE dfn_ntp.sp_upload_eod_tdwl_file (
    p_key                         OUT VARCHAR,
    p_blob_code                IN     VARCHAR,
    p_blob_description         IN     VARCHAR,
    p_blob_data                IN     BLOB,
    p_blob_compressed          IN     NUMBER,
    p_blob_uploaded_by         IN     NUMBER,
    p_position_date            IN     VARCHAR,
    p_ext_table_directory      IN     VARCHAR,
    p_ext_table_mapped_file    IN     VARCHAR,
    p_primary_institution_id   IN     NUMBER DEFAULT 0)
IS
    l_pending_txn    NUMBER;
    l_blob_id        NUMBER;
    l_error_reason   NVARCHAR2 (4000);
BEGIN
    BEGIN
        SELECT COUNT (*)
          INTO l_pending_txn
          FROM u53_process_detail t23
         WHERE u53_code = p_blob_code AND u53_status_id_v01 = 19;

        IF l_pending_txn > 0
        THEN
            p_key := -3;
            RETURN;
        ELSE
            UPDATE u53_process_detail
               SET u53_status_id_v01 = 19,
                   u53_failed_reason = NULL,
                   u53_updated_by_id_u17 = p_blob_uploaded_by,
                   u53_updated_date_time = SYSDATE
             WHERE     u53_code = p_blob_code
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
                DELETE FROM t31_eod_fix_log
                      WHERE t31_primary_institute_id =
                                p_primary_institution_id;

                INSERT INTO t31_eod_fix_log (t31_sequence,
                                             t31_reverse_exec,
                                             t31_fix_record,
                                             t31_exec_id,
                                             t31_primary_institute_id)
                    SELECT *
                      FROM e02_eod_fix_log a
                     WHERE a.e02_primary_institute_id =
                               p_primary_institution_id;
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            p_key := -1;
    END;
END;
/
