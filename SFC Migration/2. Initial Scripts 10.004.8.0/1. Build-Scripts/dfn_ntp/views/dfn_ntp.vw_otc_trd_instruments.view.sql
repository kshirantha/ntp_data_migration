CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_otc_trd_instruments
(
    m168_id,
    m168_short_name,
    m168_issuer_name,
    m168_instrument_type_id_v01,
    otc_instrument_type,
    otc_instrument_type_lang,
    m168_code,
    m168_description,
    m168_sub_asset_type_id_v08,
    sub_asset_type,
    sub_asset_type_lang,
    m168_security_domicile_id_m05,
    security_domicile,
    security_domicile_lang,
    m168_security_currency_id_m03,
    security_currency,
    security_currency_lang,
    m168_industry_id_v24,
    industry_code,
    m168_price_update_code_id_v23,
    price_update_code,
    m168_created_by_id_u17,
    created_by_full_name,
    m168_created_date,
    m168_status_id_v01,
    status_description,
    status_description_lang,
    m168_modified_by_id_u17,
    modified_by_full_name,
    m168_modified_date,
    m168_status_changed_by_id_u17,
    status_changed_by_full_name,
    m168_status_changed_date
)
AS
    SELECT m168_id,
           m168_short_name,
           m168_issuer_name,
           m168_instrument_type_id_v01,
           otc_instrument_types.v01_description AS otc_instrument_type,
           otc_instrument_types.v01_description_lang
               AS otc_instrument_type_lang,
           m168_code,
           m168_description,
           m168_sub_asset_type_id_v08,
           sub_asset_types.v08_description AS sub_asset_type,
           sub_asset_types.v08_description_lang AS sub_asset_type_lang,
           m168_security_domicile_id_m05,
           countries.m05_name AS security_domicile,
           countries.m05_name_lang AS security_domicile_lang,
           m168_security_currency_id_m03,
           currencies.m03_description AS security_currency,
           currencies.m03_description_lang AS security_currency_lang,
           m168_industry_id_v24,
           industry_codes.v24_description AS industry_code,
           m168_price_update_code_id_v23,
           price_update_codes.v23_description AS price_update_code,
           m168_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m168_created_date,
           m168_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m168_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m168_modified_date,
           m168_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m168_status_changed_date
      FROM m168_otc_trading_instruments m168
           JOIN v01_system_master_data otc_instrument_types
               ON     m168.m168_instrument_type_id_v01 =
                          otc_instrument_types.v01_id
                  AND otc_instrument_types.v01_type = 65
           JOIN v08_sub_asset_type sub_asset_types
               ON m168.m168_sub_asset_type_id_v08 = sub_asset_types.v08_id
           JOIN m05_country countries
               ON m168.m168_security_domicile_id_m05 = countries.m05_id
           JOIN v24_industry_codes industry_codes
               ON m168.m168_industry_id_v24 = industry_codes.v24_id
           JOIN m03_currency currencies
               ON m168.m168_security_currency_id_m03 = currencies.m03_id
           LEFT JOIN v23_price_update_codes price_update_codes
               ON m168.m168_price_update_code_id_v23 =
                      price_update_codes.v23_id
           JOIN u17_employee u17_created_by
               ON m168.m168_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m168.m168_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON m168.m168_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           JOIN vw_status_list status_list
               ON m168.m168_status_id_v01 = status_list.v01_id
/