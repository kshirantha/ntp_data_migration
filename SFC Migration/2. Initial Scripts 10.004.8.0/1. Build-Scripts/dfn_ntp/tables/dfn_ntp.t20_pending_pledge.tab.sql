-- Table DFN_NTP.T20_PENDING_PLEDGE

CREATE TABLE dfn_ntp.t20_pending_pledge
(
    t20_id                        NUMBER (18, 0),
    t20_trading_acc_id_u07        NUMBER (10, 0),
    t20_exchange                  VARCHAR2 (10),
    t20_symbol                    VARCHAR2 (25),
    t20_qty                       NUMBER (10, 0),
    t20_instrument_type           VARCHAR2 (5),
    t20_last_changed_by_id_u17    NUMBER (10, 0),
    t20_last_changed_date         DATE,
    t20_status_id_v01             NUMBER (3, 0) DEFAULT 0,
    t20_send_to_exchange          NUMBER (1, 0) DEFAULT 0,
    t20_send_to_exchange_result   NUMBER (2, 0) DEFAULT -1,
    t20_pledge_type               CHAR (1),
    t20_transaction_number        NUMBER (18, 0),
    t20_pledgee                   VARCHAR2 (25),
    t20_pledgor                   VARCHAR2 (25),
    t20_pledgor_ac_no             VARCHAR2 (30),
    t20_nin                       VARCHAR2 (25),
    t20_pledge_call_member        VARCHAR2 (25),
    t20_pledge_call_ac_no         VARCHAR2 (30),
    t20_pledge_value              NUMBER (18, 5),
    t20_narration                 VARCHAR2 (2000),
    t20_exchange_fee              NUMBER (18, 5),
    t20_broker_fee                NUMBER (18, 5),
    t20_reject_reason             VARCHAR2 (100),
    t20_remaining_qty             NUMBER (10, 0),
    t20_custodian_id              NUMBER (10, 0) DEFAULT -1,
    t20_include_gl                NUMBER (1, 0) DEFAULT 1,
    t20_current_approval_level    NUMBER (1, 0),
    t20_no_of_approval            NUMBER (1, 0),
    t20_institution_id            NUMBER (1, 0),
    t20_entered_date              DATE,
    t20_entered_by_id_u17         NUMBER (10, 0),
    t20_reference_id_t06          VARCHAR2 (255),
    t20_exg_vat                   NUMBER (18, 5),
    t20_brk_vat                   NUMBER (18, 5),
    t20_pledge_txn_type           NUMBER (1, 0)
)
/

-- Constraints for  DFN_NTP.T20_PENDING_PLEDGE


  ALTER TABLE dfn_ntp.t20_pending_pledge MODIFY (t20_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t20_pending_pledge MODIFY (t20_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t20_pending_pledge MODIFY (t20_send_to_exchange NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t20_pending_pledge ADD CONSTRAINT t20_pk PRIMARY KEY (t20_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.T20_PENDING_PLEDGE

COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_status_id_v01 IS ''
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_send_to_exchange IS
    'whether the pledge sent to exchange, 1=yes,0=no'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_send_to_exchange_result IS
    '0=success'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_pledge_type IS
    '8- in , 9- out'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_transaction_number IS
    'source transaction number'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_pledgee IS 'TDWL specific'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_pledgor IS 'TDWL specific'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_pledgor_ac_no IS
    'TDWL specific'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_nin IS 'TDWL specific'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_pledge_call_member IS
    'TDWL specific'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_pledge_call_ac_no IS
    'TDWL specific'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_pledge_value IS
    'total value of the pledge qty'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_narration IS
    'SHC migration field'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_reject_reason IS
    'Reject Message comes from U 21'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_custodian_id IS 'ex01 fk'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_include_gl IS
    'GS-include to GL or not'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_reference_id_t06 IS 'Fee Id'
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_pledge_txn_type IS
    '0-single,1-bulk'
/
COMMENT ON TABLE dfn_ntp.t20_pending_pledge IS
    'this table keeps all the pledge requests.'
/
-- End of DDL Script for Table DFN_NTP.T20_PENDING_PLEDGE

ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE 
 ADD (
  T20_REF_NO VARCHAR2 (25 BYTE)
 )
/
COMMENT ON COLUMN dfn_ntp.T20_PENDING_PLEDGE.T20_REF_NO IS 'Reference Id for the bulk upload'
/

ALTER TABLE dfn_ntp.t20_pending_pledge
 ADD (
  t20_final_approval NUMBER (1)
 )
/
COMMENT ON COLUMN dfn_ntp.t20_pending_pledge.t20_final_approval IS
    '1=Yes, 0=No'
/

ALTER TABLE DFN_NTP.T20_PENDING_PLEDGE 
 ADD (
  T20_ORG_TXN_ID NUMBER (18, 0)
 )
/
COMMENT ON COLUMN DFN_NTP.T20_PENDING_PLEDGE.T20_ORG_TXN_ID IS 'Related Original transaction id'
/

ALTER TABLE DFN_NTP.T20_PENDING_PLEDGE 
 ADD (
  T20_CUSTOMER_ID_U01 VARCHAR2 (25 BYTE)
 )
/

ALTER TABLE dfn_ntp.t20_pending_pledge
 ADD (
  t20_symbol_id_m20 NUMBER (10)
 )
/

ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE
 ADD (
  T20_EXG_DISCOUNT NUMBER (18, 5),
  T20_BRK_DISCOUNT NUMBER (18, 5)
 )
/

ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE 
 MODIFY (
  T20_INSTITUTION_ID NUMBER (3, 0)

 )
/

ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE
 MODIFY (
  T20_QTY NUMBER (18, 0),
  T20_REMAINING_QTY NUMBER (18, 0)
 )
/

CREATE INDEX dfn_ntp.idx_t20_trading_acc_id_u07
    ON dfn_ntp.t20_pending_pledge (t20_trading_acc_id_u07 ASC)
/

ALTER TABLE dfn_ntp.t20_pending_pledge
 MODIFY (
  t20_qty NUMBER (25, 0)

 )
/

DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t20_pending_pledge ADD (t20_transaction_number_temp VARCHAR2 (100))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.t20_pending_pledge SET t20_transaction_number_temp = t20_transaction_number';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t20_pending_pledge MODIFY ( t20_transaction_number VARCHAR2 (100))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.t20_pending_pledge SET t20_transaction_number = t20_transaction_number_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t20_pending_pledge DROP COLUMN t20_transaction_number_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t20_pending_pledge')
           AND column_name = UPPER ('t20_transaction_number');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.t20_pending_pledge
           SET t20_transaction_number = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/

ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE 
 ADD (
  T20_CHANNEL_ID_V29 NUMBER (3),
  T20_FUNCTION_ID_M88 NUMBER (3)
 )
/

ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE 
 ADD (
  T20_CODE_M97 VARCHAR2 (10)
 )
/

ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE 
 ADD (
  T20_BFILE_REF VARCHAR2 (10 BYTE)
 )
/
COMMENT ON COLUMN dfn_ntp.T20_PENDING_PLEDGE.T20_BFILE_REF IS 'Reference ID for B-file pledge In / Out Purpose'
/
ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE 
 ADD (
  T20_NARRATION_LANG VARCHAR2 (2000)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE  ADD (  T20_IP VARCHAR2 (50 BYTE) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T20_PENDING_PLEDGE')
           AND column_name = UPPER ('T20_IP');
    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

ALTER TABLE dfn_ntp.T20_PENDING_PLEDGE 
 MODIFY (
  T20_FUNCTION_ID_M88 NUMBER (5, 0)
 )
/