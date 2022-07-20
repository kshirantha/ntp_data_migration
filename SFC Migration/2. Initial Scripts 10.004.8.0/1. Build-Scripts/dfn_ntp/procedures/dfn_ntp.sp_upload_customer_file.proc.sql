CREATE OR REPLACE PROCEDURE dfn_ntp.sp_upload_customer_file (
     p_key                         OUT VARCHAR,
    p_blob_code                IN     VARCHAR,
    p_blob_description         IN     VARCHAR,
    p_blob_data                IN     BLOB,
    p_blob_compressed          IN     NUMBER,
    p_blob_uploaded_by         IN     NUMBER,
    p_position_date            IN     VARCHAR,
    p_ext_table_directory      IN     VARCHAR,
    p_ext_table                IN     VARCHAR,
    p_ext_table_mapped_file    IN     VARCHAR,
    p_primary_institution_id   IN     NUMBER DEFAULT 0,
    p_batch_id                 IN     NUMBER)
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
                INSERT INTO t84_customer_f (t84_member,
                                            t84_account,
                                            t84_reference,
                                            t84_identification_number,
                                            t84_registry_ident,
                                            t84_birth_date,
                                            t84_title,
                                            t84_long_name,
                                            t84_guardian_ident_number,
                                            t84_guardian,
                                            t84_address_line_one,
                                            t84_address_line_two,
                                            t84_address_line_three,
                                            t84_postal_code,
                                            t84_city,
                                            t84_tax_collection_point,
                                            t84_country_code,
                                            t84_guard_address_line_one,
                                            t84_postal_code2,
                                            t84_city2,
                                            t84_tax_collection_point2,
                                            t84_country_code2,
                                            t84_phone_number_one,
                                            t84_swift_code,
                                            t84_bank_account,
                                            t84_individual_id_one,
                                            t84_individual_id_two,
                                            t84_individual_id_three,
                                            t84_corporate_id_one,
                                            t84_corporate_id_two,
                                            t84_citizenship,
                                            t84_gender,
                                            t84_change_date,
                                            t84_primary_institute_id_m02,
                                            t84_batch_id_t80)
                    SELECT e6.*, p_primary_institution_id, p_batch_id
                      FROM e_tmpl_6_customer_default e6;
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            l_error_reason := SUBSTR (SQLERRM, 1, 512);

            UPDATE u53_process_detail
               SET u53_failed_reason =
                       'Customer File Upload Failed - ' || l_error_reason
             WHERE u53_id = l_blob_id;

            p_key := -1;
    END;
END;
/