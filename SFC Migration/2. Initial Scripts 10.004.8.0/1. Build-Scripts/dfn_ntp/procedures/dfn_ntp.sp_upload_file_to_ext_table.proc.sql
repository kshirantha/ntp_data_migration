CREATE OR REPLACE PROCEDURE dfn_ntp.sp_upload_file_to_ext_table (
    p_key                         OUT VARCHAR,
    p_blob_code                IN     VARCHAR,
    p_blob_description         IN     VARCHAR,
    p_blob_data                IN     BLOB,
    p_blob_compressed          IN     NUMBER,
    p_blob_uploaded_by         IN     NUMBER,
    p_position_date            IN     VARCHAR,
    p_ext_table_directory      IN     VARCHAR,
    p_ext_table_mapped_file    IN     VARCHAR,
    p_primary_institution_id   IN     NUMBER DEFAULT 1)
IS
    l_blob_id        NUMBER;
    l_error_reason   NVARCHAR2 (4000);
BEGIN
    BEGIN
        p_key := 1;
        sp_upload_file_as_blob (l_blob_id,
                                p_blob_code,
                                p_blob_description,
                                p_blob_data,
                                TO_DATE (p_position_date, 'DD-MON-YYYY'),
                                p_blob_compressed,
                                p_blob_uploaded_by,
                                p_primary_institution_id);

        IF l_blob_id > 0
        THEN
            sp_write_blob_to_file (l_blob_id,
                                   p_ext_table_directory,
                                   p_ext_table_mapped_file);
        END IF;

        p_key := l_blob_id;
    EXCEPTION
        WHEN OTHERS
        THEN
            IF l_blob_id > 0
            THEN
                l_error_reason := SUBSTR (SQLERRM, 1, 512);

                UPDATE u53_process_detail
                   SET u53_failed_reason =
                           'File Upload Failed - ' || l_error_reason
                 WHERE u53_id = l_blob_id;
            END IF;

            p_key := -1;
    END;
END;
/
