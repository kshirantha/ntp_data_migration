-- Table DFN_NTP.U10_LOGIN_TRADING_ACC

CREATE TABLE dfn_ntp.u10_login_trading_acc
(
    u10_id                    NUMBER (10, 0),
    u10_login_id_u09          NUMBER (10, 0),
    u10_trading_acc_id_u07    NUMBER (10, 0),
    u10_created_by_id_u17     NUMBER (10, 0),
    u10_created_date          TIMESTAMP (6),
    u10_buy                   NUMBER (1, 0) DEFAULT 0,
    u10_sell                  NUMBER (1, 0) DEFAULT 0,
    u10_deposit               NUMBER (1, 0) DEFAULT 0,
    u10_withdraw              NUMBER (1, 0) DEFAULT 0,
    u10_transfer              NUMBER (1, 0) DEFAULT 0,
    u10_pending_restriction   NUMBER (1, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.U10_LOGIN_TRADING_ACC


  ALTER TABLE dfn_ntp.u10_login_trading_acc ADD CONSTRAINT pk_u10_login_trading_acc PRIMARY KEY (u10_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.u10_login_trading_acc MODIFY (u10_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u10_login_trading_acc MODIFY (u10_login_id_u09 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u10_login_trading_acc MODIFY (u10_trading_acc_id_u07 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u10_login_trading_acc MODIFY (u10_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u10_login_trading_acc MODIFY (u10_created_date NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.U10_LOGIN_TRADING_ACC


CREATE INDEX dfn_ntp.idx_u10_u09_login_id
    ON dfn_ntp.u10_login_trading_acc (u10_login_id_u09)
/

CREATE INDEX dfn_ntp.idx_u10_u07_trading_acc_id
    ON dfn_ntp.u10_login_trading_acc (u10_trading_acc_id_u07)
/

-- Comments for  DFN_NTP.U10_LOGIN_TRADING_ACC

COMMENT ON COLUMN dfn_ntp.u10_login_trading_acc.u10_buy IS
    '1- Enable, 0- Disable'
/
COMMENT ON COLUMN dfn_ntp.u10_login_trading_acc.u10_sell IS
    '1- Enable, 0- Disable'
/
COMMENT ON COLUMN dfn_ntp.u10_login_trading_acc.u10_deposit IS
    '1- Enable, 0- Disable'
/
COMMENT ON COLUMN dfn_ntp.u10_login_trading_acc.u10_withdraw IS
    '1- Enable, 0- Disable'
/
COMMENT ON COLUMN dfn_ntp.u10_login_trading_acc.u10_transfer IS
    '1- Enable, 0- Disable'
/
COMMENT ON COLUMN dfn_ntp.u10_login_trading_acc.u10_pending_restriction IS
    '1- Available, 0- Not Available'
/
-- End of DDL Script for Table DFN_NTP.U10_LOGIN_TRADING_ACC

alter table dfn_ntp.U10_LOGIN_TRADING_ACC
	add U10_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.U10_LOGIN_TRADING_ACC
 ADD (
  U10_STATUS_ID_V01 NUMBER (5) DEFAULT 1 NOT NULL
 )
/

ALTER TABLE dfn_ntp.U10_LOGIN_TRADING_ACC
 ADD (
  u10_status_changed_by_id_u17 NUMBER (10)
 )
/

ALTER TABLE dfn_ntp.U10_LOGIN_TRADING_ACC
 ADD (
  u10_status_changed_date DATE
 )
/