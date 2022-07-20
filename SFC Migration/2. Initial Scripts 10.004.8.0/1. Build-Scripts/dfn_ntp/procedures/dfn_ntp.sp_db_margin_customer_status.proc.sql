CREATE OR REPLACE PROCEDURE dfn_ntp.sp_db_margin_customer_status (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    p_institution_id   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT 'UTILIZED' margin_customer_type,
               COUNT (utilized.u23_id) AS margin_customer_type_count
          FROM vw_dc_margin_customers utilized
         WHERE     utilized.total_cash_balance < 0
               AND utilized.u01_institute_id_m02 = p_institution_id
        UNION
        SELECT 'ENABLED' margin_customer_type,
               COUNT (enabled.u23_id) AS margin_customer_type_count
          FROM vw_dc_margin_customers enabled
         WHERE     enabled.u06_margin_enabled = 1
               AND enabled.u01_institute_id_m02 = p_institution_id
        UNION
        SELECT 'EXPIRED' margin_customer_type,
               COUNT (expired.u23_id) AS margin_customer_type_count
          FROM vw_dc_margin_customers expired
         WHERE     expired.u06_margin_enabled = 1
               AND expired.u01_institute_id_m02 = p_institution_id;
END;
/