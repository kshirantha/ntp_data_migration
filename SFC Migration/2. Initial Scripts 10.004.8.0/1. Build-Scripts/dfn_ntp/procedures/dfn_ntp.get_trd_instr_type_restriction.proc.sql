CREATE OR REPLACE PROCEDURE dfn_ntp.get_trd_instr_type_restriction (
    p_view      OUT SYS_REFCURSOR,
    prows       OUT NUMBER,
    pu07id   IN     VARCHAR2)
IS
    status   NUMBER;
    l_qry    VARCHAR2 (15000);
BEGIN
    status := 0;

    l_qry :=
           'SELECT
            u16_instrument_id_v09 AS v09_id,
            v09.v09_code,
            v09.v09_description,
            MAX(
                CASE
                    WHEN u16.u16_restriction_id_v31 = 14 THEN 1
                    ELSE 0
                END
            ) AS buy_r,
            MAX(
                CASE
                    WHEN u16.u16_restriction_id_v31 = 15 THEN 1
                    ELSE 0
                END
            ) AS sell_r
        FROM
            u16_trading_instrument_restric u16
            INNER JOIN v09_instrument_types v09 ON u16.u16_instrument_id_v09 = v09.v09_id
        WHERE
            u16.u16_trd_acnt_id_u07 IN ('
        || pu07id
        || ')
        GROUP BY
            u16_instrument_id_v09,
            v09.v09_code,
            v09.v09_description
        ORDER BY
            v09.v09_code';

    OPEN p_view FOR l_qry;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/