CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_market_price (
    pm20_id                       IN NUMBER,
    pm20_exchange_id_m01          IN NUMBER,
    pm20_instrument_type_id_v09   IN NUMBER)
    RETURN NUMBER
IS
    l_market_price   NUMBER;
BEGIN
    SELECT CASE
               WHEN (m20.m20_today_closed > 0)
               THEN
                   CASE
                       WHEN m20.m20_exchange_code_m01 = 'KSE'
                       THEN
                           ROUND (m20.m20_today_closed / 1000, 5)
                       ELSE
                           m20.m20_today_closed
                   END
               WHEN (m20.m20_lasttradeprice > 0)
               THEN
                   CASE
                       WHEN m20.m20_exchange_code_m01 = 'KSE'
                       THEN
                           ROUND (m20.m20_lasttradeprice / 1000, 5)
                       ELSE
                           m20.m20_lasttradeprice
                   END
               ELSE
                   CASE
                       WHEN m20.m20_exchange_code_m01 = 'KSE'
                       THEN
                           ROUND (m20.m20_previous_closed / 1000, 5)
                       ELSE
                           m20.m20_previous_closed
                   END
           END
               AS market_price
      INTO l_market_price
      FROM m20_symbol m20
     WHERE     m20.m20_id = pm20_id
           AND m20.m20_exchange_id_m01 = pm20_exchange_id_m01
           AND m20.m20_instrument_type_id_v09 = pm20_instrument_type_id_v09;


    RETURN l_market_price;
END;
/
/
