CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_symbol_prices
(
    exchange_id,
    exchange_code,
    symbol_id,
    symbol_code,
    currency_code,
    currency_id,
    last_trade_time,
    last_trade_price,
    previous_closed,
    min_price,
    max_price,
    todays_closed,
    vwap,
    market_price,
    m20_institute_id_m02
)
AS
    (SELECT m20.m20_exchange_id_m01 AS exchange_id,
            m20.m20_exchange_code_m01 AS exchange_code,
            m20.m20_id AS symbol_id,
            m20.m20_symbol_code AS symbol_code,
            m20.m20_currency_code_m03 AS currency_code,
            m20.m20_currency_id_m03 AS currency_id,
            m20.m20_date_of_last_price AS last_trade_time,
            m20.m20_lasttradeprice * m20.m20_price_ratio AS last_trade_price,
            m20.m20_previous_closed * m20.m20_price_ratio AS previous_closed,
            m20.m20_minprice * m20.m20_price_ratio AS min_price,
            m20.m20_maxprice * m20.m20_price_ratio AS max_price,
            m20.m20_today_closed * m20.m20_price_ratio AS todays_closed,
            m20.m20_vwap * m20.m20_price_ratio AS vwap,
            CASE
                WHEN (m20.m20_today_closed > 0)
                THEN
                    m20.m20_today_closed * m20.m20_price_ratio
                WHEN (m20.m20_lasttradeprice > 0)
                THEN
                    m20.m20_lasttradeprice * m20.m20_price_ratio
                ELSE
                    m20.m20_previous_closed * m20.m20_price_ratio
            END
                AS market_price,
            m20_institute_id_m02
     FROM m20_symbol m20)
/