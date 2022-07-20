DECLARE
    l_count   NUMBER (10) DEFAULT 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables a
     WHERE     a.owner = 'DFN_NTP'
           AND a.table_name = 'A13_CASH_HOLDING_ADJUST_LOG';

    IF l_count > 0
    THEN
        EXECUTE IMMEDIATE 'drop table DFN_NTP.A13_CASH_HOLDING_ADJUST_LOG';
    END IF;
END;
/

CREATE TABLE dfn_ntp.a13_cash_holding_adjust_log
(
    a13_id                        NUMBER (18, 0) NOT NULL,
    a13_adjust_status             NUMBER (1, 0) DEFAULT 0 NOT NULL,
    a13_type                      NUMBER (1, 0) NOT NULL,
    a13_created_date              DATE DEFAULT SYSDATE NOT NULL,
    a13_cash_account_id_u06       NUMBER (18, 0),
    a13_u06_balance               NUMBER (18, 5) DEFAULT 0,
    a13_u06_payable_blocked       NUMBER (18, 5) DEFAULT 0,
    a13_u06_receivable_amount     NUMBER (18, 5) DEFAULT 0,
    a13_u06_net_receivable        NUMBER (18, 5) DEFAULT 0,
    a13_u24_trading_acnt_id_u07   NUMBER (18, 0),
    a13_u24_custodian_id_m26      NUMBER (10, 0),
    a13_u24_symbol_id_m20         NUMBER (10, 0),
    a13_u24_receivable_holding    NUMBER (18, 0) DEFAULT 0,
    a13_u24_payable_holding       NUMBER (18, 0) DEFAULT 0,
    a13_u24_net_receivable        NUMBER (18, 0) DEFAULT 0
)
/

ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
    ADD CONSTRAINT a13_pk PRIMARY KEY (a13_id) USING INDEX
/


-- Comments for DFN_NTP.A13_CASH_HOLDING_ADJUST_LOG

COMMENT ON COLUMN dfn_ntp.a13_cash_holding_adjust_log.a13_adjust_status IS
    '1 - adjusted, 0 - pending, 2 - rejected'
/
COMMENT ON COLUMN dfn_ntp.a13_cash_holding_adjust_log.a13_type IS 'fk V07_ID'
/

ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
 ADD (
  a13_u24_symbol_code_m20 VARCHAR2 (10),
   a13_u24_exchange_code_m01 VARCHAR2 (10)
 )
/

ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
    MODIFY (a13_type NUMBER (4, 0))
/

ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
 ADD (
  a13_code_m97 VARCHAR2 (10)
 )
/
ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
 ADD (
  a13_created_date_time DATE DEFAULT SYSDATE
 )
/
COMMENT ON COLUMN dfn_ntp.a13_cash_holding_adjust_log.a13_created_date_time IS
    'auto generated'
/

ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
 MODIFY (
  a13_u06_balance NUMBER (25, 10)

 )
/

ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
RENAME COLUMN a13_type TO a13_job_id_v07
/
ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
 ADD (
  a13_impact_type NUMBER (1),
  a13_t02_required NUMBER (1, 0),
  a13_u24_net_holding NUMBER (18, 0),
  a13_narration VARCHAR2 (1000)
 )
/
COMMENT ON COLUMN dfn_ntp.a13_cash_holding_adjust_log.a13_adjust_status IS
    '0 - Pending | 1 - Adjusted | 2 - Rejected'
/
COMMENT ON COLUMN dfn_ntp.a13_cash_holding_adjust_log.a13_job_id_v07 IS ''
/
COMMENT ON COLUMN dfn_ntp.a13_cash_holding_adjust_log.a13_impact_type IS
    '1 - Order | 2 - Cash | 3 - Holdings'
/
COMMENT ON COLUMN dfn_ntp.a13_cash_holding_adjust_log.a13_t02_required IS
    '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
    MODIFY (a13_u24_symbol_code_m20 VARCHAR2 (25 BYTE))
/

ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
 ADD (
  a13_fixing_price NUMBER (18, 5),
  a13_initial_margin_value NUMBER (18, 5),
  a13_notional_value NUMBER (18, 5)
 )
/

COMMENT ON COLUMN dfn_ntp.A13_CASH_HOLDING_ADJUST_LOG.A13_IMPACT_TYPE IS '1 - Order | 2 - Cash | 3 - Holdings | 4 - Derivative M2M | 5 - Derivative Symbol Expiry'
/

ALTER TABLE dfn_ntp.A13_CASH_HOLDING_ADJUST_LOG 
 ADD (
  a13_u06_loan_amount NUMBER (18, 5) DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_ntp.a13_cash_holding_adjust_log.a13_impact_type IS
    '1 - Order | 2 - Cash | 3 - Holdings | 4 - Derivative M2M | 5 - Derivative Symbol Expiry | 6 - Cash and Holdings'
/

ALTER TABLE dfn_ntp.A13_CASH_HOLDING_ADJUST_LOG 
 ADD (
  A13_FAILED_ATTEMPTS NUMBER (1, 0) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.A13_CASH_HOLDING_ADJUST_LOG 
 ADD (
  A13_FAILED_REASON VARCHAR2 (1000 BYTE)
 )
/

ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
 ADD (
  a13_narration_lang VARCHAR2 (1000)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := ' ALTER TABLE dfn_ntp.a13_cash_holding_adjust_log
 ADD (
  a13_broker_tax NUMBER (18, 5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('a13_cash_holding_adjust_log')
           AND column_name = UPPER ('a13_broker_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
