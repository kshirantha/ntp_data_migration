-- Table DFN_NTP.M73_MARGIN_PRODUCTS

CREATE TABLE dfn_ntp.m73_margin_products
(
    m73_id                         NUMBER (3, 0),
    m73_institution_m02_id         NUMBER (10, 0),
    m73_name                       VARCHAR2 (50),
    m73_description                VARCHAR2 (250),
    m73_risk_owner                 NUMBER (1, 0),
    m73_equation                   NUMBER (2, 0),
    m73_product_group              VARCHAR2 (50),
    m73_created_by_id_u17          NUMBER (10, 0),
    m73_created_date               DATE,
    m73_modified_by_id_u17         NUMBER (10, 0),
    m73_modified_date              DATE,
    m73_status_id_v01              NUMBER (2, 0) DEFAULT 1,
    m73_status_changed_by_id_u17   NUMBER (10, 0),
    m73_status_changed_date        DATE,
    m73_product_type               NUMBER (2, 0)
)
/

-- Constraints for  DFN_NTP.M73_MARGIN_PRODUCTS


  ALTER TABLE dfn_ntp.m73_margin_products ADD CONSTRAINT pk_m73_id PRIMARY KEY (m73_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m73_margin_products MODIFY (m73_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m73_margin_products MODIFY (m73_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m73_margin_products MODIFY (m73_risk_owner NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m73_margin_products MODIFY (m73_equation NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M73_MARGIN_PRODUCTS

COMMENT ON COLUMN dfn_ntp.m73_margin_products.m73_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m73_margin_products.m73_institution_m02_id IS
    'fk from m02'
/
COMMENT ON COLUMN dfn_ntp.m73_margin_products.m73_risk_owner IS
    '1 - Broker, 2 - Bank'
/
COMMENT ON COLUMN dfn_ntp.m73_margin_products.m73_equation IS
    'Change broker to broker and logic inside OMS code'
/
COMMENT ON COLUMN dfn_ntp.m73_margin_products.m73_created_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m73_margin_products.m73_modified_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m73_margin_products.m73_status_id_v01 IS
    'fk from v01'
/
COMMENT ON COLUMN dfn_ntp.m73_margin_products.m73_status_changed_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m73_margin_products.m73_product_type IS
    '1 - Coverage Ratio, 2 - Initial Margin'
/
-- End of DDL Script for Table DFN_NTP.M73_MARGIN_PRODUCTS

alter table dfn_ntp.M73_MARGIN_PRODUCTS
	add M73_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
 ADD (
  M73_MARGIN_CATEGORY_ID_V01 NUMBER (10, 0)
 )
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_MARGIN_CATEGORY_ID_V01 IS '1-Murabaha, 2- Conventional Margin'
/

ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
 ADD (
  M73_MARGIN_PRODUCT_EQ_ID_V36 NUMBER (3, 0)
 )
/


ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
 ADD (
  M73_MARGIN_PRODUCT_EQ_ID_V01 NUMBER (3)
 )
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_MARGIN_PRODUCT_EQ_ID_V01 IS 'V01_TYPE = 30'
/

ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
 ADD (
  M73_SYMBOL_MARGBLTY_GRP_ID_M77 NUMBER (10, 0),
  M73_STOCK_CONCENT_GRP_ID_M75 NUMBER (10, 0),
  M73_MARGIN_INTEREST_GRP_ID_M74 NUMBER (10, 0),
  M73_DISPLAY_BUYING_POWER NUMBER (1, 0) DEFAULT 0,
  M73_AGENT_ID_U07 NUMBER (10, 0),
  M73_AGENT_FEE_TYPE NUMBER (1, 0),
  M73_AGENT_FEE NUMBER (10, 5),
  M73_MINIMUM_TRADING_EXPERIENCE NUMBER (3, 0),
  M73_ONLINE_ALLOWED NUMBER (1, 0) DEFAULT 0,
  M73_MIN_AMOUNT NUMBER (10, 5),
  M73_MAX_AMOUNT NUMBER (10, 5),
  M73_CURRENCY_ID_M03 NUMBER (10, 0),
  M73_CURRENCY_CODE_M03 CHAR (3 BYTE),
  M73_MURABAHA_BASKET_ID_M181 NUMBER (10, 0),
  M73_RISK_APPROVAL_LIMIT NUMBER (10, 5),
  M73_REMARKS VARCHAR2 (250 BYTE)
 )
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_SYMBOL_MARGBLTY_GRP_ID_M77 IS 'fk from m77'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_STOCK_CONCENT_GRP_ID_M75 IS 'fk from m75'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_MARGIN_INTEREST_GRP_ID_M74 IS 'fk from m74'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_DISPLAY_BUYING_POWER IS '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_AGENT_ID_U07 IS 'fk from u07'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_AGENT_FEE_TYPE IS '1 - Flat | 2 - Percentage'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_MINIMUM_TRADING_EXPERIENCE IS 'Experiance in Years'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_ONLINE_ALLOWED IS '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_CURRENCY_ID_M03 IS 'fk from m03'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_CURRENCY_CODE_M03 IS 'fk from m03'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_MURABAHA_BASKET_ID_M181 IS 'fk from m181'
/

ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
 ADD (
  M73_MARGIN_DISCLAIMER BLOB
 )
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_MARGIN_PRODUCT_EQ_ID_V36 IS 'V36_ID'
/

ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
 MODIFY (
  M73_MIN_AMOUNT NUMBER (18, 5),
  M73_MAX_AMOUNT NUMBER (18, 5),
  M73_RISK_APPROVAL_LIMIT NUMBER (18, 5),
  M73_AGENT_FEE NUMBER (18, 5)
 )
/

ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
RENAME COLUMN M73_AGENT_FEE_TYPE TO M73_PROFIT_TYPE
/
ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
RENAME COLUMN M73_AGENT_FEE TO M73_PROFIT
/

ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
 ADD (
  M73_DSCLMR_NAME VARCHAR2 (250 BYTE),
  M73_DSCLMR_LST_UPLOADBY_ID_U17 NUMBER (10, 0),
  M73_DSCLMR_LST_UPLOADED_DATE DATE
 )
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_DSCLMR_NAME IS 'Disclaimer file name'
/
COMMENT ON COLUMN dfn_ntp.M73_MARGIN_PRODUCTS.M73_DSCLMR_LST_UPLOADBY_ID_U17 IS 'fk from u17'
/

ALTER TABLE dfn_ntp.M73_MARGIN_PRODUCTS 
 MODIFY (
  M73_MARGIN_PRODUCT_EQ_ID_V36 NUMBER (10, 0),
  M73_ID NUMBER (10, 0)
 )
/

