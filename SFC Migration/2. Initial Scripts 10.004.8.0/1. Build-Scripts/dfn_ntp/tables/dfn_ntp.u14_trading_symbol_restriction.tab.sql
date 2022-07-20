-- Table DFN_NTP.U14_TRADING_SYMBOL_RESTRICTION

CREATE TABLE dfn_ntp.u14_trading_symbol_restriction
(
    u14_id                   NUMBER (10, 0),
    u14_trd_acnt_id_u07      NUMBER (10, 0),
    u14_symbol_id_m20        NUMBER (10, 0),
    u14_restriction_id_v31   NUMBER (10, 0)
)
/

-- Constraints for  DFN_NTP.U14_TRADING_SYMBOL_RESTRICTION


  ALTER TABLE dfn_ntp.u14_trading_symbol_restriction MODIFY (u14_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u14_trading_symbol_restriction MODIFY (u14_trd_acnt_id_u07 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u14_trading_symbol_restriction MODIFY (u14_symbol_id_m20 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u14_trading_symbol_restriction MODIFY (u14_restriction_id_v31 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u14_trading_symbol_restriction ADD CONSTRAINT u14_trading_symbol_restric_pk PRIMARY KEY (u14_id)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.U14_TRADING_SYMBOL_RESTRICTION

alter table dfn_ntp.U14_TRADING_SYMBOL_RESTRICTION
	add U14_CUSTOM_TYPE varchar2(50) default 1
/

CREATE INDEX dfn_ntp.idx_u14_trd_acnt_id_u07
    ON dfn_ntp.u14_trading_symbol_restriction (u14_trd_acnt_id_u07)
/
