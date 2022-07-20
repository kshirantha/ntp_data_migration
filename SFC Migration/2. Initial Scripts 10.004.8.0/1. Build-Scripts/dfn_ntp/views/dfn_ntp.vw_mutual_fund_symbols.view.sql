CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_mutual_fund_symbols
(
    m20_id,
    m20_exchange_id_m01,
    m20_symbol_code,
    m20_short_description,
    m20_short_description_lang,
    m20_long_description,
    m20_long_description_lang,
    m20_instrument_type_id_v09,
    m20_instrument_type_code_v09,
    m20_currency_code_m03,
    m20_currency_id_m03,
    m20_trading_status_id_v22,
    trading_status,
    m20_status_id_v01,
    status,
    m20_access_level_id_v01,
    m20_cusip_no,
    m20_reuters_code,
    m20_market_id_m29,
    m20_market_code_m29,
    m20_sectors_id_m63,
    m20_minimum_unit_size,
    m20_country_m05_id,
    m63_description,
    access_level,
    m20_exchange_code_m01,
    m20_small_orders,
    small_orders,
    m20_small_order_value,
    m20_status_changed_by_id_u17,
    status_changed_by,
    m20_lot_size,
    m20_isincode,
    m20_sharia_complient,
    sharia_complient,
    m20_bloomberg_code,
    m20_institute_id_m02,
    m20_benchmark,
    m20_buy_tplus,
    m20_sell_tplus,
    m20_fund_type_v01,
    fund_type,
    m20_cutofftime,
    m20_amc,
    amc
)
AS
    SELECT m20.m20_id,
           m20.m20_exchange_id_m01,
           m20.m20_symbol_code,
           m20.m20_short_description,
           m20.m20_short_description_lang,
           m20.m20_long_description,
           m20.m20_long_description_lang,
           m20.m20_instrument_type_id_v09,
           m20.m20_instrument_type_code_v09,
           m20.m20_currency_code_m03,
           m20.m20_currency_id_m03,
           m20.m20_trading_status_id_v22,
           v22.v22_description AS trading_status,
           m20.m20_status_id_v01,
           vw_status_list.v01_description AS status,
           m20.m20_access_level_id_v01,
           m20.m20_cusip_no,
           m20.m20_reuters_code,
           m20.m20_market_id_m29,
           m20.m20_market_code_m29,
           m20.m20_sectors_id_m63,
           m20.m20_minimum_unit_size,
           m20.m20_country_m05_id,
           m63.m63_description,
           vw_access_level.v01_description AS access_level,
           m20.m20_exchange_code_m01,
           m20.m20_small_orders,
           CASE m20.m20_small_orders WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS small_orders,
           m20.m20_small_order_value,
           m20.m20_status_changed_by_id_u17,
           u17.u17_full_name AS status_changed_by,
           m20.m20_lot_size,
           m20.m20_isincode,
           m20.m20_sharia_complient,
           CASE m20.m20_sharia_complient
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS sharia_complient,
           m20.m20_bloomberg_code,
           m20_institute_id_m02,
           m20.m20_benchmark,
           m20.m20_buy_tplus,
           m20.m20_sell_tplus,
           m20_extnd.m20_fund_type_v01,
           v01_fund_type.v01_description AS fund_type,
           m20_extnd.m20_cutofftime,
           m20_extnd.m20_amc,
           m178.m178_company_name AS amc
      FROM m20_symbol m20
           LEFT JOIN vw_access_level
               ON vw_access_level.v01_id = m20.m20_access_level_id_v01
           LEFT JOIN v22_symbol_status v22
               ON v22.v22_id = m20.m20_trading_status_id_v22
           LEFT JOIN u17_employee u17
               ON u17.u17_id = m20.m20_status_changed_by_id_u17
           LEFT JOIN vw_status_list
               ON m20.m20_status_id_v01 = vw_status_list.v01_id
           LEFT JOIN m20_symbol_extended m20_extnd
               ON m20.m20_id = m20_extnd.m20_id
           LEFT JOIN m63_sectors m63 ON m20.m20_sectors_id_m63 = m63.m63_id
           LEFT JOIN v01_system_master_data v01_fund_type
               ON     v01_fund_type.v01_type = 8
                  AND m20_extnd.m20_fund_type_v01 = v01_fund_type.v01_id
           LEFT JOIN m178_asset_management_company m178
               ON m20_extnd.m20_amc = m178.m178_id
     WHERE m20_instrument_type_code_v09 = 'MF'
/