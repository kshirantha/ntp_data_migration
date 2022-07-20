CREATE OR REPLACE PROCEDURE dfn_ntp.get_trd_channel_restriction (
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
            u18_channel_id_v29 AS v29_id,
            v29.v29_description,
            MAX(
                CASE
                    WHEN u18.u18_restriction_id_v31 = 16 THEN 1
                    ELSE 0
                END
            ) AS buy_r,
            MAX(
                CASE
                    WHEN u18.u18_restriction_id_v31 = 17 THEN 1
                    ELSE 0
                END
            ) AS sell_r
        FROM
            u18_trading_channel_restrict u18
            INNER JOIN v29_order_channel v29 ON u18.u18_channel_id_v29 = v29.v29_id
        WHERE
            u18.u18_trd_acnt_id_u07 IN ('
        || pu07id
        || ')
        GROUP BY
            u18_channel_id_v29,
            v29.v29_description
        ORDER BY
            v29.v29_description';

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