CREATE OR REPLACE PROCEDURE dfn_ntp.sp_stop_trading_tradeable_rht
IS
BEGIN
    FOR i
        IN (SELECT map.symbol AS m77_symbol, map.exchange AS m77_excahnge
              FROM dfn_price.esp_symbolmap map
             WHERE     instrumenttype = 66
                   AND TRUNC (map.first_subs_expdate) = func_get_eod_date)
    LOOP
        UPDATE m20_symbol m20
           SET m20.m20_trading_status_id_v22 = 2,
               m20.m20_modified_by_id_u17 = 0,
               m20.m20_modified_date = SYSDATE
         WHERE     m20.m20_exchange_code_m01 = i.m77_excahnge
               AND m20.m20_symbol_code = i.m77_symbol;
    END LOOP;
END;
/