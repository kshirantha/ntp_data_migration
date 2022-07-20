-- Table DFN_NTP.H05_INSTITUTE_TRADING_LIMITS

CREATE TABLE dfn_ntp.h05_institute_trading_limits
(
    h05_id                   NUMBER (10, 0),
    h05_institution_id_m02   NUMBER (10, 0),
    h05_od_limit             NUMBER (18, 0),
    h05_margin_limit         NUMBER (18, 0),
    h05_updated_date         DATE,
    h05_updated_by_id_u17    NUMBER (10, 0)
)
/

-- Constraints for  DFN_NTP.H05_INSTITUTE_TRADING_LIMITS


  ALTER TABLE dfn_ntp.h05_institute_trading_limits ADD CONSTRAINT h05_inst_trading_limits_pk PRIMARY KEY (h05_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.h05_institute_trading_limits MODIFY (h05_id NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.H05_INSTITUTE_TRADING_LIMITS

alter table dfn_ntp.H05_INSTITUTE_TRADING_LIMITS
	add H05_CUSTOM_TYPE varchar2(50) default 1
/
