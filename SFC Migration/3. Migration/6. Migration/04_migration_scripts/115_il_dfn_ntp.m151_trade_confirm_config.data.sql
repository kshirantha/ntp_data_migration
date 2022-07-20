DECLARE
    l_trade_confirm_config   NUMBER;
BEGIN
    SELECT NVL (MAX (m151_id), 0)
      INTO l_trade_confirm_config
      FROM dfn_ntp.m151_trade_confirm_config;

    FOR i IN (SELECT m151.*, m02.m02_id
                FROM (SELECT *
                        FROM dfn_ntp.m02_institute
                       WHERE m02_id > 0) m02, -- [Cross Join - Repeating for each Institution]
                     dfn_ntp.m151_trade_confirm_config m151
               WHERE m02.m02_id = m151.m151_institute_id_m02(+))
    LOOP
        IF i.m151_id IS NULL
        THEN
            l_trade_confirm_config := l_trade_confirm_config + 1;

            INSERT
              INTO dfn_ntp.m151_trade_confirm_config (
                       m151_id,
                       m151_name,
                       m151_code,
                       m151_is_default,
                       m151_is_clearing,
                       m151_is_symbol,
                       m151_is_market,
                       m151_is_order_side,
                       m151_is_custodian,
                       m151_status_id_v01,
                       m151_created_by_id_u17,
                       m151_created_date,
                       m151_modified_by_id_u17,
                       m151_modified_date,
                       m151_status_changed_by_id_u17,
                       m151_status_changed_date,
                       m151_institute_id_m02,
                       m151_custom_type,
                       m151_trade_confirm_format_v12)
            VALUES (l_trade_confirm_config,
                    'Default',
                    'TCS',
                    1,
                    0,
                    0,
                    0,
                    0,
                    0,
                    2,
                    0,
                    SYSDATE,
                    NULL,
                    NULL,
                    0,
                    SYSDATE,
                    i.m02_id,
                    '1',
                    1);
        END IF;
    END LOOP;
END;
/