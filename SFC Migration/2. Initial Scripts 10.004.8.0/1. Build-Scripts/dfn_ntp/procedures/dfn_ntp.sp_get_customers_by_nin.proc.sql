CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_customers_by_nin (
    p_view                  OUT SYS_REFCURSOR,
    prows                   OUT NUMBER,
    pu01_id              IN     NUMBER,
    pu01_default_id_no        IN     VARCHAR,
    pu01_default_id_type_id   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT u01.u01_id,
               u01.u01_full_name,
               u01.u01_full_name_lang,
               u01.u01_customer_no,
               u01.u01_external_ref_no,
               u05.u05_id_no
          FROM     u01_customer u01
               JOIN
                   u05_customer_identification u05
               ON u01.u01_id = u05.u05_customer_id_u01
         WHERE     u01.u01_account_type_id_v01 <> 1
               AND u01.u01_id <> pu01_id
               AND u05.u05_id_no = pu01_default_id_no
               AND u01.u01_default_id_type_m15 = pu01_default_id_type_id;
END;
/