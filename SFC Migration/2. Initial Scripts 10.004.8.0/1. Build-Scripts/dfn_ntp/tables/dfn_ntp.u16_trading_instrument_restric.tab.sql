-- Table DFN_NTP.U16_TRADING_INSTRUMENT_RESTRIC

CREATE TABLE dfn_ntp.u16_trading_instrument_restric
(
    u16_id                   NUMBER (10, 0),
    u16_trd_acnt_id_u07      NUMBER (10, 0),
    u16_restriction_id_v31   NUMBER (10, 0),
    u16_instrument_id_v09    NUMBER (10, 0)
)
/

-- Constraints for  DFN_NTP.U16_TRADING_INSTRUMENT_RESTRIC


  ALTER TABLE dfn_ntp.u16_trading_instrument_restric MODIFY (u16_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u16_trading_instrument_restric MODIFY (u16_trd_acnt_id_u07 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u16_trading_instrument_restric MODIFY (u16_restriction_id_v31 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u16_trading_instrument_restric MODIFY (u16_instrument_id_v09 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.U16_TRADING_INSTRUMENT_RESTRIC

alter table dfn_ntp.U16_TRADING_INSTRUMENT_RESTRIC
	add U16_CUSTOM_TYPE varchar2(50) default 1
/
