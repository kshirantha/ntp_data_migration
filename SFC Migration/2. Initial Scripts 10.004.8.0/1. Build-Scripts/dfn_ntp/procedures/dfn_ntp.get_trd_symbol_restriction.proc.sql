CREATE OR REPLACE PROCEDURE dfn_ntp.get_trd_symbol_restriction (
    p_view      OUT SYS_REFCURSOR,
    prows       OUT NUMBER,
    pu07id   IN     VARCHAR2 DEFAULT NULL,
    ppoaid   IN     VARCHAR2 DEFAULT NULL)
IS
    status   NUMBER;
    l_qry    VARCHAR2 (15000);
BEGIN
    status := 0;

    IF pu07id IS NOT NULL
    THEN
        l_qry :=
               'SELECT m20_id,
                     m20.m20_symbol_code,
                     MAX (
                         CASE
                             WHEN u14_restriction_id_v31 = 12 THEN 1
                             ELSE 0
                         END)
                         AS buy_r,
                     MAX (
                         CASE
                             WHEN u14_restriction_id_v31 = 13 THEN 1
                             ELSE 0
                         END)
                         AS sell_r
                FROM     u14_trading_symbol_restriction u14
                     INNER JOIN
                         m20_symbol m20
                     ON u14.u14_symbol_id_m20 = m20.m20_id
               WHERE u14_trd_acnt_id_u07 IN ('
            || pu07id
            || ')
            GROUP BY m20_id, m20.m20_symbol_code
            ORDER BY m20.m20_symbol_code';

        OPEN p_view FOR l_qry;
    ELSIF ppoaid IS NOT NULL
    THEN
        OPEN p_view FOR
              SELECT m20_id,
                     MAX (m20_symbol_code) m20_symbol_code,
                     MAX (m20_exchange_code_m01) m20_exchange_code_m01,
                     MAX (
                         CASE
                             WHEN u51.u51_restriction_id_v31 = 12 THEN 1
                             ELSE 0
                         END)
                         AS buy_r,
                     MAX (
                         CASE
                             WHEN u51.u51_restriction_id_v31 = 13 THEN 1
                             ELSE 0
                         END)
                         AS sell_r
                FROM     u51_poa_symbol_restriction u51
                     INNER JOIN
                         m20_symbol m20
                     ON u51.u51_symbol_id_m20 = m20.m20_id
               WHERE u51.u51_poa_id_u47 = ppoaid
            GROUP BY m20_id;
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