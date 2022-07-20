CREATE OR REPLACE PROCEDURE dfn_ntp.sp_upload_file_as_blob (
    p_key                         OUT VARCHAR,
    p_u53_code                 IN     NVARCHAR2,
    p_u53_description          IN     NVARCHAR2,
    p_u53_data                 IN     BLOB,
    p_u53_position_date        IN     DATE,
    p_u53_compressed           IN     NUMBER,
    p_u53_uploaded_by          IN     NUMBER,
    p_primary_institution_id   IN     NUMBER DEFAULT 1)
IS
    l_count            NUMBER;
    l_current_status   NUMBER;
BEGIN
    BEGIN
        SELECT COUNT (*)
          INTO l_count
          FROM u53_process_detail
         WHERE     u53_code = p_u53_code
               AND u53_status_id_v01 = 18
               AND u53_primary_institute_id_m02 = p_primary_institution_id;

        IF l_count > 0
        THEN
            p_key := -2;
            RETURN;
        ELSE
            DELETE FROM u53_process_detail
                  WHERE     u53_code = p_u53_code
                        AND u53_primary_institute_id_m02 =
                                p_primary_institution_id;
        END IF;

        SELECT NVL (MAX (u53_id), 0) + 1 INTO p_key FROM u53_process_detail;

        INSERT INTO u53_process_detail (u53_id,
                                        u53_code,
                                        u53_description,
                                        u53_data,
                                        u53_position_date,
                                        u53_compressed,
                                        u53_status_id_v01,
                                        u53_updated_by_id_u17,
                                        u53_updated_date_time,
                                        u53_primary_institute_id_m02)
             VALUES (p_key,
                     p_u53_code,
                     p_u53_description,
                     p_u53_data,
                     p_u53_position_date,
                     p_u53_compressed,
                     1,
                     p_u53_uploaded_by,
                     SYSDATE,
                     p_primary_institution_id);
    EXCEPTION
        WHEN OTHERS
        THEN
            p_key := -1;
    END;
END;
/
