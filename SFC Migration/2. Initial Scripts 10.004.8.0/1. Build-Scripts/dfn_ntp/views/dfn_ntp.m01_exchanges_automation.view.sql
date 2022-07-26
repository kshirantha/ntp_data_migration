CREATE OR REPLACE FORCE VIEW dfn_ntp.m01_exchanges_automation
(
   m01_id,
   m01_pre_open,
   m01_open,
   m01_pre_close,
   m01_close,
   m01_eod_file_generate_time,
   m01_day_trading_end_time,
   m01_day_trading_liquidate_time,
   m01_created_by_id_u17,
   m01_created_date,
   m01_modified_by_id_u17,
   m01_modified_date,
   m01_status_id_v01,
   m01_status_changed_by_id_u17,
   m01_status_changed_date,
   m01_last_day_trd_liquidation,
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
   m01_calculation_type,
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
   m01_minimum_disclosed_qty,
   m01_enable_all_non,
   m01_price_display_format,
   m01_mre_ord_allowed,
   m01_enable_max_commission,
   m01_enable_min_commission,
   m01_gmt_offset,
   m01_tag_40,
   m01_tag_54,
   m01_order_rej_period,
   m01_default_currency_code_m03,
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
   m01_cross_cur_trd_enabled )
AS
SELECT m01.m01_id,
       TO_CHAR (TO_DATE (m01.m01_pre_open, 'HH24:MI'), 'HH24:MI')
                                                               AS m01_pre_open,
       TO_CHAR (TO_DATE (m01.m01_open, 'HH24:MI'), 'HH24:MI') AS m01_open,
       TO_CHAR (TO_DATE (m01.m01_pre_close, 'HH24:MI'), 'HH24:MI')
                                                               AS m01_pre_close,
       TO_CHAR (TO_DATE (m01.m01_close, 'HH24:MI'), 'HH24:MI') AS m01_close,
       TO_CHAR (TO_DATE (m01.m01_eod_file_generate_time, 'HH24:MI'),
                'HH24:MI')
                                                               AS m01_eod_file_generate_time,
       TO_CHAR (TO_DATE (m01.m01_day_trading_end_time, 'HH24:MI'), 'HH24:MI')
                                                               AS m01_day_trading_end_time,
       TO_CHAR (TO_DATE (m01.m01_day_trading_liquidate_time, 'HH24:MI'),
                'HH24:MI')
                                                               AS m01_day_trading_liquidate_time,
       m01.m01_created_by_id_u17,
       m01.m01_created_date,
       m01.m01_modified_by_id_u17,
       m01.m01_modified_date,
       m01.m01_status_id_v01,
       m01.m01_status_changed_by_id_u17,
       m01.m01_status_changed_date,
       m01.m01_last_day_trd_liquidation,
       m01.m01_exchange_code,
       m01.m01_description,
       m01.m01_description_lang,
       m01.m01_status,
       m01.m01_type,
       m01.m01_location_id_m07,
       m01.m01_offline,
       m01.m01_online_trader_id,
       m01.m01_weekend_holidays,
       m01.m01_buy_tplus,
       m01.m01_sell_tplus,
       m01.m01_active_status,
       m01.m01_minimum_order_value,
       m01.m01_custodian_require,
       m01.m01_lot_size,
       m01.m01_use_submarket_for_trading,
       m01.m01_minimum_unit_size,
       m01.m01_price_multiplication_facto,
       m01.m01_exchange_account_required,
       m01.m01_exe_broker_ref_required,
       m01.m01_calculation_type,
       m01.m01_calculation_unit,
       m01.m01_dif_commission_for_buy_sel,
       m01.m01_custodian_fee_allowable,
       m01.m01_tif_meta_info,
       m01.m01_send_commodity_attribs,
       m01.m01_send_forx_discount_para,
       m01.m01_valid_t59,
       m01.m01_margin_liquidate,
       m01.m01_day_trading_liquidate,
       m01.m01_day_trading_allowed,
       m01.m01_minimum_disclosed_qty,
       m01.m01_enable_all_non,
       m01.m01_price_display_format,
       m01.m01_mre_ord_allowed,
       m01.m01_enable_max_commission,
       m01.m01_enable_min_commission,
       m01.m01_gmt_offset,
       m01.m01_tag_40,
       m01.m01_tag_54,
       m01.m01_order_rej_period,
       m01.m01_default_currency_code_m03,
       m01.m01_exchangecode_real,
       m01.m01_tag_100_ric,
       m01.m01_minmax_allow_validation,
       m01.m01_country_id_m05,
       m01.m01_offline_feed,
       m01.m01_automate_market_status,
       m01.m01_is_local,
       m01.m01_allow_all_custodians,
       m01.m01_is_symboldriven_exg,
       m01.m01_min_price_tolerance,
       m01.m01_max_price_tolerance,
       m01.m01_trading_account_required,
       m01.m01_investor_account_required,
       m01.m01_real_time_svr_info,
       m01.m01_back_lock_ser_info,
       m01.m01_full_market_enable,
       m01.m01_disclosed_qty_limit,
       m01.m01_sent_account_closure_req,
       m01.m01_enable_trade_rejection,
       m01.m01_enable_short_selling_acc,
       m01.m01_fail_mgm_acti_order_cancel,
       m01.m01_charge_comm_for_custody,
       m01.m01_settle_customer,
       m01.m01_clubbing_enabled,
       m01.m01_status_req_allowed,
       m01.m01_symbol_status_req_allowed,
       m01.m01_last_market_status_req_dat,
       m01.m01_last_symbol_status_req_dat,
       m01.m01_default_currency_id_m03,
       m01.m01_gtd_no_of_days,
       m01.m01_trade_processing,
       m01.m01_max_qty_disclosed_ratio,
       m01.m01_cross_trading_enabled,
       m01.m01_custom_type,
       m01.m01_institute_id_m02,
       m01.m01_debit_maintain_margin,
       m01.m01_tick_rule_validation,
       m01.m01_cross_cur_trd_enabled
FROM m01_exchanges m01
/