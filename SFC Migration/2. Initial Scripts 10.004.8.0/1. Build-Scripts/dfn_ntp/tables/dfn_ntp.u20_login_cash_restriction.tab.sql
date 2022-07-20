-- Table DFN_NTP.U20_LOGIN_CASH_RESTRICTION

CREATE TABLE dfn_ntp.u20_login_cash_restriction
(
    u20_id                        NUMBER (5, 0),
    u20_restriction_type_id_v31   NUMBER (5, 0),
    u20_login_id_u30              NUMBER (10, 0),
    u20_narration                 VARCHAR2 (200),
    u20_narration_lang            VARCHAR2 (200)
)
/

-- Constraints for  DFN_NTP.U20_LOGIN_CASH_RESTRICTION


  ALTER TABLE dfn_ntp.u20_login_cash_restriction MODIFY (u20_restriction_type_id_v31 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u20_login_cash_restriction MODIFY (u20_login_id_u30 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.U20_LOGIN_CASH_RESTRICTION

alter table dfn_ntp.U20_LOGIN_CASH_RESTRICTION
	add U20_CUSTOM_TYPE varchar2(50) default 1
/
