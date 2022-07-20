-- Table DFN_NTP.M69_INSTITUTE_TRADING_LIMITS

CREATE TABLE dfn_ntp.m69_institute_trading_limits
(
    m69_id                       NUMBER (5, 0),
    m69_institution_id_m02       NUMBER (10, 0),
    m69_od_limit                 NUMBER (18, 4) DEFAULT 0,
    m69_avail_od_limit           NUMBER (18, 4) DEFAULT 0,
    m69_margin_limit             NUMBER (18, 4) DEFAULT 0,
    m69_avail_margin_limit       NUMBER (18, 4) DEFAULT 0,
    m69_last_updated_date        DATE,
    m69_last_updated_by_id_u17   NUMBER (10, 0),
    m69_mrg_call_notify_lvl      NUMBER (6, 3) DEFAULT 0,
    m69_mrg_call_remind_lvl      NUMBER (6, 3) DEFAULT 0,
    m69_mrg_call_liquid_lvl      NUMBER (6, 3) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.M69_INSTITUTE_TRADING_LIMITS


  ALTER TABLE dfn_ntp.m69_institute_trading_limits ADD CONSTRAINT m69_pk PRIMARY KEY (m69_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits MODIFY (m69_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits MODIFY (m69_institution_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits MODIFY (m69_od_limit NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits MODIFY (m69_avail_od_limit NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits MODIFY (m69_margin_limit NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits MODIFY (m69_avail_margin_limit NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits MODIFY (m69_mrg_call_notify_lvl NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits MODIFY (m69_mrg_call_remind_lvl NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits MODIFY (m69_mrg_call_liquid_lvl NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M69_INSTITUTE_TRADING_LIMITS

COMMENT ON COLUMN dfn_ntp.m69_institute_trading_limits.m69_institution_id_m02 IS
    'fk from m02'
/
COMMENT ON COLUMN dfn_ntp.m69_institute_trading_limits.m69_od_limit IS
    'allowed OD limit'
/
COMMENT ON COLUMN dfn_ntp.m69_institute_trading_limits.m69_avail_od_limit IS
    'available od limit'
/
COMMENT ON COLUMN dfn_ntp.m69_institute_trading_limits.m69_margin_limit IS
    'allowed margin limit'
/
COMMENT ON COLUMN dfn_ntp.m69_institute_trading_limits.m69_avail_margin_limit IS
    'available margin limit'
/
COMMENT ON COLUMN dfn_ntp.m69_institute_trading_limits.m69_last_updated_by_id_u17 IS
    'fk from u17'
/
COMMENT ON TABLE dfn_ntp.m69_institute_trading_limits IS
    'this table keeps the trading limits assigned to an institution'
/
-- End of DDL Script for Table DFN_NTP.M69_INSTITUTE_TRADING_LIMITS

alter table dfn_ntp.M69_INSTITUTE_TRADING_LIMITS
	add M69_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m69_institute_trading_limits
 ADD (
  m69_order_value_per_day NUMBER (21, 8),
  m69_order_volume_per_day NUMBER (21, 8),
  m69_default_currency_code_m03 VARCHAR2 (255),
  m69_default_currency_id_m03 NUMBER (5)
 )
/

ALTER TABLE dfn_ntp.m69_institute_trading_limits
    DROP (m69_mrg_call_notify_lvl,
          m69_mrg_call_remind_lvl,
          m69_mrg_call_liquid_lvl
         );

ALTER TABLE dfn_ntp.m69_institute_trading_limits
 ADD (
  m69_derivative_limit NUMBER (18, 4) DEFAULT 0,
  m69_derivative_limit_utilized NUMBER (18, 4) DEFAULT 0
 )
/