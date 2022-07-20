-- Table DFN_NTP.T11_BLOCK_AMOUNT_DETAILS

CREATE TABLE dfn_ntp.t11_block_amount_details
(
    t11_trns_id              NUMBER (18, 0),
    t11_cash_trns_id_t06     NUMBER (18, 0),
    t11_trns_date            DATE,
    t11_value_date           DATE,
    t11_trans_code           VARCHAR2 (10),
    t11_trans_description    VARCHAR2 (100),
    t11_trans_amount         NUMBER (18, 5),
    t11_adjusted_amount      NUMBER (18, 5),
    t11_created_date         DATE,
    t11_created_by           NUMBER (18, 0),
    t11_status               NUMBER (1, 0) DEFAULT 0,
    t11_status_change_date   DATE,
    t11_status_change_by     NUMBER (18, 0),
    t11_id_u06               NUMBER (18, 0),
    t11_balance_u06          NUMBER (25, 5)
)
/

-- Constraints for  DFN_NTP.T11_BLOCK_AMOUNT_DETAILS


  ALTER TABLE dfn_ntp.t11_block_amount_details MODIFY (t11_trns_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t11_block_amount_details MODIFY (t11_id_u06 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t11_block_amount_details ADD CONSTRAINT t11_trns_id PRIMARY KEY (t11_trns_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.T11_BLOCK_AMOUNT_DETAILS

COMMENT ON COLUMN dfn_ntp.t11_block_amount_details.t11_trans_code IS
    'for manual Blocked code=MBLKD'
/
COMMENT ON COLUMN dfn_ntp.t11_block_amount_details.t11_status IS
    '0-init pending,1-Adjusted Approved, 5-Adjusted Reject,6-Transaction Completed'
/
COMMENT ON COLUMN dfn_ntp.t11_block_amount_details.t11_id_u06 IS
    'Cash account id'
/
COMMENT ON COLUMN dfn_ntp.t11_block_amount_details.t11_balance_u06 IS
    'AVAILABLE ACCOUNT BALANCE'
/
-- End of DDL Script for Table DFN_NTP.T11_BLOCK_AMOUNT_DETAILS

ALTER TABLE dfn_ntp.t11_block_amount_details
 MODIFY (
  t11_status NUMBER (3, 0)

 )
/

ALTER TABLE DFN_NTP.T11_BLOCK_AMOUNT_DETAILS 
 ADD (
  T11_INSTITUTE_ID_M02 NUMBER (3)
 )
/

ALTER TABLE dfn_ntp.t11_block_amount_details
    MODIFY (t11_institute_id_m02 DEFAULT 1)
/

ALTER TABLE dfn_ntp.t11_block_amount_details
 ADD (
  t11_is_archive_ready NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/
COMMENT ON COLUMN dfn_ntp.t11_block_amount_details.t11_is_archive_ready IS
    'flag to check before archive'
/
