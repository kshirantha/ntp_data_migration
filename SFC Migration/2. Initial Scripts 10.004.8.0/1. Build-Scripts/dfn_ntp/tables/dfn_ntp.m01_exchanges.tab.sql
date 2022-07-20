CREATE TABLE dfn_ntp.m01_exchanges (
    m01_id NUMBER (5, 0) NOT NULL,
    m01_exchange_code VARCHAR2 (10 BYTE) NOT NULL,
    m01_description NVARCHAR2 (50) NOT NULL,
    m01_description_lang NVARCHAR2 (50) NOT NULL,
    m01_status NUMBER (1, 0),
    m01_type NUMBER (1, 0),
    m01_location_id_m07 NUMBER (5, 0),
    m01_offline NUMBER (1, 0),
    m01_online_trader_id NUMBER (10, 0),
    m01_weekend_holidays VARCHAR2 (15 BYTE),
    m01_buy_tplus NUMBER (2, 0) DEFAULT 0,
    m01_sell_tplus NUMBER (2, 0) DEFAULT 2,
    m01_active_status NUMBER (1, 0) DEFAULT 1,
    m01_minimum_order_value NUMBER (20, 5) DEFAULT 0 NOT NULL,
    m01_custodian_require NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m01_lot_size NUMBER (5, 0) DEFAULT 1 NOT NULL,
    m01_use_submarket_for_trading NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m01_minimum_unit_size NUMBER (5, 0) DEFAULT 1 NOT NULL,
    m01_price_multiplication_facto NUMBER (5, 0) DEFAULT 1 NOT NULL,
    m01_exchange_account_required NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m01_exe_broker_ref_required NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m01_created_by_id_u17 NUMBER (20, 0),
    m01_created_date DATE,
    m01_modified_by_id_u17 NUMBER (20, 0),
    m01_modified_date DATE,
    m01_status_id_v01 NUMBER (20, 0),
    m01_status_changed_by_id_u17 NUMBER (20, 0),
    m01_status_changed_date DATE,
    m01_calculation_type NUMBER (2, 0) DEFAULT 1 NOT NULL,
    m01_calculation_unit NUMBER (2, 0) DEFAULT 1 NOT NULL,
    m01_dif_commission_for_buy_sel NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m01_custodian_fee_allowable NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m01_tif_meta_info VARCHAR2 (20 BYTE) DEFAULT '0|0,7|5,8|0',
    m01_send_commodity_attribs NUMBER (1, 0) DEFAULT 0,
    m01_send_forx_discount_para NUMBER (1, 0) DEFAULT 0,
    m01_valid_t59 VARCHAR2 (50 BYTE) DEFAULT '0',
    m01_margin_liquidate NUMBER (1, 0) DEFAULT 0,
    m01_day_trading_liquidate NUMBER (1, 0) DEFAULT 0,
    m01_day_trading_allowed NUMBER (1, 0) DEFAULT 0,
    m01_day_trading_end_time VARCHAR2 (6 BYTE),
    m01_day_trading_liquidate_time VARCHAR2 (6 BYTE),
    m01_last_day_trd_liquidation DATE,
    m01_minimum_disclosed_qty NUMBER (10, 0) DEFAULT 0 NOT NULL,
    m01_enable_all_non NUMBER (1, 0) DEFAULT 0,
    m01_price_display_format VARCHAR2 (75 BYTE)
            DEFAULT '###,###,##0.00' NOT NULL,
    m01_mre_ord_allowed NUMBER (1, 0) DEFAULT 0,
    m01_pre_open VARCHAR2 (4 BYTE),
    m01_open VARCHAR2 (4 BYTE),
    m01_pre_close VARCHAR2 (4 BYTE),
    m01_close VARCHAR2 (4 BYTE),
    m01_enable_max_commission NUMBER (1, 0) DEFAULT 1 NOT NULL,
    m01_enable_min_commission NUMBER (1, 0) DEFAULT 1 NOT NULL,
    m01_gmt_offset NUMBER (6, 2) DEFAULT NULL,
    m01_tag_40 VARCHAR2 (50 BYTE) DEFAULT '1,2',
    m01_tag_54 VARCHAR2 (50 BYTE) DEFAULT '1,2',
    m01_order_rej_period NUMBER (5, 0) DEFAULT 0 NOT NULL,
    m01_default_currency_code_m03 CHAR (3 BYTE),
    m01_eod_file_generate_time VARCHAR2 (10 BYTE),
    m01_exchangecode_real VARCHAR2 (10 BYTE),
    m01_tag_100_ric VARCHAR2 (10 BYTE),
    m01_minmax_allow_validation NUMBER (1, 0) DEFAULT 0,
    m01_country_id_m05 NUMBER (5, 0),
    m01_offline_feed NUMBER (1, 0) DEFAULT 0,
    m01_automate_market_status NUMBER (1, 0) DEFAULT 0,
    m01_is_local NUMBER (1, 0) DEFAULT 0,
    m01_allow_all_custodians NUMBER (1, 0) DEFAULT 1,
    m01_is_symboldriven_exg NUMBER (1, 0) DEFAULT 0,
    m01_min_price_tolerance NUMBER (5, 2) DEFAULT 0,
    m01_max_price_tolerance NUMBER (5, 2) DEFAULT 0,
    m01_trading_account_required NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m01_investor_account_required NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m01_real_time_svr_info VARCHAR2 (100 BYTE),
    m01_back_lock_ser_info VARCHAR2 (100 BYTE),
    m01_full_market_enable NUMBER (1, 0) DEFAULT 0,
    m01_disclosed_qty_limit NUMBER (20, 0) DEFAULT 0,
    m01_sent_account_closure_req NUMBER (1, 0) DEFAULT 0,
    m01_enable_trade_rejection NUMBER (1, 0) DEFAULT 0,
    m01_enable_short_selling_acc NUMBER (1, 0) DEFAULT 0,
    m01_fail_mgm_acti_order_cancel NUMBER (1, 0) DEFAULT 0,
    m01_charge_comm_for_custody NUMBER (1, 0) DEFAULT 0,
    m01_settle_customer NUMBER (1, 0) DEFAULT 0,
    m01_clubbing_enabled NUMBER (1, 0) DEFAULT 0,
    m01_status_req_allowed NUMBER (1, 0),
    m01_symbol_status_req_allowed NUMBER (1, 0),
    m01_last_market_status_req_dat DATE,
    m01_last_symbol_status_req_dat DATE,
    m01_default_currency_id_m03 NUMBER (5, 0),
    m01_gtd_no_of_days NUMBER (3, 0) DEFAULT 30,
    m01_trade_processing NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m01_max_qty_disclosed_ratio NUMBER (20, 5) DEFAULT 0,
    m01_cross_trading_enabled NUMBER (1, 0) DEFAULT 1,
    m01_custom_type VARCHAR2 (50 BYTE) DEFAULT 1,
    m01_institute_id_m02 NUMBER (3, 0) DEFAULT 1)
