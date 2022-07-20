CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_symbol_list_base
(
    m20_id,
    m20_exchange_id_m01,
    m20_symbol_code,
    m20_short_description,
    m20_short_description_lang,
    m20_long_description,
    m20_long_description_lang,
    m20_market_code_m29,
    m20_instrument_type_code_v09,
    m20_instrument_type_id_v09,
    m20_currency_code_m03,
    m20_currency_id_m03,
    m20_trading_status_id_v22,
    trading_status,
    m20_status_id_v01,
    status,
    m20_access_level_id_v01,
    access_level,
    m20_price_ratio,
    m20_exchange_code_m01,
    m20_small_orders,
    small_orders,
    m20_small_order_value,
    m20_status_changed_by_id_u17,
    status_changed_by,
    m20_is_white_symbol,
    is_white_symbol,
    m20_market_segment,
    market_segment,
    m20_lot_size,
    m20_lasttradeprice,
    m20_isincode,
    m20_institute_id_m02,
    m20_market_id_m29,
    m20_vwap,
    m20_date_of_last_price
)
AS
    SELECT m20.m20_id,
           m20.m20_exchange_id_m01,
           m20.m20_symbol_code,
           m20.m20_short_description,
           m20.m20_short_description_lang,
           m20.m20_long_description,
           m20.m20_long_description_lang,
           m20.m20_market_code_m29,
           m20.m20_instrument_type_code_v09,
           m20.m20_instrument_type_id_v09,
           m20.m20_currency_code_m03,
           m20.m20_currency_id_m03,
           m20.m20_trading_status_id_v22,
           v22.v22_description AS trading_status,
           m20.m20_status_id_v01,
           vw_status_list.v01_description AS status,
           m20.m20_access_level_id_v01,
           vw_access_level.v01_description AS access_level,
           m20.m20_price_ratio,
           m20.m20_exchange_code_m01,
           m20.m20_small_orders,
           CASE m20.m20_small_orders WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS small_orders,
           m20.m20_small_order_value,
           m20.m20_status_changed_by_id_u17,
           u17.u17_full_name AS status_changed_by,
           m20.m20_is_white_symbol,
           CASE m20.m20_is_white_symbol
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS is_white_symbol,
           m20.m20_market_segment,
           CASE m20.m20_market_segment
               WHEN 1 THEN 'Main Market'
               WHEN 2 THEN 'Second Market'
               WHEN 3 THEN 'Main Market & Second Market'
           END
               AS market_segment,
           m20.m20_lot_size,
           m20.m20_lasttradeprice,
           m20.m20_isincode,
           m20_institute_id_m02,
           m20_market_id_m29,
           m20.m20_vwap,
           m20.m20_date_of_last_price
      FROM m20_symbol m20
           LEFT JOIN vw_access_level
               ON vw_access_level.v01_id = m20.m20_access_level_id_v01
           LEFT JOIN v22_symbol_status v22
               ON v22.v22_id = m20.m20_trading_status_id_v22
           LEFT JOIN u17_employee u17
               ON u17.u17_id = m20.m20_status_changed_by_id_u17
           LEFT JOIN vw_status_list
               ON m20.m20_status_id_v01 = vw_status_list.v01_id
/