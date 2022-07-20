CREATE TABLE dfn_ntp.t23_share_txn_requests
(
    t23_id                           NUMBER (10, 0),
    t23_batch_id                     NUMBER (10, 0) NOT NULL,
    t23_type                         NUMBER (1, 0) NOT NULL,
    t23_reference                    VARCHAR2 (100 BYTE),
    t23_exchange_id_m01              NUMBER (5, 0) NOT NULL,
    t23_status_id_v01                NUMBER (5, 0) NOT NULL,
    t23_processed_forcefully         NUMBER (1, 0) DEFAULT 0,
    t23_position_date                DATE NOT NULL,
    t23_changed_date                 DATE,
    t23_upload_date                  DATE NOT NULL,
    t23_processed_date               DATE NOT NULL,
    t23_processed_by_id_u17          NUMBER (5, 0) NOT NULL,
    t23_file_symbol                  VARCHAR2 (12 BYTE) NOT NULL,
    t23_symbol_id_m20                NUMBER (5, 0) NOT NULL,
    t23_last_trade_price             NUMBER (18, 4),
    t23_exchange_acc_no              VARCHAR2 (15 BYTE) NOT NULL,
    t23_trading_acc_id_u07           NUMBER (10, 0) NOT NULL,
    t23_custodian_id_m26             NUMBER (10, 0) NOT NULL,
    t23_investor_id                  VARCHAR2 (15 BYTE),
    t23_file_current_balance         NUMBER (18, 0) DEFAULT 0,
    t23_file_available_balance       NUMBER (18, 0) DEFAULT 0,
    t23_file_pledge_quantity         NUMBER (18, 0) DEFAULT 0,
    t23_current_balance_difference   NUMBER (18, 0) DEFAULT 0,
    t23_other_symbol_id_m20          NUMBER (5, 0),
    t23_status_changed_by_id_u17     NUMBER (5, 0),
    t23_status_changed_date          DATE,
    t23_no_of_approval               NUMBER (2, 0),
    t23_is_approval_completed        NUMBER (1, 0),
    t23_current_approval_level       NUMBER (5, 0),
    t23_next_status                  NUMBER (5, 0),
    t23_reject_reason                VARCHAR2 (4000 BYTE),
    t23_failed_reason                VARCHAR2 (4000 BYTE),
    t23_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    t23_primary_institute_id_m02     NUMBER (5, 0) DEFAULT 1
)
/


CREATE BITMAP INDEX dfn_ntp.idx_t23_status
    ON dfn_ntp.t23_share_txn_requests (t23_status_id_v01 ASC)
/

CREATE BITMAP INDEX dfn_ntp.idx_t23_position_date
    ON dfn_ntp.t23_share_txn_requests (t23_position_date ASC)
/


ALTER TABLE dfn_ntp.t23_share_txn_requests
ADD CONSTRAINT pk_t23_id PRIMARY KEY (t23_id)
USING INDEX
/



COMMENT ON COLUMN dfn_ntp.t23_share_txn_requests.t23_current_balance_difference IS
    'File Balance - OMS Balance'
/
COMMENT ON COLUMN dfn_ntp.t23_share_txn_requests.t23_processed_forcefully IS
    '0 - No | 1 - Yes. Specifies that corporate action has been processd forcefully when holding reconciliation file has run or is in progress'
/
COMMENT ON COLUMN dfn_ntp.t23_share_txn_requests.t23_type IS
    '1 - Corporate Actions | 2 - Weekly Reconciliation'
/
COMMENT ON COLUMN dfn_ntp.t23_share_txn_requests.t23_type IS
    '1 - Corporate Actions | 2 - Weekly Reconciliation | 3 - IPO Holding'
/

DROP INDEX dfn_ntp.idx_t23_status
/

DROP INDEX dfn_ntp.idx_t23_position_date
/

CREATE INDEX dfn_ntp.idx_t23_status
    ON dfn_ntp.t23_share_txn_requests (t23_status_id_v01 ASC)
/

CREATE INDEX dfn_ntp.idx_t23_position_date
    ON dfn_ntp.t23_share_txn_requests (t23_position_date ASC)
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.T23_SHARE_TXN_REQUESTS
 ADD (
  T23_IS_AUTO_FILE_PROCESSING NUMBER(1) DEFAULT 0
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T23_SHARE_TXN_REQUESTS')
           AND column_name = UPPER ('T23_IS_AUTO_FILE_PROCESSING');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.t23_share_txn_requests.t23_is_auto_file_processing IS
    '1 -Invoked by automated file processing'
/

ALTER TABLE dfn_ntp.t23_share_txn_requests MODIFY (t23_symbol_id_m20 NUMBER (10))
/

ALTER TABLE dfn_ntp.t23_share_txn_requests MODIFY (t23_other_symbol_id_m20 NUMBER (10))
/
