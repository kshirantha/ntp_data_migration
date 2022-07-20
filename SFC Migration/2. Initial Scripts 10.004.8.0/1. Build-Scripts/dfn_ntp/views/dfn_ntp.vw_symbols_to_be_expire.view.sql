CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_symbols_to_be_expire
(
    m20_id,
    m20_maturity_date,
    status,
    trading_status,
    access_level,
    m20_price_ratio,
    m20_market_code_m29,
    small_orders,
    m20_small_order_value,
    status_changed_by,
    is_white_symbol,
    market_segment,
    m20_expire_date,
    m20_symbol_code,
    m20_short_description,
    m20_instrument_type_code_v09,
    m20_currency_code_m03,
    m20_exchange_code_m01,
    m20_sectors_id_m63,
    option_type,
    m20_strike_price,
    m20_institute_id_m02,
    u24_trading_acnt_id_u07,
    m20_status_id_v01
)
AS
    SELECT m20.m20_id,
           m20.m20_maturity_date,
           status.v01_description AS status,
           v22.v22_description AS trading_status,
           access_level.v01_description AS access_level,
           m20.m20_price_ratio,
           m20.m20_market_code_m29,
           m20.m20_small_orders AS small_orders,
           m20.m20_small_order_value,
           status_changed_by.u17_full_name AS status_changed_by,
           m20.m20_is_white_symbol AS is_white_symbol,
           m20.m20_market_segment AS market_segment,
           m20.m20_expire_date,
           m20.m20_symbol_code,
           m20.m20_short_description,
           m20.m20_instrument_type_code_v09,
           m20.m20_currency_code_m03,
           m20.m20_exchange_code_m01,
           m20.m20_sectors_id_m63,
           m20.m20_option_type AS option_type,
           m20.m20_strike_price,
           m20.m20_institute_id_m02,
           u24.u24_trading_acnt_id_u07,
           m20.m20_status_id_v01
      FROM vw_m20_symbol_all m20
           JOIN u24_holdings u24
               ON m20.m20_id = u24.u24_symbol_id_m20
           LEFT JOIN u17_employee status_changed_by
               ON m20.m20_status_changed_by_id_u17 = status_changed_by.u17_id
           JOIN vw_status_list status
               ON m20.m20_status_id_v01 = status.v01_id
           LEFT JOIN vw_access_level access_level
               ON m20.m20_access_level_id_v01 = access_level.v01_id
           LEFT JOIN vw_access_level access_level
               ON m20.m20_access_level_id_v01 = access_level.v01_id
           LEFT JOIN v22_symbol_status v22
               ON m20.m20_trading_status_id_v22 = v22.v22_id
     WHERE m20.m20_instrument_type_code_v09 IN ('OPT', 'RHT', 'WR')
/