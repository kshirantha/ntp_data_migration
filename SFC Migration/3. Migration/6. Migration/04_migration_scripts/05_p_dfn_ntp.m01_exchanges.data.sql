DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_exchange_id            NUMBER;
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

    SELECT NVL (MAX (m01_id), 0)
      INTO l_exchange_id
      FROM dfn_ntp.m01_exchanges;

    DELETE FROM error_log
          WHERE mig_table = 'M01_EXCHANGES';

    FOR i
        IN (SELECT NVL (map16.map16_ntp_code, m11.m11_exchangecode)
                       AS exchange_code,
                   m11.m11_description_1,
                   m11.m11_description_2,
                   NVL (m11.m11_status, 0) AS active_status,
                   m11.m11_type,
                   m07_map.new_location_id AS m07_map_new_id,
                   m11.m11_weekend_holidays,
                   m11.m11_buy_tplus,
                   m11.m11_sell_tplus,
                   m11.m11_active_status,
                   m11.m11_minimum_order_value,
                   m11.m11_lot_size,
                   m11.m11_use_submarket_for_trading,
                   m11.m11_minimum_unit_size,
                   m11.m11_price_multiplication_facto,
                   m11.m11_exchange_account_required,
                   m11.m11_exe_broker_ref_required,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m11.m11_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m11.m11_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m11.m11_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m11.m11_calculation_type,
                   m11.m11_calculation_unit,
                   m11.m11_dif_commission_for_buy_sel,
                   m11.m11_custodian_fee_allowable,
                   m11.m11_tif_meta_info,
                   m11.m11_send_commodity_attribs,
                   m11.m11_send_forx_discount_para,
                   m11.m11_valid_t59,
                   m11.m11_margin_liquidate,
                   m11.m11_day_trading_liquidate,
                   m11.m11_day_trading_allowed,
                   m11.m11_day_trading_end_time,
                   m11.m11_day_trading_liquidate_time,
                   m11.m11_last_day_trd_liquidation,
                   m11.m11_minimum_disclosed_qty,
                   m11.m11_enable_all_non,
                   m11.m11_price_display_format,
                   m11.m11_mre_ord_allowed,
                   m11.m11_pre_open,
                   m11.m11_open,
                   m11.m11_pre_close,
                   m11.m11_close,
                   m11.m11_enable_max_commission,
                   m11.m11_enable_min_commission,
                   m11.m11_gmt_offset,
                   m11.m11_tag_40,
                   m11.m11_tag_54,
                   m11.m11_order_rej_period,
                   m11.m11_default_currency,
                   m11.m11_eod_file_generate_time,
                   m11.m11_exchangecode_real,
                   m11.m11_tag_100_ric,
                   m11.m11_one_side_minmax_validation,
                   map06.map06_ntp_id,
                   m11.m11_offline_feed,
                   m11.m11_is_symboldriven_exg,
                   m11.m11_min_price_tolerance,
                   m11.m11_max_price_tolerance,
                   m11.m11_sent_account_closure_req,
                   m11.m11_enable_trade_rejection,
                   m11.m11_enable_short_selling_acc,
                   m11.m11_fail_mgm_acti_order_cancel,
                   m11.m11_charge_comm_for_custody,
                   m11.m11_settle_customer,
                   CASE
                       WHEN NVL (map16.map16_ntp_code, m11.m11_exchangecode) =
                                'TDWL'
                       THEN
                           1
                       ELSE
                           0
                   END
                       AS status_req_allowed,
                   CASE
                       WHEN NVL (map16.map16_ntp_code, m11.m11_exchangecode) =
                                'TDWL'
                       THEN
                           1
                       ELSE
                           0
                   END
                       AS symbol_status_req_allowed,
                   m11.m11_gtd_no_of_days,
                   CASE
                       WHEN NVL (map16.map16_ntp_code, m11.m11_exchangecode) <>
                                'TDWL'
                       THEN
                           1
                       ELSE
                           0
                   END
                       AS trade_processing,
                   m11.m11_cross_trading_enabled,
                   m03.m03_id,
                   m11.m11_debit_maintain_margin,
                   CASE
                       WHEN NVL (map16.map16_ntp_code, m11.m11_exchangecode) <>
                                'CASE'
                       THEN
                           1
                       ELSE
                           0
                   END
                       AS cross_cur_trd_enabled,
                   m01.m01_id
              FROM mubasher_oms.m11_exchanges@mubasher_db_link m11,
                   map01_approval_status_v01 map01,
                   map06_country_m05 map06,
                   dfn_ntp.m03_currency m03,
                   m07_location_mappings m07_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   dfn_ntp.m01_exchanges m01,
                   map16_optional_exchanges_m01 map16
             WHERE     m11.m11_status_id = map01.map01_oms_id
                   AND m11.m11_country = map06.map06_oms_id(+)
                   AND m03.m03_code = m11.m11_default_currency
                   AND m11.m11_location_id = m07_map.old_location_id(+)
                   AND m11.m11_created_by = u17_created.old_employee_id(+)
                   AND m11.m11_modified_by = u17_modified.old_employee_id(+)
                   AND m11.m11_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m11.m11_exchangecode = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m11.m11_exchangecode) =
                           m01.m01_exchange_code(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                l_exchange_id := l_exchange_id + 1;

                INSERT
                  INTO dfn_ntp.m01_exchanges (m01_id,
                                              m01_exchange_code,
                                              m01_description,
                                              m01_description_lang,
                                              m01_status,
                                              m01_type,
                                              m01_location_id_m07,
                                              m01_offline,
                                              m01_online_trader_id,
                                              m01_weekend_holidays,
                                              m01_buy_tplus,
                                              m01_sell_tplus,
                                              m01_active_status,
                                              m01_minimum_order_value,
                                              m01_custodian_require,
                                              m01_lot_size,
                                              m01_use_submarket_for_trading,
                                              m01_minimum_unit_size,
                                              m01_price_multiplication_facto,
                                              m01_exchange_account_required,
                                              m01_exe_broker_ref_required,
                                              m01_created_by_id_u17,
                                              m01_created_date,
                                              m01_modified_by_id_u17,
                                              m01_modified_date,
                                              m01_status_id_v01,
                                              m01_status_changed_by_id_u17,
                                              m01_status_changed_date,
                                              m01_calculation_type, -- [SAME TYPEs]
                                              m01_calculation_unit,
                                              m01_dif_commission_for_buy_sel,
                                              m01_custodian_fee_allowable,
                                              m01_tif_meta_info,
                                              m01_send_commodity_attribs,
                                              m01_send_forx_discount_para,
                                              m01_valid_t59,
                                              m01_margin_liquidate,
                                              m01_day_trading_liquidate,
                                              m01_day_trading_allowed,
                                              m01_day_trading_end_time,
                                              m01_day_trading_liquidate_time,
                                              m01_last_day_trd_liquidation,
                                              m01_minimum_disclosed_qty,
                                              m01_enable_all_non,
                                              m01_price_display_format,
                                              m01_mre_ord_allowed,
                                              m01_pre_open,
                                              m01_open,
                                              m01_pre_close,
                                              m01_close,
                                              m01_enable_max_commission,
                                              m01_enable_min_commission,
                                              m01_gmt_offset,
                                              m01_tag_40,
                                              m01_tag_54,
                                              m01_order_rej_period,
                                              m01_default_currency_code_m03,
                                              m01_eod_file_generate_time,
                                              m01_exchangecode_real,
                                              m01_tag_100_ric,
                                              m01_minmax_allow_validation,
                                              m01_country_id_m05,
                                              m01_offline_feed,
                                              m01_automate_market_status,
                                              m01_is_local,
                                              m01_allow_all_custodians,
                                              m01_is_symboldriven_exg,
                                              m01_min_price_tolerance,
                                              m01_max_price_tolerance,
                                              m01_trading_account_required,
                                              m01_investor_account_required,
                                              m01_real_time_svr_info,
                                              m01_back_lock_ser_info,
                                              m01_full_market_enable,
                                              m01_disclosed_qty_limit,
                                              m01_sent_account_closure_req,
                                              m01_enable_trade_rejection,
                                              m01_enable_short_selling_acc,
                                              m01_fail_mgm_acti_order_cancel,
                                              m01_charge_comm_for_custody,
                                              m01_settle_customer,
                                              m01_clubbing_enabled,
                                              m01_status_req_allowed,
                                              m01_symbol_status_req_allowed,
                                              m01_last_market_status_req_dat,
                                              m01_last_symbol_status_req_dat,
                                              m01_default_currency_id_m03,
                                              m01_gtd_no_of_days,
                                              m01_trade_processing,
                                              m01_max_qty_disclosed_ratio,
                                              m01_cross_trading_enabled,
                                              m01_custom_type,
                                              m01_institute_id_m02,
                                              m01_debit_maintain_margin,
                                              m01_tick_rule_validation,
                                              m01_cross_cur_trd_enabled)
                VALUES (l_exchange_id, -- m01_id
                        i.exchange_code, -- m01_exchange_code
                        i.m11_description_1, -- m01_description
                        i.m11_description_2, -- m01_description_lang
                        i.active_status, -- m01_status
                        i.m11_type, -- m01_type
                        i.m07_map_new_id, -- m01_location_id_m07
                        0, -- m01_offline | Not Available
                        0, -- m01_online_trader_id | Not Available
                        i.m11_weekend_holidays, -- m01_weekend_holidays
                        i.m11_buy_tplus, -- m01_buy_tplus
                        i.m11_sell_tplus, -- m01_sell_tplus
                        i.m11_active_status, -- m01_active_status
                        i.m11_minimum_order_value, -- m01_minimum_order_value
                        0, -- m01_custodian_require | Not Available
                        i.m11_lot_size, -- m01_lot_size
                        i.m11_use_submarket_for_trading, -- m01_use_submarket_for_trading
                        i.m11_minimum_unit_size, -- m01_minimum_unit_size
                        i.m11_price_multiplication_facto, -- m01_price_multiplication_facto
                        i.m11_exchange_account_required, -- m01_exchange_account_required
                        i.m11_exe_broker_ref_required, -- m01_exe_broker_ref_required
                        i.created_by_new_id, -- m01_created_by_id_u17
                        i.created_date, -- m01_created_date
                        i.modifed_by_new_id, -- m01_modified_by_id_u17
                        i.modified_date, -- m01_modified_date
                        i.map01_ntp_id, -- m01_status_id_v01
                        i.status_changed_by_new_id, -- m01_status_changed_by_id_u17
                        i.status_changed_date, -- m01_status_changed_date
                        i.m11_calculation_type, -- m01_calculation_type
                        i.m11_calculation_unit, -- m01_calculation_unit
                        i.m11_dif_commission_for_buy_sel, -- m01_dif_commission_for_buy_sel
                        i.m11_custodian_fee_allowable, -- m01_custodian_fee_allowable
                        i.m11_tif_meta_info, -- m01_tif_meta_info
                        i.m11_send_commodity_attribs, -- m01_send_commodity_attribs
                        i.m11_send_forx_discount_para, -- m01_send_forx_discount_para
                        i.m11_valid_t59, -- m01_valid_t59
                        i.m11_margin_liquidate, -- m01_margin_liquidate
                        i.m11_day_trading_liquidate, -- m01_day_trading_liquidate
                        i.m11_day_trading_allowed, -- m01_day_trading_allowed
                        i.m11_day_trading_end_time, -- m01_day_trading_end_time
                        i.m11_day_trading_liquidate_time, -- m01_day_trading_liquidate_time
                        i.m11_last_day_trd_liquidation, -- m01_last_day_trd_liquidation
                        i.m11_minimum_disclosed_qty, -- m01_minimum_disclosed_qty
                        i.m11_enable_all_non, -- m01_enable_all_non
                        i.m11_price_display_format, -- m01_price_display_format
                        i.m11_mre_ord_allowed, -- m01_mre_ord_allowed
                        i.m11_pre_open, -- m01_pre_open
                        i.m11_open, -- m01_open
                        i.m11_pre_close, -- m01_pre_close
                        i.m11_close, -- m01_close
                        i.m11_enable_max_commission, -- m01_enable_max_commission
                        i.m11_enable_min_commission, -- m01_enable_min_commission
                        i.m11_gmt_offset, -- m01_gmt_offset
                        i.m11_tag_40, -- m01_tag_40
                        i.m11_tag_54, -- m01_tag_54
                        i.m11_order_rej_period, -- m01_order_rej_period
                        i.m11_default_currency, -- m01_default_currency_code_m03,
                        i.m11_eod_file_generate_time, -- m01_eod_file_generate_time
                        i.m11_exchangecode_real, -- m01_exchangecode_real
                        i.m11_tag_100_ric, -- m01_tag_100_ric
                        i.m11_one_side_minmax_validation, -- m01_minmax_allow_validation
                        i.map06_ntp_id, -- m01_country_id_m05
                        i.m11_offline_feed, -- m01_offline_feed
                        NULL, -- m01_automate_market_status | No Usage & Asked to Update NULL by Dushantha (JIRA : NTPSFC-5111)
                        0, -- m01_is_local
                        1, -- m01_allow_all_custodians
                        i.m11_is_symboldriven_exg, -- m01_is_symboldriven_exg
                        i.m11_min_price_tolerance, -- m01_min_price_tolerance
                        i.m11_max_price_tolerance, -- m01_max_price_tolerance
                        0, -- m01_trading_account_required | Not Available
                        0, -- m01_investor_account_required | Not Available
                        NULL, -- m01_real_time_svr_info | Not Available
                        NULL, -- m01_back_lock_ser_info | Not Available
                        0, -- m01_full_market_enable | Not Available
                        0, -- m01_disclosed_qty_limit | Not Available
                        i.m11_sent_account_closure_req, -- m01_sent_account_closure_req
                        i.m11_enable_trade_rejection, -- m01_enable_trade_rejection
                        i.m11_enable_short_selling_acc, -- m01_enable_short_selling_acc
                        i.m11_fail_mgm_acti_order_cancel, -- m01_fail_mgm_acti_order_cancel
                        i.m11_charge_comm_for_custody, -- m01_charge_comm_for_custody
                        i.m11_settle_customer, -- m01_settle_customer
                        0, -- m01_clubbing_enabled | Not Available
                        i.status_req_allowed, -- m01_status_req_allowed
                        i.symbol_status_req_allowed, -- m01_symbol_status_req_allowed
                        NULL, -- m01_last_market_status_req_dat
                        NULL, -- m01_last_symbol_status_req_dat
                        i.m03_id, -- m01_default_currency_id_m03
                        i.m11_gtd_no_of_days, -- m01_gtd_no_of_days
                        i.trade_processing, -- m01_trade_processing
                        0, -- m01_max_qty_disclosed_ratio | Not Available
                        i.m11_cross_trading_enabled, -- m01_cross_trading_enabled
                        '1', -- m01_custom_type
                        l_primary_institute_id, -- m01_institute_id_m02
                        i.m11_debit_maintain_margin, -- m01_debit_maintain_margin
                        0, -- m01_tick_rule_validation | Not Available
                        i.cross_cur_trd_enabled -- m01_cross_cur_trd_enabled
                                               );
            ELSE
                UPDATE dfn_ntp.m01_exchanges
                   SET m01_description = i.m11_description_1, -- m01_description
                       m01_description_lang = i.m11_description_2, -- m01_description_lang
                       m01_status = i.active_status, -- m01_status
                       m01_type = i.m11_type, -- m01_type
                       m01_location_id_m07 = i.m07_map_new_id, -- m01_location_id_m07
                       m01_weekend_holidays = i.m11_weekend_holidays, -- m01_weekend_holidays
                       m01_buy_tplus = i.m11_buy_tplus, -- m01_buy_tplus
                       m01_sell_tplus = i.m11_sell_tplus, -- m01_sell_tplus
                       m01_active_status = i.m11_active_status, -- m01_active_status
                       m01_minimum_order_value = i.m11_minimum_order_value, -- m01_minimum_order_value
                       m01_lot_size = i.m11_lot_size, -- m01_lot_size
                       m01_use_submarket_for_trading =
                           i.m11_use_submarket_for_trading, -- m01_use_submarket_for_trading
                       m01_minimum_unit_size = i.m11_minimum_unit_size, -- m01_minimum_unit_size
                       m01_price_multiplication_facto =
                           i.m11_price_multiplication_facto, -- m01_price_multiplication_facto
                       m01_exchange_account_required =
                           i.m11_exchange_account_required, -- m01_exchange_account_required
                       m01_exe_broker_ref_required =
                           i.m11_exe_broker_ref_required, -- m01_exe_broker_ref_required
                       m01_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m01_modified_by_id_u17
                       m01_modified_date = NVL (i.modified_date, SYSDATE), -- m01_modified_date
                       m01_status_id_v01 = i.map01_ntp_id, -- m01_status_id_v01
                       m01_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m01_status_changed_by_id_u17
                       m01_status_changed_date = i.status_changed_date, -- m01_status_changed_date
                       m01_calculation_type = i.m11_calculation_type, -- m01_calculation_type
                       m01_calculation_unit = i.m11_calculation_unit, -- m01_calculation_unit
                       m01_dif_commission_for_buy_sel =
                           i.m11_dif_commission_for_buy_sel, -- m01_dif_commission_for_buy_sel
                       m01_custodian_fee_allowable =
                           i.m11_custodian_fee_allowable, -- m01_custodian_fee_allowable
                       m01_tif_meta_info = i.m11_tif_meta_info, -- m01_tif_meta_info
                       m01_send_commodity_attribs =
                           i.m11_send_commodity_attribs, -- m01_send_commodity_attribs
                       m01_send_forx_discount_para =
                           i.m11_send_forx_discount_para, -- m01_send_forx_discount_para
                       m01_valid_t59 = i.m11_valid_t59, -- m01_valid_t59
                       m01_margin_liquidate = i.m11_margin_liquidate, -- m01_margin_liquidate
                       m01_day_trading_liquidate = i.m11_day_trading_liquidate, -- m01_day_trading_liquidate
                       m01_day_trading_allowed = i.m11_day_trading_allowed, -- m01_day_trading_allowed
                       m01_day_trading_end_time = i.m11_day_trading_end_time, -- m01_day_trading_end_time
                       m01_day_trading_liquidate_time =
                           i.m11_day_trading_liquidate_time, -- m01_day_trading_liquidate_time
                       m01_last_day_trd_liquidation =
                           i.m11_last_day_trd_liquidation, -- m01_last_day_trd_liquidation
                       m01_minimum_disclosed_qty = i.m11_minimum_disclosed_qty, -- m01_minimum_disclosed_qty
                       m01_enable_all_non = i.m11_enable_all_non, -- m01_enable_all_non
                       m01_price_display_format = i.m11_price_display_format, -- m01_price_display_format
                       m01_mre_ord_allowed = i.m11_mre_ord_allowed, -- m01_mre_ord_allowed
                       m01_pre_open = i.m11_pre_open, -- m01_pre_open
                       m01_open = i.m11_open, -- m01_open
                       m01_pre_close = i.m11_pre_close, -- m01_pre_close
                       m01_close = i.m11_close, -- m01_close
                       m01_enable_max_commission = i.m11_enable_max_commission, -- m01_enable_max_commission
                       m01_enable_min_commission = i.m11_enable_min_commission, -- m01_enable_min_commission
                       m01_gmt_offset = i.m11_gmt_offset, -- m01_gmt_offset
                       m01_tag_40 = i.m11_tag_40, -- m01_tag_40
                       m01_tag_54 = i.m11_tag_54, -- m01_tag_54
                       m01_order_rej_period = i.m11_order_rej_period, -- m01_order_rej_period
                       m01_default_currency_code_m03 = i.m11_default_currency, -- m01_default_currency_code_m03,
                       m01_eod_file_generate_time =
                           i.m11_eod_file_generate_time, -- m01_eod_file_generate_time
                       m01_exchangecode_real = i.m11_exchangecode_real, -- m01_exchangecode_real
                       m01_tag_100_ric = i.m11_tag_100_ric, -- m01_tag_100_ric
                       m01_minmax_allow_validation =
                           i.m11_one_side_minmax_validation, -- m01_minmax_allow_validation
                       m01_country_id_m05 = i.map06_ntp_id, -- m01_country_id_m05
                       m01_offline_feed = i.m11_offline_feed, -- m01_offline_feed
                       m01_is_symboldriven_exg = i.m11_is_symboldriven_exg, -- m01_is_symboldriven_exg
                       m01_min_price_tolerance = i.m11_min_price_tolerance, -- m01_min_price_tolerance
                       m01_max_price_tolerance = i.m11_max_price_tolerance, -- m01_max_price_tolerance
                       m01_sent_account_closure_req =
                           i.m11_sent_account_closure_req, -- m01_sent_account_closure_req
                       m01_enable_trade_rejection =
                           i.m11_enable_trade_rejection, -- m01_enable_trade_rejection
                       m01_enable_short_selling_acc =
                           i.m11_enable_short_selling_acc, -- m01_enable_short_selling_acc
                       m01_fail_mgm_acti_order_cancel =
                           i.m11_fail_mgm_acti_order_cancel, -- m01_fail_mgm_acti_order_cancel
                       m01_charge_comm_for_custody =
                           i.m11_charge_comm_for_custody, -- m01_charge_comm_for_custody
                       m01_settle_customer = i.m11_settle_customer, -- m01_settle_customer
                       m01_status_req_allowed = i.status_req_allowed, -- m01_status_req_allowed
                       m01_symbol_status_req_allowed =
                           i.symbol_status_req_allowed, -- m01_symbol_status_req_allowed
                       m01_default_currency_id_m03 = i.m03_id, -- m01_default_currency_id_m03
                       m01_gtd_no_of_days = i.m11_gtd_no_of_days, -- m01_gtd_no_of_days
                       m01_trade_processing = i.trade_processing, -- m01_trade_processing
                       m01_cross_trading_enabled = i.m11_cross_trading_enabled, -- m01_cross_trading_enabled
                       m01_debit_maintain_margin = i.m11_debit_maintain_margin, -- m01_debit_maintain_margin
                       m01_cross_cur_trd_enabled = i.cross_cur_trd_enabled -- m01_cross_cur_trd_enabled
                 WHERE m01_id = i.m01_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M01_EXCHANGES',
                                i.exchange_code,
                                CASE
                                    WHEN i.m01_id IS NULL THEN l_exchange_id
                                    ELSE i.m01_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m01_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

BEGIN
    dfn_ntp.sp_stat_gather ('M01_EXCHANGES');
END;
/
