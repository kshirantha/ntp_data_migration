CREATE OR REPLACE PROCEDURE dfn_ntp.sp_db_customer_status_types (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    p_institution_id   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT 'LOCKED' AS cust_type, COUNT (locked.u09_id) AS cust_count
          FROM vw_u09_acc_locked_customer locked
         WHERE locked.u01_institute_id_m02 = p_institution_id
        UNION
        SELECT 'EXPIRED' AS cust_type, COUNT (expired.u01_id) AS cust_count
          FROM vw_id_expired_customer_list expired
         WHERE expired.u01_institute_id_m02 = p_institution_id
        UNION
        SELECT 'FROZEN' AS cust_type, COUNT (frozen.u05_id) AS cust_count
          FROM vw_u05_customer_acc_frozen frozen
         WHERE frozen.u01_institute_id_m02 = p_institution_id;
END;
/