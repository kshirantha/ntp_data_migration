CREATE TABLE dfn_ntp.m20_symbol
(
    m20_id                          NUMBER (5, 0) NOT NULL,
    m20_exchange_id_m01             NUMBER (5, 0) NOT NULL,
    m20_symbol_code                 VARCHAR2 (25 BYTE) NOT NULL,
    m20_price_symbol_code_m20       VARCHAR2 (25 BYTE),
    m20_price_exchange_code_m01     VARCHAR2 (10 BYTE),
    m20_market_code_m29             VARCHAR2 (10 BYTE) NOT NULL,
    m20_instrument_type_code_v09    VARCHAR2 (4 BYTE),
    m20_currency_code_m03           VARCHAR2 (4 BYTE) NOT NULL,
    m20_trading_status_id_v22       NUMBER (4, 0),
    m20_status_id_v01               NUMBER (4, 0) NOT NULL,
    m20_access_level_id_v01         NUMBER (4, 0),
    m20_restricted_direction        NUMBER (2, 0) DEFAULT 0,
    m20_minprice                    NUMBER (10, 4) DEFAULT 0,
    m20_maxprice                    NUMBER (10, 4) DEFAULT 0,
    m20_lasttradeprice              NUMBER (10, 4) DEFAULT 0,
    m20_lot_size                    NUMBER (10, 0) DEFAULT 1 NOT NULL,
    m20_settle_category_v11         NUMBER (4, 0) DEFAULT 0,
    m20_price_ratio                 NUMBER (18, 5) DEFAULT 1 NOT NULL,
    m20_sharia_complient            NUMBER (1, 0) DEFAULT 0,
    m20_reuters_code                VARCHAR2 (30 BYTE),
    m20_isincode                    VARCHAR2 (30 BYTE),
    m20_cusip_no                    VARCHAR2 (30 BYTE),
    m20_country_m05_id              NUMBER (5, 0) NOT NULL,
    m20_small_orders                NUMBER (22, 1) DEFAULT 1,
    m20_small_order_value           NUMBER (22, 18) DEFAULT 1,
    m20_minimum_unit_size           NUMBER (22, 5) DEFAULT 1 NOT NULL,
    m20_bloomberg_code              VARCHAR2 (30 BYTE),
    m20_status_changed_by_id_u17    NUMBER (4, 0) NOT NULL,
    m20_status_changed_date         DATE NOT NULL,
    m20_created_by_id_u17           NUMBER (5, 0) NOT NULL,
    m20_created_date                DATE NOT NULL,
    m20_last_updated_by_id_u17      NUMBER (5, 0),
    m20_last_updated_date           DATE,
    m20_external_ref                VARCHAR2 (100 BYTE),
    m20_short_description           VARCHAR2 (400 BYTE),
    m20_short_description_lang      VARCHAR2 (400 BYTE),
    m20_long_description            VARCHAR2 (400 BYTE),
    m20_long_description_lang       VARCHAR2 (400 BYTE),
    m20_price_instrument_type_v09   NUMBER (5, 0),
    m20_is_white_symbol             NUMBER (1, 0) DEFAULT 0,
    m20_market_segment              NUMBER (1, 0),
    m20_exchange_code_m01           VARCHAR2 (10 BYTE) NOT NULL,
    m20_base_symbol_m20             VARCHAR2 (25 BYTE),
    m20_trading_allowed             NUMBER (1, 0) DEFAULT 0,
    m20_online_trading_allowed      NUMBER (1, 0) DEFAULT 0,
    m20_modified_by_id_u17          NUMBER (4, 0),
    m20_modified_date               DATE,
    m20_currency_id_m03             NUMBER (5, 0) NOT NULL,
    m20_base_exchange_code_m01      VARCHAR2 (10 BYTE),
    m20_base_symbol_id_m20          NUMBER (5, 0),
    m20_base_exchange_id_m01        NUMBER (5, 0),
    m20_date_of_last_price          DATE,
    m20_previous_closed             NUMBER (10, 4) DEFAULT 0,
    m20_today_closed                NUMBER (10, 4) DEFAULT 0,
    m20_instrument_type_id_v09      NUMBER (3, 0),
    m20_exchange_symbol_code_m20    VARCHAR2 (255 BYTE),
    m20_vwap                        NUMBER (21, 6) DEFAULT 0,
    m20_expire_date                 DATE,
    m20_strike_price                NUMBER (10, 4),
    m20_option_type                 NUMBER (1, 0),
    m20_sectors_id_m63              NUMBER (5, 0),
    m20_price_instrument_id_v34     NUMBER (5, 0),
    m20_minimum_discloused_qty      NUMBER (10, 0),
    m20_price_instrument_code_v34   VARCHAR2 (50 BYTE),
    m20_bestbidprice                NUMBER (10, 4),
    m20_bestaskprice                NUMBER (10, 4),
    m20_price_type                  NUMBER (1, 0),
    m20_custom_type                 VARCHAR2 (50 BYTE) DEFAULT 1,
    m20_static_min                  NUMBER (21, 5),
    m20_static_max                  NUMBER (21, 5),
    m20_institute_id_m02            NUMBER (3, 0) DEFAULT 1,
    m20_market_id_m29               NUMBER (10, 0),
    PRIMARY KEY (m20_id)
)
/


COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_institute_id_m02 IS
    'Primary Institution'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_is_white_symbol IS
    '0 - QFI trade Denied | QFI Trade Acceptable'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_market_segment IS 'V01 : Type 27'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_option_type IS '0 - Put | 1 - Call'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_price_instrument_code_v34 IS
    'Price Instrument Type Code'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_price_instrument_id_v34 IS
    'Price Instrument Type PK'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_price_type IS
    '0 - Price | 1- Quantity'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_restricted_direction IS
    '0 - No Restriction | 1 - Buy Restriction | 2 - Sell Restriction'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_sectors_id_m63 IS 'FK from M63'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_small_orders IS '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_vwap IS
    'Volume Weighted Avarge Price for Symbol ( Trunover / Volume )'
/

ALTER TABLE dfn_ntp.m20_symbol
 MODIFY (
  m20_symbol_code VARCHAR2 (50 BYTE),
  m20_price_symbol_code_m20 VARCHAR2 (50 BYTE)

 )
/

ALTER TABLE dfn_ntp.m20_symbol
 ADD (
  m20_benchmark VARCHAR2 (20 BYTE),
  m20_buy_tplus NUMBER (2, 0),
  m20_sell_tplus NUMBER (2, 0)
 )
/

ALTER TABLE dfn_ntp.m20_symbol
 MODIFY (
  m20_price_type NUMBER (3, 0)

 )
/
ALTER TABLE dfn_ntp.m20_symbol
 ADD (
  m20_initial_margin_value NUMBER (18, 5)
 )
/

ALTER TABLE dfn_ntp.m20_symbol
	ADD (m20_fixing_price NUMBER (10, 4) DEFAULT 0)
/

ALTER TABLE dfn_ntp.m20_symbol
	MODIFY (m20_initial_margin_value DEFAULT 0)
/

