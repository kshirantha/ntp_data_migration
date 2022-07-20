CREATE TABLE dfn_ntp.t86_bulk_cash_holding_process
(
    t86_id                         NUMBER (20, 0),
    t86_created_date               DATE DEFAULT SYSDATE,
    t86_description                VARCHAR2 (500 BYTE),
    t86_txn_type                   NUMBER (2, 0),
    t86_status_id_v01              NUMBER (5, 0) DEFAULT 1,
    t86_status_changed_by_id_u17   NUMBER (10, 0) DEFAULT 0,
    t86_status_changed_date        DATE DEFAULT SYSDATE,
    t86_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    t86_primary_institute_id_m02   NUMBER (5, 0),
    t86_type                       NUMBER (3, 0),
    t86_user_id_u17                NUMBER (20, 0) NOT NULL,
    t86_position_date              VARCHAR2 (50 BYTE),
    t86_attempt_count              NUMBER (2, 0) DEFAULT 0
)
/

-- Constraints for DFN_NTP.T86_BULK_CASH_HOLDING_PROCESS

ALTER TABLE dfn_ntp.t86_bulk_cash_holding_process
    ADD CONSTRAINT t86_pk PRIMARY KEY (t86_id) USING INDEX
/

-- Comments for DFN_NTP.T86_BULK_CASH_HOLDING_PROCESS

COMMENT ON TABLE dfn_ntp.t86_bulk_cash_holding_process IS
    'Schedules to process bulk t86
   cash, holding or other transactions from specific tables for OMS'
/
COMMENT ON COLUMN dfn_ntp.t86_bulk_cash_holding_process.t86_attempt_count IS
    'Retry Attempt Count When Bulk Processing'
/
COMMENT ON COLUMN dfn_ntp.t86_bulk_cash_holding_process.t86_status_id_v01 IS
    '1- pending | 18 - processing | 17- processed'
/
COMMENT ON COLUMN dfn_ntp.t86_bulk_cash_holding_process.t86_txn_type IS
    '1 - Corporate Actions | 2 - Weekly Reconciliation | 3 - BFile Reconciliation | 4 - International Reconciliation | 5 - Bulk Cash Adjustment'
/

ALTER TABLE dfn_ntp.t86_bulk_cash_holding_process
 MODIFY (
  t86_type NUMBER (20, 0)

 )
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t86_bulk_cash_holding_process ADD (t86_batch_id_t80 NUMBER(20,0) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t86_bulk_cash_holding_process')
           AND column_name = UPPER ('t86_batch_id_t80');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

ALTER TABLE dfn_ntp.T86_BULK_CASH_HOLDING_PROCESS 
 ADD (
  T86_PROCESSED_SERVERS VARCHAR2 (20)
 )
/
COMMENT ON COLUMN dfn_ntp.T86_BULK_CASH_HOLDING_PROCESS.T86_PROCESSED_SERVERS IS 'String Value Showing Bulk Operation Processed Servers'
/


ALTER TABLE dfn_ntp.T86_BULK_CASH_HOLDING_PROCESS 
 ADD (
  T86_PICKED_SERVERS VARCHAR2 (20)
 )
/
COMMENT ON COLUMN dfn_ntp.T86_BULK_CASH_HOLDING_PROCESS.T86_PICKED_SERVERS IS 'String Value Showing Bulk Operation Picked Servers'
/
