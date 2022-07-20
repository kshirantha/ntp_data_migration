CREATE OR REPLACE PROCEDURE dfn_ntp.get_exchange_tif (
    p_view                    OUT SYS_REFCURSOR,
    prows                     OUT NUMBER,
    pm58_exchange_id_m01   IN     VARCHAR2)
IS
    status   NUMBER;
BEGIN
    status := 0;

    OPEN p_view FOR
        SELECT v10.v10_id,
               v10.v10_description,
               m58.m58_id,
               m58.m58_exchange_id_m01,
               m58.m58_tif_id_v10,
               CASE WHEN m58.m58_id IS NULL THEN 0 ELSE 1 END AS enabled
          FROM     v10_tif v10
               LEFT JOIN
                   (SELECT *
                      FROM m58_exchange_tif m58
                     WHERE m58_exchange_id_m01 = pm58_exchange_id_m01) m58
               ON v10.v10_id = m58.m58_tif_id_v10;
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
