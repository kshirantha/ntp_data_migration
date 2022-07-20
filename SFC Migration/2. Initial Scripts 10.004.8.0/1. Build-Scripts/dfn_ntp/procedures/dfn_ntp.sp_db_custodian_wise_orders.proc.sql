CREATE OR REPLACE PROCEDURE dfn_ntp.sp_db_custodian_wise_orders (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    p_institution_id   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
          SELECT custodian_type, COUNT (*) AS custoian_count
            FROM vw_order_list orders
           WHERE orders.t01_institution_id_m02 = p_institution_id
        GROUP BY orders.custodian_type;
END;
/

