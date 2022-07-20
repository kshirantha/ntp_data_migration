CREATE OR REPLACE PROCEDURE dfn_ntp.get_exchange_ordertypes (
    p_view                    OUT SYS_REFCURSOR,
    prows                     OUT NUMBER,
    pm57_m01_exchange_id   IN     VARCHAR2)
IS
    status   NUMBER;
BEGIN
    status := 0;

    OPEN p_view FOR
        SELECT v06.v06_id,
               v06.v06_type_id,
               v06.v06_description_1,
               v06.v06_description_2,
               m57.m57_id,
               m57.m57_exchange_id_m01,
               m57.m57_order_type_id_v06,
               CASE WHEN m57.m57_id IS NULL THEN 0 ELSE 1 END AS enabled
          FROM     v06_order_type v06
               LEFT JOIN
                   (SELECT *
                      FROM m57_exchange_order_types m57
                     WHERE m57_exchange_id_m01 = pm57_m01_exchange_id) m57
               ON v06.v06_id = m57.m57_order_type_id_v06;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/
/
