-- Table DFN_NTP.M72_EXEC_BROKER_CASH_ACCOUNT

CREATE TABLE dfn_ntp.m72_exec_broker_cash_account
(
    m72_id                         NUMBER (10, 0),
    m72_accountno                  VARCHAR2 (50),
    m72_exec_broker_id_m26         NUMBER (10, 0),
    m72_account_type               NUMBER (2, 0),
    m72_currency_code_m03          CHAR (3),
    m72_balance                    NUMBER (18, 5) DEFAULT 0,
    m72_blocked_amount             NUMBER (18, 5) DEFAULT 0,
    m72_od_limit                   NUMBER (18, 5) DEFAULT 0,
    m72_od_approved_by_id_u17      NUMBER (10, 0),
    m72_od_approved_date           DATE,
    m72_created_by_id_u17          NUMBER (10, 0),
    m72_created_date               DATE DEFAULT SYSDATE,
    m72_lastupdated_by_id_u17      NUMBER (10, 0),
    m72_lastupdated_date           DATE,
    m72_status_id_v01              NUMBER (20, 0),
    m72_status_changed_by_id_u17   NUMBER (10, 0),
    m72_status_changed_date        DATE,
    m72_pending_withdr             NUMBER (18, 5) DEFAULT 0,
    m72_pending_depost             NUMBER (18, 5) DEFAULT 0,
    m72_swift_acc                  VARCHAR2 (50),
    m72_agent_acc_no               VARCHAR2 (50),
    m72_currency_id_m03            NUMBER (15, 0)
)
/

-- Constraints for  DFN_NTP.M72_EXEC_BROKER_CASH_ACCOUNT


  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account ADD CONSTRAINT m72_pk PRIMARY KEY (m72_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_accountno NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_exec_broker_id_m26 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_account_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_balance NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_blocked_amount NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_od_limit NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_lastupdated_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_lastupdated_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_status_changed_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_pending_withdr NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m72_exec_broker_cash_account MODIFY (m72_pending_depost NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.M72_EXEC_BROKER_CASH_ACCOUNT


CREATE UNIQUE INDEX dfn_ntp.m72_accountn_uk
    ON dfn_ntp.m72_exec_broker_cash_account (m72_accountno)
/

-- Comments for  DFN_NTP.M72_EXEC_BROKER_CASH_ACCOUNT

COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_accountno IS
    'unique alpha numeric code'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_exec_broker_id_m26 IS
    'fk from m26'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_account_type IS
    '0=current, 1=saving,2=investment,3=segregated'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_currency_code_m03 IS
    'fk from m03'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_balance IS
    'cash balance'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_blocked_amount IS
    'blocked cash amount'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_od_limit IS
    'OD limit'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_od_approved_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_created_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_lastupdated_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_status_id_v01 IS
    'fk from v01'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_status_changed_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_pending_withdr IS
    'total pending withdrawals'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_pending_depost IS
    'total pending deposites'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_swift_acc IS
    'swift acc number'
/
COMMENT ON COLUMN dfn_ntp.m72_exec_broker_cash_account.m72_agent_acc_no IS
    'settling acc number'
/
COMMENT ON TABLE dfn_ntp.m72_exec_broker_cash_account IS
    'this table keeps the cash accounts attached to execution institutions ex01'
/
-- End of DDL Script for Table DFN_NTP.M72_EXEC_BROKER_CASH_ACCOUNT

alter table dfn_ntp.M72_EXEC_BROKER_CASH_ACCOUNT
	add M72_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m72_exec_broker_cash_account
 ADD (
  m72_is_default NUMBER (1)
 )
/

ALTER TABLE dfn_ntp.m72_exec_broker_cash_account
 MODIFY (
  m72_lastupdated_by_id_u17 NULL,
  m72_lastupdated_date NULL
 )
/

DECLARE
    l_count        NUMBER;
    l_index_name   VARCHAR2 (100) := 'M72_ACCOUNTN_UK';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_indexes
     WHERE UPPER (index_name) = UPPER (l_index_name);

    IF l_count > 0
    THEN
        EXECUTE IMMEDIATE 'DROP INDEX DFN_NTP.' || l_index_name;
    END IF;
END;
/

CREATE INDEX dfn_ntp.uk_m72_acc_no
    ON dfn_ntp.m72_exec_broker_cash_account (m72_accountno ASC)
/