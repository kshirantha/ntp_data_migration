-- Table DFN_NTP.M125_EXCHANGE_INSTRUMENT_TYPE

CREATE TABLE dfn_ntp.m125_exchange_instrument_type
(
    m125_id                         NUMBER (10, 0),
    m125_exchange_code_m01          VARCHAR2 (10),
    m125_exchange_id_m01            NUMBER (10, 0),
    m125_institute_id_m02           NUMBER (10, 0),
    m125_instrument_type_id_v09     VARCHAR2 (4),
    m125_min_broker_commission      NUMBER (18, 5),
    m125_is_online                  NUMBER (1, 0) DEFAULT 0,
    m125_created_by_id_u17          NUMBER (10, 0),
    m125_created_date               DATE DEFAULT SYSDATE,
    m125_modified_by_id_u17         NUMBER (10, 0),
    m125_modified_date              DATE DEFAULT SYSDATE,
    m125_is_subscription_allowed    NUMBER (1, 0) DEFAULT 0,
    m125_allow_sell_unsettle_hold   NUMBER (1, 0) DEFAULT 0,
    m125_subscription_start_time    VARCHAR2 (4),
    m125_subscription_end_time      VARCHAR2 (4),
    m125_instrument_type_code_v09   VARCHAR2 (10)
)
/

-- Constraints for  DFN_NTP.M125_EXCHANGE_INSTRUMENT_TYPE


  ALTER TABLE dfn_ntp.m125_exchange_instrument_type ADD CONSTRAINT m125_pk PRIMARY KEY (m125_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m125_exchange_instrument_type MODIFY (m125_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m125_exchange_instrument_type MODIFY (m125_exchange_code_m01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m125_exchange_instrument_type MODIFY (m125_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m125_exchange_instrument_type MODIFY (m125_instrument_type_id_v09 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M125_EXCHANGE_INSTRUMENT_TYPE

COMMENT ON COLUMN dfn_ntp.m125_exchange_instrument_type.m125_subscription_start_time IS
    'HH24MM'
/
COMMENT ON COLUMN dfn_ntp.m125_exchange_instrument_type.m125_subscription_end_time IS
    'HH24MM'
/
-- End of DDL Script for Table DFN_NTP.M125_EXCHANGE_INSTRUMENT_TYPE

alter table dfn_ntp.M125_EXCHANGE_INSTRUMENT_TYPE
	add M125_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m125_exchange_instrument_type
    DROP COLUMN m125_institute_id_m02
/

CREATE INDEX dfn_ntp.idx_m20_instrum_type_code_v09
    ON dfn_ntp.m125_exchange_instrument_type (m125_instrument_type_id_v09)
/

ALTER TABLE dfn_ntp.m125_exchange_instrument_type
 ADD (
  m125_board_code_m54 VARCHAR2 (6)
 )
/

ALTER TABLE dfn_ntp.m125_exchange_instrument_type
 ADD (
  m125_board_id_m54 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.m125_exchange_instrument_type
 MODIFY (
  m125_board_code_m54 VARCHAR2 (10 BYTE)

 )
/