/

ALTER TABLE dfn_ntp.m01_exchanges
ADD CONSTRAINT m01_pk PRIMARY KEY (m01_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_active_status IS
    '1=Active 0=Not Active'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_allow_all_custodians IS
    '1= Allow to use all custodians in trading acc, 0=use assigned custodians only'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_automate_market_status IS
    '0 - None, 1 - Pre Open, 2 - Close, 3 - Both'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_back_lock_ser_info IS
    'Secondary Real time price server information'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_calculation_type IS
    'Comission calculation type 1=Order Value, 2=Order Qty,3=Order Price'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_calculation_unit IS
    'commission calculation unit 1=Per Order,2=Per Day, 3=Per Week, 4=Per Month'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_charge_comm_for_custody IS
    'Charge Commision for Custody Client =1'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_clubbing_enabled IS
    'Enable clubbing make this 1'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_country_id_m05 IS
    'FK FROM m05_country'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_cross_trading_enabled IS
    '1=Yes, 0=No'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_custodian_require IS
    '1=Require custodian for trading, 0 =No'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_day_trading_allowed IS
    '0 = No 1 = Yes'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_day_trading_end_time IS 'HHMMSS'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_day_trading_liquidate IS
    'Allow day trading liquidate'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_day_trading_liquidate_time IS
    'HHMMSS'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_default_currency_id_m03 IS
    'fk from m03'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_dif_commission_for_buy_sel IS
    'comission is different for buy and sell orders1=yes,0=no'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_enable_short_selling_acc IS
    'Enable Short Selling Accounts'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_enable_trade_rejection IS
    'Enable Trade Rejection'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_exchange_account_required IS
    'whether exchange account is required when creating exchange accoutns for customers(applicable in MBS)'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_exe_broker_ref_required IS
    'whether executing broker reference is required when creating exchange accoutns for customers(applicable in MBS)'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_fail_mgm_acti_order_cancel IS
    'Initiated Cancel = 1'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_full_market_enable IS
    '0-Disable,1-Enable'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_institute_id_m02 IS
    'Primary Institution'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_investor_account_required IS
    'whether investor account no is required when creating exchange accoutns for customers'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_is_local IS
    '1= Local exchange in the country, 0 = No'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_is_symboldriven_exg IS
    ' This is to indicate , this exchnage is symbol driven or not'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_last_day_trd_liquidation IS
    'Last day trading liquidation time for an Exchange'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_last_market_status_req_dat IS
    'Last daily market status requested date'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_last_symbol_status_req_dat IS
    'Last daily symbol security status requested date'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_lot_size IS 'Lot size'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_margin_liquidate IS
    'Allow margin liquidate'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_minimum_disclosed_qty IS
    'minimum disclosed qty for exchange'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_minimum_unit_size IS
    'order quntity should be amultiple of unit size. this is applied only if m20_minimum_unit_size is 1'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_offline_feed IS '0 - No, 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_price_multiplication_facto IS
    'price multiplication factor/ the values in t01 and others should be * when reding and ? when saving by this value'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_real_time_svr_info IS
    'Primary Real time price server information'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_sent_account_closure_req IS
    'sent account closure Request to exchange 0 - No, 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_settle_customer IS
    '1 = EOD,  0 = SOD'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_status_req_allowed IS
    'Enable sending daily market status request'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_symbol_status_req_allowed IS
    'Enable sending daily symbol security status request'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_trade_processing IS
    '1 = trade processing, 0 = auto settling'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_trading_account_required IS
    'whether trading account no is required when creating exchange accoutns for customers'
/
COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_use_submarket_for_trading IS
    'whether to use sub market for trading'
/

ALTER TABLE dfn_ntp.m01_exchanges
	ADD (m01_debit_maintain_margin NUMBER (1) DEFAULT 0)
/

COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_debit_maintain_margin IS
	'0 - No, 1 - Yes'
/

CREATE INDEX idx_m01_exchange_code
    ON dfn_ntp.m01_exchanges (m01_exchange_code)
/

CREATE INDEX idx_m01_institute_id_m02
    ON dfn_ntp.m01_exchanges (m01_institute_id_m02)
/

ALTER TABLE dfn_ntp.M01_EXCHANGES 
 ADD (
  m01_tick_rule_validation NUMBER DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.M01_EXCHANGES.m01_tick_rule_validation IS '0 - No, 1 - Yes'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m01_exchanges ADD (  m01_cross_cur_trd_enabled NUMBER (1) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m01_exchanges')
           AND column_name = UPPER ('m01_cross_cur_trd_enabled');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.m01_exchanges.m01_cross_cur_trd_enabled IS
    '0 - No, 1 - Yes'
/
