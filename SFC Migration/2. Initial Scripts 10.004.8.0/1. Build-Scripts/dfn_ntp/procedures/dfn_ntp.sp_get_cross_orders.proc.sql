CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_cross_orders (
    pkey             OUT NUMBER,
    customer_id   IN     NUMBER,
    order_type    IN     NUMBER,
    symbol_id     IN     NUMBER,
    side          IN     NUMBER,
    price         IN     NUMBER)
IS
BEGIN
    pkey := 0;

    IF order_type = 2
    THEN
        SELECT COUNT (t01.t01_cl_ord_id)
          INTO pkey
          FROM t01_order t01,
               u05_customer_identification u05,
               (SELECT u05.u05_identity_type_id_m15, u05.u05_id_no
                  FROM u05_customer_identification u05
                 WHERE u05.u05_customer_id_u01 = customer_id) cust_ids
         WHERE     t01.t01_date BETWEEN TRUNC (SYSDATE) - 5
                                    AND TRUNC (SYSDATE)
               AND t01.t01_symbol_id_m20 = symbol_id
               -- AND t01.t01_exchange = exchange
               AND t01.t01_status_id_v30 IN
                       ('A', '0', 'O', '1', '5', 'M', 'K')
               AND (side = 1 OR (t01.t01_side = 1 AND t01.t01_price >= price))
               AND (side = 2 OR (t01.t01_side = 2 AND t01.t01_price <= price))
               AND t01.t01_customer_id_u01 = u05.u05_customer_id_u01
               AND u05.u05_identity_type_id_m15 =
                       cust_ids.u05_identity_type_id_m15
               AND u05.u05_id_no = cust_ids.u05_id_no;
    ELSIF order_type = 1
    THEN
        SELECT COUNT (t01.t01_cl_ord_id)
          INTO pkey
          FROM t01_order t01,
               u05_customer_identification u05,
               (SELECT u05.u05_identity_type_id_m15, u05.u05_id_no
                  FROM u05_customer_identification u05
                 WHERE u05.u05_customer_id_u01 = customer_id) cust_ids
         WHERE     t01.t01_date BETWEEN TRUNC (SYSDATE) - 5
                                    AND TRUNC (SYSDATE)
               AND t01.t01_symbol_id_m20 = symbol_id
               -- AND t01.t01_exchange = exchange
               AND t01.t01_status_id_v30 IN
                       ('A', '0', 'O', '1', '5', 'M', 'K')
               AND (side = 1 OR t01.t01_side = 1)
               AND (side = 2 OR t01.t01_side = 2)
               AND t01.t01_customer_id_u01 = u05.u05_customer_id_u01
               AND u05.u05_identity_type_id_m15 =
                       cust_ids.u05_identity_type_id_m15
               AND u05.u05_id_no = cust_ids.u05_id_no;
    END IF;

    IF pkey <> 0
    THEN
        pkey := 1;
    END IF;
END;
/
