DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_symbol_id              NUMBER;
    l_market_code            VARCHAR2 (10);
    l_market_id              NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT MAX (m29.m29_market_code), MAX (m29.m29_id)
      INTO l_market_code, l_market_id
      FROM dfn_ntp.m29_markets m29
     WHERE     m29.m29_primary_institution_id_m02 = l_primary_institute_id
           AND m29.m29_exchange_code_m01 = 'TDWL'
           AND m29.m29_is_default = 1;

    SELECT NVL (MAX (m20_id), 0) INTO l_symbol_id FROM dfn_ntp.m20_symbol;

    DELETE FROM error_log
          WHERE mig_table = 'M20_SYMBOL';

    FOR i
        IN (SELECT m77.m77_id,
                   m01.m01_id,
                   m77.m77_symbol,
                   m77.m77_symbol_code,
                   m77.m77_price_symbol,
                   NVL (map16_price.map16_ntp_code, m77.m77_price_exchange)
                       AS price_exchange,
                   CASE
                       WHEN NVL (map16.map16_ntp_code, m77.m77_exchange) =
                                'TDWL'
                       THEN
                           l_market_code
                       WHEN m77.m77_market_code IS NULL
                       THEN
                           'ALL'
                       ELSE
                           m77.m77_market_code
                   END
                       AS market_code,
                   m77.m77_currency,
                   m77.m77_status,
                   map01.map01_ntp_id,
                   m77.m77_access_level,
                   CASE
                       WHEN m77.m77_allowed_direction = 1 THEN 2
                       WHEN m77.m77_allowed_direction = 2 THEN 1
                       ELSE 0
                   END
                       AS allowed_direction,
                   NVL (m77.m77_lot_size, m39.m39_lot_size) AS lot_size, -- Considering Symbol's Value Over Price Qty Factor's Value [Discussed with Sandamal]
                   m77.m77_symbol_loss_category,
                   NVL (m77.m77_price_ratio, m39.m39_price_ratio)
                       AS price_ratio, -- Considering Symbol's Value Over Price Qty Factor's Value [Discussed with Sandamal]
                   m77.m77_sharia_complient,
                   m77.m77_reuters_code,
                   m77.m77_isincode,
                   m77.m77_cusip_no,
                   m05.m05_id,
                   m77.m77_small_orders,
                   m77.m77_small_order_value,
                   m77.m77_minimum_unit_size,
                   m77.m77_bloomberg_code,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m77.m77_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m77.m77_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS last_updated_by_new_id,
                   m77.m77_last_updated_date AS last_updated_date,
                   CASE
                       WHEN m77.m77_market_segment = 0 THEN 1
                       WHEN m77.m77_market_segment = 1 THEN 2
                       ELSE 0
                   END
                       AS market_segment,
                   NVL (map16.map16_ntp_code, m77.m77_exchange)
                       AS exchange_code,
                   m77.m77_base_symbol,
                   m77.m77_trade_enabled,
                   m77.m77_online_allowed,
                   m03.m03_id,
                   NVL (map16_under_line.map16_ntp_code, m77.m77_exchange)
                       AS underline_exchange,
                   m77_base.m77_id AS base_symbol_id,
                   m01_base.m01_id AS base_exg_id,
                   CASE
                       WHEN v34_inst_code_v09 IN ('OPT', 'RHT') -- Only for RGT & OPT Expire Date Is Generated
                       THEN
                           TO_DATE (
                               m77.m77_maturity_myear || m77.m77_maturity_day,
                               'yyyymmdd')
                       ELSE
                           m77.m77_expire_date
                   END
                       AS m77_expire_date,
                   m77.m77_strike_price,
                   m77.m77_option_type,
                   m63.m63_id,
                   m77.m77_minimum_disclosed_qty,
                   v09.v09_id,
                   v09.v09_code,
                   v34.v34_inst_id_v09,
                   v34.v34_id,
                   v34.v34_inst_code_v09,
                   m39_map.new_price_qty_factors_id,
                   CASE
                       WHEN NVL (map16.map16_ntp_code, m77.m77_exchange) =
                                'TDWL'
                       THEN
                           l_market_id
                       ELSE
                           m29.m29_id
                   END
                       AS market_id,
                   m77.m77_benchmark,
                   m77.m77_buy_tplus,
                   m77.m77_sell_tplus,
                   m107_en.m107_short_description AS short_description_en,
                   m107_en.m107_long_description AS long_description_en,
                   m107_ar.m107_short_description AS short_description_ar,
                   m107_ar.m107_long_description AS long_description_ar,
                   m77.m77_initial_margin_perc,
                   CASE
                       WHEN esp_snap.exchangecode = 'KSE'
                       THEN
                           ROUND (esp_snap.minprice / 1000, 5)
                       ELSE
                           esp_snap.minprice
                   END
                       AS minprice, -- Using the Logic in Old View
                   CASE
                       WHEN esp_snap.exchangecode = 'KSE'
                       THEN
                           ROUND (esp_snap.maxprice / 1000, 5)
                       ELSE
                           esp_snap.maxprice
                   END
                       AS maxprice, -- Using the Logic in Old View
                   CASE
                       WHEN m77.m77_manual_price_suspended <> 1
                       THEN
                           (CASE
                                WHEN esp_snap.exchangecode = 'KSE'
                                THEN
                                    ROUND (esp_snap.lasttradeprice / 1000, 5)
                                ELSE
                                    esp_snap.lasttradeprice
                            END)
                       ELSE
                           0
                   END
                       AS lasttradeprice, -- Using the Logic in Old View
                   CASE
                       WHEN m77.m77_manual_price_suspended <> 1
                       THEN
                           (CASE
                                WHEN esp_snap.exchangecode = 'KSE'
                                THEN
                                    ROUND (esp_snap.previousclosed / 1000, 5)
                                ELSE
                                    esp_snap.previousclosed
                            END)
                       ELSE
                           0
                   END
                       AS previousclosed, -- Using the Logic in Old View
                   CASE
                       WHEN m77.m77_manual_price_suspended <> 1
                       THEN
                           (CASE
                                WHEN esp_snap.exchangecode = 'KSE'
                                THEN
                                    ROUND (esp_snap.todaysclosed / 1000, 5)
                                ELSE
                                    esp_snap.todaysclosed
                            END)
                       ELSE
                           0
                   END
                       AS todaysclosed, -- Using the Logic in Old View
                   CASE
                       WHEN esp_snap.exchangecode = 'KSE'
                       THEN
                           ROUND (esp_snap.bestbidprice / 1000, 5)
                       ELSE
                           esp_snap.bestbidprice
                   END
                       AS bestbidprice, -- Using the Logic in Old View
                   CASE
                       WHEN esp_snap.exchangecode = 'KSE'
                       THEN
                           ROUND (esp_snap.bestaskprice / 1000, 5)
                       ELSE
                           esp_snap.bestaskprice
                   END
                       AS bestaskprice, -- Using the Logic in Old View
                   NVL (esp_snap.static_min, 0) AS static_min,
                   NVL (esp_snap.static_max, 0) AS static_max,
                   m77.m77_sellshort_allowed,
                   NVL (m77.m77_bond_trade_type, 1) AS m77_bond_trade_type, -- [Same IDs] | Default (1 : Exchange)
                   m20_map.new_symbol_id
              FROM mubasher_oms.m77_symbols@mubasher_db_link m77
                   LEFT JOIN map16_optional_exchanges_m01 map16
                       ON m77.m77_exchange = map16.map16_oms_code
                   LEFT JOIN map16_optional_exchanges_m01 map16_price
                       ON m77.m77_price_exchange = map16_price.map16_oms_code
                   LEFT JOIN map16_optional_exchanges_m01 map16_under_line
                       ON m77.m77_exchange = map16_under_line.map16_oms_code
                   JOIN map01_approval_status_v01 map01
                       ON m77.m77_status_id = map01.map01_oms_id
                   LEFT JOIN (SELECT m01_id,
                                     m01_exchange_code,
                                     m01_institute_id_m02
                                FROM dfn_ntp.m01_exchanges
                               WHERE m01_institute_id_m02 =
                                         l_primary_institute_id) m01
                       ON NVL (map16.map16_ntp_code, m77.m77_exchange) =
                              m01.m01_exchange_code
                   LEFT JOIN (SELECT m01_id,
                                     m01_exchange_code,
                                     m01_institute_id_m02
                                FROM dfn_ntp.m01_exchanges
                               WHERE m01_institute_id_m02 =
                                         l_primary_institute_id) m01_base
                       ON NVL (map16_under_line.map16_ntp_code,
                               m77.m77_underline_exchange) =
                              m01_base.m01_exchange_code
                   LEFT JOIN mubasher_oms.m77_symbols@mubasher_db_link m77_base
                       ON     m77.m77_base_symbol = m77_base.m77_symbol
                          AND NVL (map16_under_line.map16_oms_code,
                                   m77.m77_underline_exchange) =
                                  m77_base.m77_exchange
                   LEFT JOIN dfn_ntp.m03_currency m03
                       ON m77.m77_currency = m03.m03_code
                   LEFT JOIN map06_country_m05 map06
                       ON m77.m77_nationality_id = map06.map06_oms_id
                   LEFT JOIN dfn_ntp.m05_country m05
                       ON map06.map06_ntp_id = m05.m05_id
                   LEFT JOIN (SELECT m63_id,
                                     m63_sector_code,
                                     m63_exchange_code_m01
                                FROM dfn_ntp.m63_sectors
                               WHERE m63_institute_id_m02 =
                                         l_primary_institute_id) m63
                       ON     m77.m77_sector = m63.m63_sector_code
                          AND NVL (map16.map16_ntp_code, m77.m77_exchange) =
                                  m63.m63_exchange_code_m01
                   LEFT JOIN dfn_ntp.v34_price_instrument_type v34
                       ON     m77.m77_instrument_type_id =
                                  v34.v34_price_inst_type_id
                          AND m77.m77_instrument_type = v34.v34_inst_code_v09
                   LEFT JOIN dfn_ntp.v09_instrument_types v09
                       ON v34.v34_inst_id_v09 = v09.v09_id
                   LEFT JOIN (SELECT m29_id,
                                     m29_market_code,
                                     m29_exchange_code_m01
                                FROM dfn_ntp.m29_markets
                               WHERE     m29_primary_institution_id_m02 =
                                             l_primary_institute_id
                                     AND m29_is_default = 1) m29
                       ON     m77.m77_market_code = m29.m29_market_code
                          AND NVL (map16.map16_ntp_code, m77.m77_exchange) =
                                  m29.m29_exchange_code_m01
                   LEFT JOIN u17_employee_mappings u17_created
                       ON m77.m77_created_by = u17_created.old_employee_id
                   LEFT JOIN u17_employee_mappings u17_modified
                       ON m77.m77_last_updated_by =
                              u17_modified.old_employee_id
                   LEFT JOIN u17_employee_mappings u17_status_changed
                       ON m77.m77_status_changed_by =
                              u17_status_changed.old_employee_id
                   LEFT JOIN m39_price_qty_factors_mappings m39_map
                       ON m77.m77_price_type =
                              m39_map.old_price_qty_factors_id
                   LEFT JOIN dfn_ntp.m39_price_qty_factors m39
                       ON m39_map.new_price_qty_factors_id = m39.m39_id
                   LEFT JOIN (  SELECT m107_symbol_id,
                                       MAX (m107_short_description)
                                           AS m107_short_description,
                                       MAX (m107_long_description)
                                           AS m107_long_description
                                  FROM mubasher_oms.m107_symbol_descriptions@mubasher_db_link m107
                                 WHERE m107.m107_language = 'EN'
                              GROUP BY m107_symbol_id) m107_en
                       ON m77.m77_id = m107_en.m107_symbol_id
                   LEFT JOIN (  SELECT m107_symbol_id,
                                       MAX (m107_short_description)
                                           AS m107_short_description,
                                       MAX (m107_long_description)
                                           AS m107_long_description
                                  FROM mubasher_oms.m107_symbol_descriptions@mubasher_db_link m107
                                 WHERE m107.m107_language = 'AR'
                              GROUP BY m107_symbol_id) m107_ar
                       ON m77.m77_id = m107_ar.m107_symbol_id
                   LEFT JOIN mubasher_price.esp_symbolmap@mubasher_price_link sym_map
                       ON     m77.m77_exchange = sym_map.exchange
                          AND m77.m77_symbol = sym_map.symbol
                   LEFT JOIN mubasher_price.esp_todays_snapshots@mubasher_price_link esp_snap
                       ON     sym_map.exchange = esp_snap.exchangecode
                          AND sym_map.symbol = esp_snap.symbol
                   LEFT JOIN m20_symbol_mappings m20_map
                       ON m77.m77_id = m20_map.old_symbol_id)
    LOOP
        BEGIN
            /* [Corrective Actions Discussed]

            IF i.v34_inst_code_v09 IS NULL
             THEN
                 raise_application_error (-20001,
                                          'Invalid Instrument Types',
                                          TRUE);
             END IF;*/

            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_symbol_id IS NULL
            THEN
                l_symbol_id := l_symbol_id + 1;

                INSERT
                  INTO dfn_ntp.m20_symbol (m20_id,
                                           m20_exchange_id_m01,
                                           m20_symbol_code,
                                           m20_price_symbol_code_m20,
                                           m20_price_exchange_code_m01,
                                           m20_market_code_m29,
                                           m20_currency_code_m03,
                                           m20_trading_status_id_v22,
                                           m20_status_id_v01,
                                           m20_access_level_id_v01,
                                           m20_restricted_direction,
                                           m20_minprice,
                                           m20_maxprice,
                                           m20_lasttradeprice,
                                           m20_lot_size,
                                           m20_settle_category_v11,
                                           m20_price_ratio,
                                           m20_sharia_complient,
                                           m20_reuters_code,
                                           m20_isincode,
                                           m20_cusip_no,
                                           m20_country_m05_id,
                                           m20_small_orders,
                                           m20_small_order_value,
                                           m20_minimum_unit_size,
                                           m20_bloomberg_code,
                                           m20_status_changed_by_id_u17,
                                           m20_status_changed_date,
                                           m20_created_by_id_u17,
                                           m20_created_date,
                                           m20_last_updated_by_id_u17,
                                           m20_last_updated_date,
                                           m20_external_ref,
                                           m20_short_description,
                                           m20_short_description_lang,
                                           m20_long_description,
                                           m20_long_description_lang,
                                           m20_is_white_symbol,
                                           m20_market_segment,
                                           m20_exchange_code_m01,
                                           m20_base_symbol_m20,
                                           m20_trading_allowed,
                                           m20_online_trading_allowed,
                                           m20_modified_by_id_u17,
                                           m20_modified_date,
                                           m20_currency_id_m03,
                                           m20_base_exchange_code_m01,
                                           m20_base_symbol_id_m20,
                                           m20_base_exchange_id_m01,
                                           m20_date_of_last_price,
                                           m20_previous_closed,
                                           m20_today_closed,
                                           m20_exchange_symbol_code_m20,
                                           m20_vwap,
                                           m20_expire_date,
                                           m20_strike_price,
                                           m20_option_type,
                                           m20_sectors_id_m63,
                                           m20_minimum_discloused_qty,
                                           m20_instrument_type_id_v09,
                                           m20_instrument_type_code_v09,
                                           m20_price_instrument_type_v09,
                                           m20_price_instrument_id_v34,
                                           m20_price_instrument_code_v34,
                                           m20_bestbidprice,
                                           m20_bestaskprice,
                                           m20_price_type,
                                           m20_custom_type,
                                           m20_static_min,
                                           m20_static_max,
                                           m20_institute_id_m02,
                                           m20_market_id_m29,
                                           m20_benchmark,
                                           m20_buy_tplus,
                                           m20_sell_tplus,
                                           m20_initial_margin_value,
                                           m20_fixing_price,
                                           m20_quantity_decimal_factor,
                                           m20_client_fee_per_buy_b,
                                           m20_staff_fee_per_buy_b,
                                           m20_ytd_nav_b,
                                           m20_date_of_ytd_nav_b,
                                           m20_risk_profile_b,
                                           m20_share_class_b,
                                           m20_share_class_desc_b,
                                           m20_share_cls_desc_lang_b,
                                           m20_fund_family_b,
                                           m20_asset_type_b,
                                           m20_asset_type_desc_b,
                                           m20_asset_type_desc_lang_b,
                                           m20_market_b,
                                           m20_market_desc_b,
                                           m20_market_desc_lang_b,
                                           m20_region_b,
                                           m20_region_desc_b,
                                           m20_region_desc_lang_b,
                                           m20_fund_inv_profile_b,
                                           m20_fund_size_b,
                                           m20_nav_inception_b,
                                           m20_comparative_index_b,
                                           m20_date_of_incepttion_b,
                                           m20_sub_fee_b,
                                           m20_management_fee_b,
                                           m20_minimum_sub_b,
                                           m20_dealing_days_b,
                                           m20_announce_days_b,
                                           m20_sub_redem_cut_off_b,
                                           m20_redem_payment_b,
                                           m20_short_selling,
                                           m20_trade_type_v01,
                                           m20_fund_type_b,
                                           m20_fund_family_desc_b,
                                           m20_fund_family_desc_lang_b)
                VALUES (l_symbol_id, -- m20_id
                        i.m01_id, -- m20_exchange_id_m01
                        i.m77_symbol, -- m20_symbol_code
                        i.m77_price_symbol, -- m20_price_symbol_code_m20
                        i.price_exchange, -- m20_price_exchange_code_m01
                        i.market_code, -- m20_market_code_m29
                        i.m77_currency, -- m20_currency_code_m03
                        i.m77_status, -- m20_trading_status_id_v22
                        i.map01_ntp_id, -- m20_status_id_v01
                        i.m77_access_level, -- m20_access_level_id_v01
                        i.allowed_direction, -- m20_restricted_direction
                        i.minprice, --m20_minprice [Again Will be Updated from RDBM]
                        i.maxprice, --m20_maxprice [Again Will be Updated from RDBM]
                        i.lasttradeprice, --m20_lasttradeprice [Again Will be Updated from RDBM]
                        i.lot_size, -- m20_lot_size
                        i.m77_symbol_loss_category, -- m20_settle_category_v11
                        i.price_ratio, -- m20_price_ratio
                        i.m77_sharia_complient, -- m20_sharia_complient
                        i.m77_reuters_code, -- m20_reuters_code
                        i.m77_isincode, -- m20_isincode
                        i.m77_cusip_no, -- m20_cusip_no
                        i.m05_id, -- m20_country_m05_id
                        i.m77_small_orders, -- m20_small_orders
                        i.m77_small_order_value, -- m20_small_order_value
                        i.m77_minimum_unit_size, -- m20_minimum_unit_size
                        i.m77_bloomberg_code, -- m20_bloomberg_code
                        i.status_changed_by_new_id, -- m20_status_changed_by_id_u17
                        i.status_changed_date, -- m20_status_changed_date
                        i.created_by_new_id, -- m20_created_by_id_u17
                        i.created_date, -- m20_created_date
                        NVL (i.last_updated_by_new_id, 0), -- m20_last_updated_by_id_u17
                        NVL (i.last_updated_date, SYSDATE), -- m20_last_updated_date
                        i.m77_id, -- m20_external_ref
                        i.short_description_en, -- m20_short_description
                        i.short_description_ar, -- m20_short_description_lang
                        i.long_description_en, -- m20_long_description
                        i.long_description_ar, -- m20_long_description_lang
                        0, -- m20_is_white_symbol
                        i.market_segment, -- m20_market_segment
                        i.exchange_code, -- m20_exchange_code_m01
                        i.m77_base_symbol, -- m20_base_symbol_m20
                        i.m77_trade_enabled, -- m20_trading_allowed
                        i.m77_online_allowed, -- m20_online_trading_allowed
                        i.last_updated_by_new_id, -- m20_modified_by_id_u17
                        i.last_updated_date, -- m20_modified_date
                        i.m03_id, -- m20_currency_id_m03
                        i.underline_exchange, -- m20_base_exchange_code_m01
                        i.base_symbol_id, -- m20_base_symbol_id_m20
                        i.base_exg_id, -- m20_base_exchange_id_m01
                        NVL (i.last_updated_date, SYSDATE), -- m20_date_of_last_price
                        i.previousclosed, -- m20_previous_closed [Again Will be Updated from RDBM]
                        i.todaysclosed, -- m20_today_closed [Again Will be Updated from RDBM]
                        i.m77_symbol_code, -- m20_exchange_symbol_code_m20
                        0, -- m20_vwap [Again Will be Updated from RDBM]
                        i.m77_expire_date, -- m20_expire_date
                        i.m77_strike_price, -- m20_strike_price
                        i.m77_option_type, -- m20_option_type
                        i.m63_id, -- m20_sectors_id_m63
                        i.m77_minimum_disclosed_qty, -- m20_minimum_discloused_qty
                        i.v09_id, -- m20_instrument_type_id_v09
                        i.v09_code, -- m20_instrument_type_code_v09
                        i.v34_inst_id_v09, -- m20_price_instrument_type_v09
                        i.v34_id, -- m20_price_instrument_id_v34
                        i.v34_inst_code_v09, -- m20_price_instrument_code_v34
                        i.bestbidprice, -- m20_bestbidprice [Again Will be Updated from RDBM]
                        i.bestaskprice, -- m20_bestaskprice [Again Will be Updated from RDBM]
                        i.new_price_qty_factors_id, -- m20_price_type
                        '1', -- m20_custom_type
                        i.static_min, -- m20_static_min [Again Will be Updated from RDBM]
                        i.static_max, -- m20_static_max [Again Will be Updated from RDBM]
                        l_primary_institute_id, -- m20_institute_id_m02
                        i.market_id, -- m20_market_id_m29
                        i.m77_benchmark, -- m20_benchmark
                        i.m77_buy_tplus, -- m20_buy_tplus
                        i.m77_sell_tplus, -- m20_sell_tplus
                        i.m77_initial_margin_perc, -- m20_initial_margin_value
                        0, -- m20_fixing_price | Not Available
                        0, -- m20_quantity_decimal_factor | Not Available
                        NULL, -- m20_client_fee_per_buy_b | Not Available
                        NULL, -- m20_staff_fee_per_buy_b | Not Available
                        0, -- m20_ytd_nav_b | Not Available
                        NULL, -- m20_date_of_ytd_nav_b | Not Available
                        NULL, -- m20_risk_profile_b | Not Available
                        NULL, -- m20_share_class_b | Not Available
                        NULL, -- m20_share_class_desc_b | Not Available
                        NULL, -- m20_share_cls_desc_lang_b | Not Available
                        NULL, -- m20_fund_family_b | Not Available
                        NULL, -- m20_asset_type_b | Not Available
                        NULL, -- m20_asset_type_desc_b | Not Available
                        NULL, -- m20_asset_type_desc_lang_b | Not Available
                        NULL, -- m20_market_b | Not Available
                        NULL, -- m20_market_desc_b | Not Available
                        NULL, -- m20_market_desc_lang_b | Not Available
                        NULL, -- m20_region_b | Not Available
                        NULL, -- m20_region_desc_b | Not Available
                        NULL, -- m20_region_desc_lang_b | Not Available
                        NULL, -- m20_fund_inv_profile_b | Not Available
                        NULL, -- m20_fund_size_b | Not Available
                        NULL, -- m20_nav_inception_b | Not Available
                        NULL, -- m20_comparative_index_b | Not Available
                        NULL, -- m20_date_of_incepttion_b | Not Available
                        NULL, -- m20_sub_fee_b | Not Available
                        NULL, -- m20_management_fee_b | Not Available
                        NULL, -- m20_minimum_sub_b | Not Available
                        NULL, -- m20_dealing_days_b | Not Available
                        NULL, -- m20_announce_days_b | Not Available
                        NULL, -- m20_sub_redem_cut_off_b | Not Available
                        NULL, -- m20_redem_payment_b | Not Available
                        i.m77_sellshort_allowed, -- m20_short_selling
                        i.m77_bond_trade_type, -- m20_trade_type_v01
                        NULL, -- m20_fund_type_b | Not Available
                        NULL, -- m20_fund_family_desc_b | Not Available
                        NULL -- m20_fund_family_desc_lang_b | Not Available
                            );

                INSERT INTO m20_symbol_mappings
                     VALUES (i.m77_id, l_symbol_id);
            ELSE
                UPDATE dfn_ntp.m20_symbol
                   SET m20_exchange_id_m01 = i.m01_id, -- m20_exchange_id_m01
                       m20_symbol_code = i.m77_symbol, -- m20_symbol_code
                       m20_price_symbol_code_m20 = i.m77_price_symbol, -- m20_price_symbol_code_m20
                       m20_price_exchange_code_m01 = i.price_exchange, -- m20_price_exchange_code_m01
                       m20_market_code_m29 = i.market_code, -- m20_market_code_m29
                       m20_currency_code_m03 = i.m77_currency, -- m20_currency_code_m03
                       m20_trading_status_id_v22 = i.m77_status, -- m20_trading_status_id_v22
                       m20_status_id_v01 = i.map01_ntp_id, -- m20_status_id_v01
                       m20_access_level_id_v01 = i.m77_access_level, -- m20_access_level_id_v01
                       m20_restricted_direction = i.allowed_direction, -- m20_restricted_direction
                       m20_lot_size = i.lot_size, -- m20_lot_size
                       m20_settle_category_v11 = i.m77_symbol_loss_category, -- m20_settle_category_v11
                       m20_price_ratio = i.price_ratio, -- m20_price_ratio
                       m20_sharia_complient = i.m77_sharia_complient, -- m20_sharia_complient
                       m20_reuters_code = i.m77_reuters_code, -- m20_reuters_code
                       m20_isincode = i.m77_isincode, -- m20_isincode
                       m20_cusip_no = i.m77_cusip_no, -- m20_cusip_no
                       m20_country_m05_id = i.m05_id, -- m20_country_m05_id
                       m20_small_orders = i.m77_small_orders, -- m20_small_orders
                       m20_small_order_value = i.m77_small_order_value, -- m20_small_order_value
                       m20_minimum_unit_size = i.m77_minimum_unit_size, -- m20_minimum_unit_size
                       m20_bloomberg_code = i.m77_bloomberg_code, -- m20_bloomberg_code
                       m20_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m20_status_changed_by_id_u17
                       m20_status_changed_date = i.status_changed_date, -- m20_status_changed_date
                       m20_last_updated_by_id_u17 =
                           NVL (i.last_updated_by_new_id, 0), -- m20_last_updated_by_id_u17
                       m20_last_updated_date =
                           NVL (i.last_updated_date, SYSDATE), -- m20_last_updated_date
                       m20_external_ref = i.m77_id, -- m20_external_ref
                       m20_short_description = i.short_description_en, -- m20_short_description
                       m20_short_description_lang = i.short_description_ar, -- m20_short_description_lang
                       m20_long_description = i.long_description_en, -- m20_long_description
                       m20_long_description_lang = i.long_description_ar, -- m20_long_description_lang
                       m20_market_segment = i.market_segment, -- m20_market_segment
                       m20_exchange_code_m01 = i.exchange_code, -- m20_exchange_code_m01
                       m20_base_symbol_m20 = i.m77_base_symbol, -- m20_base_symbol_m20
                       m20_trading_allowed = i.m77_trade_enabled, -- m20_trading_allowed
                       m20_online_trading_allowed = i.m77_online_allowed, -- m20_online_trading_allowed
                       m20_modified_by_id_u17 =
                           NVL (i.last_updated_by_new_id, 0), -- m20_modified_by_id_u17
                       m20_modified_date = NVL (i.last_updated_date, SYSDATE), -- m20_modified_date
                       m20_currency_id_m03 = i.m03_id, -- m20_currency_id_m03
                       m20_base_exchange_code_m01 = i.underline_exchange, -- m20_base_exchange_code_m01
                       m20_base_symbol_id_m20 = i.base_symbol_id, -- m20_base_symbol_id_m20
                       m20_base_exchange_id_m01 = i.base_exg_id, -- m20_base_exchange_id_m01
                       m20_date_of_last_price =
                           NVL (i.last_updated_date, SYSDATE), -- m20_date_of_last_price
                       m20_exchange_symbol_code_m20 = i.m77_symbol_code, -- m20_exchange_symbol_code_m20
                       m20_expire_date = i.m77_expire_date, -- m20_expire_date
                       m20_strike_price = i.m77_strike_price, -- m20_strike_price
                       m20_option_type = i.m77_option_type, -- m20_option_type
                       m20_sectors_id_m63 = i.m63_id, -- m20_sectors_id_m63
                       m20_minimum_discloused_qty =
                           i.m77_minimum_disclosed_qty, -- m20_minimum_discloused_qty
                       m20_instrument_type_id_v09 = i.v09_id, -- m20_instrument_type_id_v09
                       m20_instrument_type_code_v09 = i.v09_code, -- m20_instrument_type_code_v09
                       m20_price_instrument_type_v09 = i.v34_inst_id_v09, -- m20_price_instrument_type_v09
                       m20_price_instrument_id_v34 = i.v34_id, -- m20_price_instrument_id_v34
                       m20_price_instrument_code_v34 = i.v34_inst_code_v09, -- m20_price_instrument_code_v34
                       m20_price_type = i.new_price_qty_factors_id, -- m20_price_type
                       m20_market_id_m29 = i.market_id, -- m20_market_id_m29
                       m20_benchmark = i.m77_benchmark, -- m20_benchmark
                       m20_buy_tplus = i.m77_buy_tplus, -- m20_buy_tplus
                       m20_sell_tplus = i.m77_sell_tplus, -- m20_sell_tplus
                       m20_initial_margin_value = i.m77_initial_margin_perc, -- m20_initial_margin_value
                       m20_minprice = i.minprice, --m20_minprice [Again Will be Updated from RDBM]
                       m20_maxprice = i.maxprice, --m20_maxprice [Again Will be Updated from RDBM]
                       m20_lasttradeprice = i.lasttradeprice, --m20_lasttradeprice [Again Will be Updated from RDBM]
                       m20_previous_closed = i.previousclosed, -- m20_previous_closed [Again Will be Updated from RDBM]
                       m20_today_closed = i.todaysclosed, -- m20_today_closed [Again Will be Updated from RDBM]
                       m20_bestbidprice = i.bestbidprice, -- m20_bestbidprice [Again Will be Updated from RDBM]
                       m20_bestaskprice = i.bestaskprice, -- m20_bestaskprice [Again Will be Updated from RDBM]
                       m20_static_min = i.static_min, -- m20_static_min [Again Will be Updated from RDBM]
                       m20_static_max = i.static_max, -- m20_static_max [Again Will be Updated from RDBM]
                       m20_short_selling = i.m77_sellshort_allowed, -- m20_short_selling
                       m20_trade_type_v01 = i.m77_bond_trade_type -- m20_trade_type_v01
                 WHERE m20_id = i.new_symbol_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M20_SYMBOL',
                                i.m77_id,
                                CASE
                                    WHEN i.new_symbol_id IS NULL
                                    THEN
                                        l_symbol_id
                                    ELSE
                                        i.new_symbol_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_symbol_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('M20_SYMBOL');
END;
/

-- Update Market ID for Unmapped Market Codes [Default Market Code 'ALL']

MERGE INTO dfn_ntp.m20_symbol m20
     USING (SELECT m20.m20_id, m29.m29_id, m29.m29_market_code
              FROM dfn_ntp.m20_symbol m20, dfn_ntp.m29_markets m29
             WHERE     m20.m20_market_id_m29 IS NULL
                   AND m20.m20_exchange_id_m01 = m29.m29_exchange_id_m01
                   AND m29.m29_market_code = 'ALL') m29_umapped_markets
        ON (m20.m20_id = m29_umapped_markets.m20_id)
WHEN MATCHED
THEN
    UPDATE SET
        m20.m20_market_code_m29 = m29_umapped_markets.m29_market_code,
        m20_market_id_m29 = m29_umapped_markets.m29_id;

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('M20_SYMBOL');
END;
/
