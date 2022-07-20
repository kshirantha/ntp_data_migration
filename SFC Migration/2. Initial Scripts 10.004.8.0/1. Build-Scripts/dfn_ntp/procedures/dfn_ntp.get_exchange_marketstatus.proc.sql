CREATE OR REPLACE PROCEDURE dfn_ntp.get_exchange_marketstatus (
    p_view                    OUT SYS_REFCURSOR,
    prows                     OUT NUMBER,
    pm59_exchange_id_m01   IN     VARCHAR2)
IS
    status   NUMBER;
BEGIN
    status := 0;

    OPEN p_view FOR
        SELECT v19.v19_id,
               v19.v19_status,
               m59.m59_id,
               m59.m59_exchange_id_m01,
               m59.m59_market_status_id_v19,
               CASE WHEN m59.m59_id IS NULL THEN 0 ELSE 1 END AS enabled
          FROM     v19_market_status v19
               LEFT JOIN
                   (SELECT *
                      FROM m59_exchange_market_status m59
                     WHERE m59_exchange_id_m01 = pm59_exchange_id_m01) m59
               ON v19.v19_id = m59.m59_market_status_id_v19;
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