UPDATE dfn_ntp.m20_symbol
   SET m20_initial_margin_value = 0
 WHERE m20_initial_margin_value IS NULL;
 
 ALTER TABLE dfn_ntp.m20_symbol
 ADD (
  m20_quantity_decimal_factor NUMBER (10, 5) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.m20_symbol
 ADD (
  M20_CLIENT_FEE_PER_BUY_B NUMBER (10, 4),
  M20_STAFF_FEE_PER_BUY_B NUMBER (10, 4),
  M20_YTD_NAV_B NUMBER (10, 4) DEFAULT 0,
  M20_DATE_OF_YTD_NAV_B DATE
 )
/

ALTER TABLE dfn_ntp.m20_symbol
 ADD (
  M20_RISK_PROFILE_B NUMBER (1)
 )
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_risk_profile_b IS '1 - HIGH | 2 - MEDIUM | 3 - LOW'
/

ALTER TABLE dfn_ntp.m20_symbol
 ADD (
  m20_short_selling NUMBER (1) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_short_selling IS '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.m20_symbol
 ADD (
  m20_trade_type_v01 NUMBER (5)
 )
/
COMMENT ON COLUMN dfn_ntp.m20_symbol.m20_trade_type_v01 IS 'FK v01_type = 27'
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_SHARE_CLASS_B                     VARCHAR2(30)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_SHARE_CLASS_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_SHARE_CLASS_DESC_B                        VARCHAR2(400)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_SHARE_CLASS_DESC_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_SHARE_CLS_DESC_LANG_B                     VARCHAR2(400)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_SHARE_CLS_DESC_LANG_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_FUND_FAMILY_B                     VARCHAR2(30 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_FUND_FAMILY_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_ASSET_TYPE_B                      VARCHAR2(30 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_ASSET_TYPE_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_ASSET_TYPE_DESC_B                         VARCHAR2(400 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_ASSET_TYPE_DESC_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_ASSET_TYPE_DESC_LANG_B                    VARCHAR2(400 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_ASSET_TYPE_DESC_LANG_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_MARKET_B                          VARCHAR2(30 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_MARKET_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_MARKET_DESC_B                             VARCHAR2(400 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_MARKET_DESC_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_MARKET_DESC_LANG_B                        VARCHAR2(400 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_MARKET_DESC_LANG_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_REGION_B                          VARCHAR2(30 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_REGION_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_REGION_DESC_B                             VARCHAR2(400 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_REGION_DESC_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_REGION_DESC_LANG_B                        VARCHAR2(400 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_REGION_DESC_LANG_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_FUND_INV_PROFILE_B                        VARCHAR2(1000 )) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_FUND_INV_PROFILE_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_FUND_SIZE_B                       NUMBER (10, 4)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_FUND_SIZE_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_NAV_INCEPTION_B                   NUMBER (10, 4)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_NAV_INCEPTION_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_COMPARATIVE_INDEX_B               NUMBER (10, 4)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_COMPARATIVE_INDEX_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_DATE_OF_INCEPTTION_B              DATE) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_DATE_OF_INCEPTTION_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_SUB_FEE_B                                 NUMBER (10, 4)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_SUB_FEE_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_MANAGEMENT_FEE_B                  NUMBER (10, 4)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_MANAGEMENT_FEE_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_MINIMUM_SUB_B                             NUMBER (10, 4)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_MINIMUM_SUB_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_DEALING_DAYS_B                    NUMBER (5, 0)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_DEALING_DAYS_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_ANNOUNCE_DAYS_B                   NUMBER (5, 0)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_ANNOUNCE_DAYS_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_SUB_REDEM_CUT_OFF_B                               NUMBER (10, 4)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_SUB_REDEM_CUT_OFF_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (M20_REDEM_PAYMENT_B                           NUMBER (10, 4)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('M20_REDEM_PAYMENT_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/



ALTER TABLE dfn_ntp.m20_symbol
 MODIFY (
  m20_previous_closed NUMBER (21, 6),
  m20_today_closed NUMBER (21, 6),
  m20_strike_price NUMBER (21, 8),
  m20_bestbidprice NUMBER (21, 6),
  m20_bestaskprice NUMBER (21, 6),
  m20_minprice NUMBER (21, 6),
  m20_maxprice NUMBER (21, 6),
  m20_lasttradeprice NUMBER (21, 6)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_fund_type_b                          VARCHAR2(30)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_fund_type_b');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_fund_family_desc_b                          VARCHAR2(200)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_fund_family_desc_b');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_fund_family_desc_lang_b                          VARCHAR2(200)) ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_fund_family_desc_lang_b');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_fund_size_b_temp VARCHAR2 (30))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_fund_size_b_temp = m20_fund_size_b';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol MODIFY ( m20_fund_size_b VARCHAR2 (30))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_fund_size_b = m20_fund_size_b_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol DROP COLUMN m20_fund_size_b_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_fund_size_b');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.m20_symbol
           SET m20_fund_size_b = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/

DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_nav_inception_b_temp VARCHAR2 (30))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_nav_inception_b_temp = m20_nav_inception_b';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol MODIFY ( m20_nav_inception_b VARCHAR2 (30))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_nav_inception_b = m20_nav_inception_b_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol DROP COLUMN m20_nav_inception_b_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_nav_inception_b');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.m20_symbol
           SET m20_nav_inception_b = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/

DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_comparative_index_b_temp VARCHAR2 (100))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_comparative_index_b_temp = m20_comparative_index_b';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol MODIFY ( m20_comparative_index_b VARCHAR2 (100))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_comparative_index_b = m20_comparative_index_b_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol DROP COLUMN m20_comparative_index_b_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_comparative_index_b');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.m20_symbol
           SET m20_comparative_index_b = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/


DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_sub_fee_b_temp VARCHAR2 (100))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_sub_fee_b_temp = m20_sub_fee_b';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol MODIFY ( m20_sub_fee_b VARCHAR2 (100))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_sub_fee_b = m20_sub_fee_b_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol DROP COLUMN m20_sub_fee_b_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_sub_fee_b');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.m20_symbol
           SET m20_sub_fee_b = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/

DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_management_fee_b_temp VARCHAR2 (100))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_management_fee_b_temp = m20_management_fee_b';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol MODIFY ( m20_management_fee_b VARCHAR2 (100))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_management_fee_b = m20_management_fee_b_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol DROP COLUMN m20_management_fee_b_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_management_fee_b');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.m20_symbol
           SET m20_management_fee_b = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/


DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_dealing_days_b_temp VARCHAR2 (100))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_dealing_days_b_temp = m20_dealing_days_b';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol MODIFY ( m20_dealing_days_b VARCHAR2 (100))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_dealing_days_b = m20_dealing_days_b_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol DROP COLUMN m20_dealing_days_b_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_dealing_days_b');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.m20_symbol
           SET m20_dealing_days_b = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/


DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_announce_days_b_temp VARCHAR2 (200))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_announce_days_b_temp = m20_announce_days_b';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol MODIFY ( m20_announce_days_b VARCHAR2 (200))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_announce_days_b = m20_announce_days_b_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol DROP COLUMN m20_announce_days_b_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_announce_days_b');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.m20_symbol
           SET m20_announce_days_b = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/


DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_sub_redem_cut_off_b_temp VARCHAR2 (200))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_sub_redem_cut_off_b_temp = m20_sub_redem_cut_off_b';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol MODIFY ( m20_sub_redem_cut_off_b VARCHAR2 (200))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_sub_redem_cut_off_b = m20_sub_redem_cut_off_b_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol DROP COLUMN m20_sub_redem_cut_off_b_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_sub_redem_cut_off_b');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.m20_symbol
           SET m20_sub_redem_cut_off_b = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/


DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol ADD (m20_redem_payment_b_temp VARCHAR2 (200))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_redem_payment_b_temp = m20_redem_payment_b';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol MODIFY ( m20_redem_payment_b VARCHAR2 (200))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol SET m20_redem_payment_b = m20_redem_payment_b_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol DROP COLUMN m20_redem_payment_b_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol')
           AND column_name = UPPER ('m20_redem_payment_b');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.m20_symbol
           SET m20_redem_payment_b = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/

ALTER TABLE dfn_ntp.m20_symbol MODIFY (m20_id NUMBER (10))
/

ALTER TABLE dfn_ntp.m20_symbol MODIFY (m20_base_symbol_id_m20 NUMBER (10))
/
