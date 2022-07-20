CREATE OR REPLACE PROCEDURE dfn_ntp.get_available_symbols (
    p_view                 OUT SYS_REFCURSOR,
    prows                  OUT NUMBER,
    pexchangeid         IN     VARCHAR2,
    ptradingaccountid   IN     VARCHAR2 DEFAULT NULL,
    ppoaid              IN     NUMBER DEFAULT NULL)
IS
    status   NUMBER;
    l_qry    VARCHAR2 (15000);
BEGIN
    status := 0;

    IF ptradingaccountid IS NOT NULL
    THEN
        l_qry :=
               'SELECT m.m20_id, m.m20_symbol_code, m.m20_exchange_id_m01
              FROM m20_symbol m
             WHERE     m.m20_exchange_id_m01 = '
            || pexchangeid
            || '
                   AND m.m20_id NOT IN
                           (SELECT u.u14_symbol_id_m20
                              FROM u14_trading_symbol_restriction u
                             WHERE u.u14_trd_acnt_id_u07 IN  ('
            || ptradingaccountid
            || ')) ORDER BY m.m20_symbol_code';



        OPEN p_view FOR l_qry;
    ELSIF ppoaid IS NOT NULL
    THEN
        OPEN p_view FOR
              SELECT m.m20_id, m.m20_symbol_code, m.m20_exchange_id_m01
                FROM m20_symbol m
               WHERE     m.m20_exchange_id_m01 = pexchangeid
                     AND m.m20_id NOT IN (SELECT u.u51_symbol_id_m20
                                            FROM u51_poa_symbol_restriction u
                                           WHERE u.u51_poa_id_u47 = ppoaid)
            ORDER BY m.m20_symbol_code;
    ELSE
        OPEN p_view FOR
              SELECT m.m20_id, m.m20_symbol_code, m.m20_exchange_id_m01
                FROM m20_symbol m
               WHERE m.m20_exchange_id_m01 = pexchangeid
            ORDER BY m.m20_symbol_code;
    END IF;
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
