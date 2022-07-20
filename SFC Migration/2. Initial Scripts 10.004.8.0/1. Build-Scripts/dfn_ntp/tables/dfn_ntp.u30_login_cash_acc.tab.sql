-- Table DFN_NTP.U30_LOGIN_CASH_ACC

CREATE TABLE dfn_ntp.u30_login_cash_acc
(
    u30_id                    NUMBER (10, 0),
    u30_login_id_u09          NUMBER (10, 0),
    u30_cash_acc_id_u06       NUMBER (10, 0),
    u30_created_by_id_u17     NUMBER (10, 0),
    u30_created_date          TIMESTAMP (6),
    u30_deposit               NUMBER (1, 0) DEFAULT 0,
    u30_withdraw              NUMBER (1, 0) DEFAULT 0,
    u30_transfer              NUMBER (1, 0) DEFAULT 0,
    u30_pending_restriction   NUMBER (1, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.U30_LOGIN_CASH_ACC


  ALTER TABLE dfn_ntp.u30_login_cash_acc ADD CONSTRAINT pk_u30_login_cash_acc PRIMARY KEY (u30_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.u30_login_cash_acc MODIFY (u30_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u30_login_cash_acc MODIFY (u30_login_id_u09 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u30_login_cash_acc MODIFY (u30_cash_acc_id_u06 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u30_login_cash_acc MODIFY (u30_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u30_login_cash_acc MODIFY (u30_created_date NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.U30_LOGIN_CASH_ACC


CREATE INDEX dfn_ntp.idx_u30_u09_login_id
    ON dfn_ntp.u30_login_cash_acc (u30_login_id_u09)
/

CREATE INDEX dfn_ntp.idx_u30_u06_cash_acc_id
    ON dfn_ntp.u30_login_cash_acc (u30_cash_acc_id_u06)
/

-- Comments for  DFN_NTP.U30_LOGIN_CASH_ACC

COMMENT ON COLUMN dfn_ntp.u30_login_cash_acc.u30_deposit IS
    '1- Enable, 0- Disable'
/
COMMENT ON COLUMN dfn_ntp.u30_login_cash_acc.u30_withdraw IS
    '1- Enable, 0- Disable'
/
COMMENT ON COLUMN dfn_ntp.u30_login_cash_acc.u30_transfer IS
    '1- Enable, 0- Disable'
/
COMMENT ON COLUMN dfn_ntp.u30_login_cash_acc.u30_pending_restriction IS
    '1- Available, 0- Not Available'
/
-- End of DDL Script for Table DFN_NTP.U30_LOGIN_CASH_ACC

alter table dfn_ntp.U30_LOGIN_CASH_ACC
	add U30_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.U30_LOGIN_CASH_ACC
 ADD (
  U30_STATUS_ID_V01 NUMBER (5) DEFAULT 1 NOT NULL
 )
/

ALTER TABLE dfn_ntp.U30_LOGIN_CASH_ACC
 ADD (
  u30_status_changed_by_id_u17 NUMBER (10)
 )
/

ALTER TABLE dfn_ntp.U30_LOGIN_CASH_ACC
 ADD (
  u30_status_changed_date DATE
 )
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.u30_login_cash_acc
    DROP CONSTRAINT fk_u30_u06_cash_acc_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_constraints
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u30_login_cash_acc')
           AND constraint_name = UPPER ('fk_u30_u06_cash_acc_id');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
