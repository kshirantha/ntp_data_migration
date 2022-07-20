CREATE TABLE dfn_ntp.m95_settlement_calendar_config
(
    m95_id                           NUMBER (10, 0) NOT NULL,
    m95_exchange_code_m01            VARCHAR2 (10 BYTE) NOT NULL,
    m95_exchange_id_m01              NUMBER (5, 0),
    m95_currency_code_m03            CHAR (3 BYTE),
    m95_currency_id_m03              NUMBER (10, 0),
    m95_sun_is_holiday               NUMBER (1, 0) DEFAULT 0,
    m95_sun_buy_t_plus_n             NUMBER (2, 0) DEFAULT 0,
    m95_sun_sell_t_plus_n            NUMBER (2, 0) DEFAULT 0,
    m95_mon_is_holiday               NUMBER (1, 0) DEFAULT 0,
    m95_mon_buy_t_plus_n             NUMBER (2, 0) DEFAULT 0,
    m95_mon_sell_t_plus_n            NUMBER (2, 0) DEFAULT 0,
    m95_tue_is_holiday               NUMBER (1, 0) DEFAULT 0,
    m95_tue_buy_t_plus_n             NUMBER (2, 0) DEFAULT 0,
    m95_tue_sell_t_plus_n            NUMBER (2, 0) DEFAULT 0,
    m95_wed_is_holiday               NUMBER (1, 0) DEFAULT 0,
    m95_wed_buy_t_plus_n             NUMBER (2, 0) DEFAULT 0,
    m95_wed_sell_t_plus_n            NUMBER (2, 0) DEFAULT 0,
    m95_thu_is_holiday               NUMBER (1, 0) DEFAULT 0,
    m95_thu_buy_t_plus_n             NUMBER (2, 0) DEFAULT 0,
    m95_thu_sell_t_plus_n            NUMBER (2, 0) DEFAULT 0,
    m95_fri_is_holiday               NUMBER (1, 0) DEFAULT 0,
    m95_fri_buy_t_plus_n             NUMBER (2, 0) DEFAULT 0,
    m95_fri_sell_t_plus_n            NUMBER (2, 0) DEFAULT 0,
    m95_sat_is_holiday               NUMBER (1, 0) DEFAULT 0,
    m95_sat_buy_t_plus_n             NUMBER (2, 0) DEFAULT 0,
    m95_sat_sell_t_plus_n            NUMBER (2, 0) DEFAULT 0,
    m95_created_by_id_u17            NUMBER (10, 0) NOT NULL,
    m95_created_date                 DATE DEFAULT SYSDATE NOT NULL,
    m95_modified_by_id_u17           NUMBER (10, 0),
    m95_modified_date                DATE,
    m95_instrument_type_code_v09     VARCHAR2 (4 BYTE),
    m95_institution_id_m02           NUMBER (4, 0),
    m95_symbol_settle_category_v11   NUMBER (1, 0) DEFAULT 0,
    m95_default_buy_tplus            NUMBER (2, 0) DEFAULT 0,
    m95_default_sell_tplus           NUMBER (2, 0) DEFAULT 0,
    m95_sun_buy_t_plus_h             NUMBER (2, 0) DEFAULT 0,
    m95_sun_sell_t_plus_h            NUMBER (2, 0) DEFAULT 0,
    m95_mon_buy_t_plus_h             NUMBER (2, 0) DEFAULT 0,
    m95_mon_sell_t_plus_h            NUMBER (2, 0) DEFAULT 0,
    m95_tue_buy_t_plus_h             NUMBER (2, 0) DEFAULT 0,
    m95_tue_sell_t_plus_h            NUMBER (2, 0) DEFAULT 0,
    m95_wed_buy_t_plus_h             NUMBER (2, 0) DEFAULT 0,
    m95_wed_sell_t_plus_h            NUMBER (2, 0) DEFAULT 0,
    m95_thu_buy_t_plus_h             NUMBER (2, 0) DEFAULT 0,
    m95_thu_sell_t_plus_h            NUMBER (2, 0) DEFAULT 0,
    m95_fri_buy_t_plus_h             NUMBER (2, 0) DEFAULT 0,
    m95_fri_sell_t_plus_h            NUMBER (2, 0) DEFAULT 0,
    m95_sat_buy_t_plus_h             NUMBER (2, 0) DEFAULT 0,
    m95_sat_sell_t_plus_h            NUMBER (2, 0) DEFAULT 0,
    m95_default_buy_tplus_h          NUMBER (2, 0) DEFAULT 0,
    m95_default_sell_tplus_h         NUMBER (2, 0) DEFAULT 0,
    m95_customer_settl_group_m35     NUMBER (10, 0) DEFAULT -1,
    m95_instrument_type_id_v09       NUMBER (10, 0),
    m95_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    m95_settlement_name              VARCHAR2 (250 BYTE),
    m95_settlement_year              NUMBER (5, 0) DEFAULT 0
)
/

ALTER TABLE dfn_ntp.m95_settlement_calendar_config
ADD CONSTRAINT m95_pk PRIMARY KEY (m95_id)
USING INDEX
/



COMMENT ON TABLE dfn_ntp.m95_settlement_calendar_config IS
    'this table keeps settlement calender details for exchange-currency combination'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_currency_code_m03 IS
    'fk from m03'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_customer_settl_group_m35 IS
    'fk m312_id'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_default_buy_tplus IS
    'default buy tplus value for cash'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_default_buy_tplus_h IS
    'default buy tplus value for holding'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_default_sell_tplus IS
    'default sell tplus value for cash'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_default_sell_tplus_h IS
    'default sell tplus value for holding'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_exchange_id_m01 IS
    'fk from m01'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_institution_id_m02 IS
    'fk from m02'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_instrument_type_code_v09 IS
    'fk from v09'
/
COMMENT ON COLUMN dfn_ntp.m95_settlement_calendar_config.m95_symbol_settle_category_v11 IS
    'fk m78'
/

ALTER TABLE dfn_ntp.m95_settlement_calendar_config
 ADD (
  m95_board_code_m54 VARCHAR2 (6)
 )
/

ALTER TABLE dfn_ntp.m95_settlement_calendar_config
 MODIFY (
  m95_board_code_m54 VARCHAR2 (10 BYTE)

 )
/

