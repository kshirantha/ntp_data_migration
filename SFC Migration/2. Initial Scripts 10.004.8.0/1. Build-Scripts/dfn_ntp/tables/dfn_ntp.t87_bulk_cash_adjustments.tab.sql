CREATE TABLE dfn_ntp.t87_bulk_cash_adjustments
(
    t87_id                         NUMBER (20, 0),
    t87_institute_id_m02           NUMBER (3, 0) DEFAULT 1,
    t87_cash_account_id_u06        NUMBER (10, 0),
    t87_txn_code                   VARCHAR2 (10 BYTE),
    t87_txn_currency               VARCHAR2 (50 BYTE),
    t87_amnt_in_txn_currency       NUMBER (18, 5),
    t87_settle_currency            VARCHAR2 (50 BYTE),
    t87_fx_rate                    NUMBER (18, 5),
    t87_amnt_in_stl_currency       NUMBER (18, 5),
    t87_status_id_v01              NUMBER (5, 0) DEFAULT 1,
    t87_status_changed_by_id_u17   NUMBER (10, 0) DEFAULT 0,
    t87_status_changed_date        DATE DEFAULT SYSDATE,
    t87_description                VARCHAR2 (500 BYTE),
    t87_created_by_id_u17          NUMBER (5, 0) DEFAULT 0,
    t87_created_date               DATE DEFAULT SYSDATE,
    t87_batch_id_t86               NUMBER (5, 0),
    t87_type                       NUMBER (2, 0),
    t87_bank_id_m93                NUMBER (18, 0),
    t87_online_trans_type_id_v01   NUMBER (5, 0),
    t87_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    t87_customer_id_u01            NUMBER (10, 0)
)
/

-- Constraints for DFN_NTP.T87_BULK_CASH_ADJUSTMENTS

ALTER TABLE dfn_ntp.t87_bulk_cash_adjustments
    ADD CONSTRAINT t87_pk PRIMARY KEY (t87_id) USING INDEX
/

-- Comments for DFN_NTP.T87_BULK_CASH_ADJUSTMENTS

COMMENT ON TABLE dfn_ntp.t87_bulk_cash_adjustments IS
    'Bulk cash or other adjustments'
/
COMMENT ON COLUMN dfn_ntp.t87_bulk_cash_adjustments.t87_bank_id_m93 IS
    'Omnibus account id m93'
/
COMMENT ON COLUMN dfn_ntp.t87_bulk_cash_adjustments.t87_id IS 't86_id'
/
COMMENT ON COLUMN dfn_ntp.t87_bulk_cash_adjustments.t87_online_trans_type_id_v01 IS
    'm93 online transfer type'
/
COMMENT ON COLUMN dfn_ntp.t87_bulk_cash_adjustments.t87_type IS
    '1 - Falcom Cash Deposit file upload'
/

-- End of DDL Script for Table DFN_NTP.T87_BULK_CASH_ADJUSTMENTS