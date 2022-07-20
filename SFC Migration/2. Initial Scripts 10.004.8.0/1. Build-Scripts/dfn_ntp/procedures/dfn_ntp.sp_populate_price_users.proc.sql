CREATE OR REPLACE PROCEDURE dfn_ntp.sp_populate_price_users (
    p_institute_id    IN NUMBER,
    p_created_by_id   IN NUMBER DEFAULT 0)
IS
BEGIN
    BEGIN
        INSERT INTO m161_price_user_pool (m161_id,
                                          m161_price_user,
                                          m161_price_password,
                                          m161_type,
                                          m161_status,
                                          m161_expiry_date,
                                          m161_created_date,
                                          m161_created_by_id_u17,
                                          m161_primary_institute_id_m02)
            SELECT seq_m161_id.NEXTVAL,
                   m161_price_user,
                   m161_price_password,
                   m161_type,
                   m161_execution_status,
                   TO_DATE (m161_expiry_date, 'dd/MM/yyyy'),
                   SYSDATE,
                   p_created_by_id,
                   m161_primary_institute_id_m02
              FROM m161_uploaded_price_user_pool
             WHERE     m161_execution_status IN (0, 1)
                   AND m161_primary_institute_id_m02 = p_institute_id;
    END;
END;
/