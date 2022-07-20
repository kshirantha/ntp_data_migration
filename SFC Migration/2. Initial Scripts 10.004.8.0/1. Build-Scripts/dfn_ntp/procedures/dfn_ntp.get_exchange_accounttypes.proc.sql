CREATE OR REPLACE PROCEDURE dfn_ntp.get_exchange_accounttypes (
    p_view                     OUT SYS_REFCURSOR,
    prows                      OUT NUMBER,
    pm186_m01_exchange_id   IN     VARCHAR2)
IS
    status   NUMBER;
BEGIN
    status := 0;

    OPEN p_view FOR
          SELECT v37.v37_type_id,
                 v37.v37_description_1,
                 v37.v37_description_2,
                 v37.v37_id,
                 CASE WHEN m186.m186_id IS NULL THEN 0 ELSE 1 END AS enabled,
                 CASE
                     WHEN m186.m186_is_default IS NULL THEN 0
                     ELSE m186.m186_is_default
                 END
                     AS m186_is_default,
                 m186.m186_id
            FROM     v37_trading_acc_types v37
                 LEFT JOIN
                     m186_exg_trading_acc_types m186
                 ON     v37.v37_id = m186.m186_account_type_id_v37
                    AND m186_exchange_id_m01 = pm186_m01_exchange_id
        ORDER BY v37_type_id;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/