-- Table DFN_NTP.U21_LOGIN_TRADING_RESTRICTION

CREATE TABLE dfn_ntp.u21_login_trading_restriction
(
    u21_id                        NUMBER (5, 0),
    u21_restriction_type_id_v31   NUMBER (5, 0),
    u21_login_id_u10              NUMBER (10, 0),
    u21_narration                 VARCHAR2 (200),
    u21_narration_lang            VARCHAR2 (200)
)
/

-- Constraints for  DFN_NTP.U21_LOGIN_TRADING_RESTRICTION


  ALTER TABLE dfn_ntp.u21_login_trading_restriction MODIFY (u21_restriction_type_id_v31 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u21_login_trading_restriction MODIFY (u21_login_id_u10 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.U21_LOGIN_TRADING_RESTRICTION

alter table dfn_ntp.U21_LOGIN_TRADING_RESTRICTION
	add U21_CUSTOM_TYPE varchar2(50) default 1
/
