-- Table DFN_NTP.H02_CASH_ACCOUNT_SUMMARY

CREATE TABLE dfn_ntp.h02_cash_account_summary
(
    h02_cash_account_id_u06       NUMBER (10, 0),
    h02_date                      DATE,
    h02_customer_id_u01           NUMBER (10, 0),
    h02_currency_code_m03         CHAR (3),
    h02_balance                   NUMBER (25, 10) DEFAULT 0,
    h02_blocked                   NUMBER (25, 10) DEFAULT 0,
    h02_open_buy_blocked          NUMBER (25, 10) DEFAULT 0,
    h02_payable_blocked           NUMBER (25, 10) DEFAULT 0,
    h02_manual_trade_blocked      NUMBER (25, 10) DEFAULT 0,
    h02_manual_full_blocked       NUMBER (25, 10) DEFAULT 0,
    h02_manual_transfer_blocked   NUMBER (25, 10) DEFAULT 0,
    h02_receivable_amount         NUMBER (25, 10) DEFAULT 0,
    h02_currency_id_m03           NUMBER (5, 0),
    h02_margin_enabled            NUMBER (5, 0) DEFAULT 0,
    h02_pending_deposit           NUMBER (25, 10) DEFAULT 0,
    h02_pending_withdraw          NUMBER (25, 10) DEFAULT 0,
    h02_primary_od_limit          NUMBER (25, 10),
    h02_primary_start             DATE,
    h02_primary_expiry            DATE,
    h02_secondary_od_limit        NUMBER (25, 10),
    h02_secondary_start           DATE,
    h02_secondary_expiry          DATE,
    h02_investment_account_no     VARCHAR2 (75),
    h02_daily_withdraw_limit      NUMBER (18, 5) DEFAULT 0,
    h02_daily_cum_withdraw_amt    NUMBER (18, 5) DEFAULT 0,
    h02_margin_due                NUMBER (18, 5),
    h02_margin_block              NUMBER (18, 5),
    h02_margin_product_id_u23     NUMBER (5, 0),
    h02_net_receivable            NUMBER (25, 10) DEFAULT 0,
    h02_opening_balance           NUMBER (25, 10),
    h02_deposits                  NUMBER (25, 10),
    h02_withdrawals               NUMBER (25, 10),
    h02_net_buy                   NUMBER (25, 10),
    h02_net_sell                  NUMBER (25, 10),
    h02_net_charges_refunds       NUMBER (25, 10),
    h02_net_commission            NUMBER (25, 10),
    PRIMARY KEY (h02_cash_account_id_u06, h02_date) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.H02_CASH_ACCOUNT_SUMMARY


  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_cash_account_id_u06 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_customer_id_u01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_balance NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_blocked NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_open_buy_blocked NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_payable_blocked NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_manual_trade_blocked NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_manual_full_blocked NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_manual_transfer_blocked NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_receivable_amount NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h02_cash_account_summary MODIFY (h02_net_receivable NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.H02_CASH_ACCOUNT_SUMMARY


CREATE INDEX dfn_ntp.idx_h02_date
    ON dfn_ntp.h02_cash_account_summary (h02_date)
/

CREATE INDEX dfn_ntp.idx_h02_cash_account_id
    ON dfn_ntp.h02_cash_account_summary (h02_cash_account_id_u06)
/

-- Comments for  DFN_NTP.H02_CASH_ACCOUNT_SUMMARY

COMMENT ON COLUMN dfn_ntp.h02_cash_account_summary.h02_cash_account_id_u06 IS
    ''
/
COMMENT ON COLUMN dfn_ntp.h02_cash_account_summary.h02_manual_trade_blocked IS
    'Manual block for buy/sell'
/
COMMENT ON COLUMN dfn_ntp.h02_cash_account_summary.h02_manual_full_blocked IS
    'Manual block for withdrawal'
/
COMMENT ON COLUMN dfn_ntp.h02_cash_account_summary.h02_currency_id_m03 IS ''
/
COMMENT ON COLUMN dfn_ntp.h02_cash_account_summary.h02_margin_enabled IS
    '0 - No, 1 - Yes, 2 - Expired'
/
-- End of DDL Script for Table DFN_NTP.H02_CASH_ACCOUNT_SUMMARY

ALTER TABLE dfn_ntp.h02_cash_account_summary
 ADD (
  h02_accrued_interest NUMBER (18, 5) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.h02_cash_account_summary
 ADD (
  h02_trade_processing_id_t17 VARCHAR2 (22),
  h02_is_history_adjusted NUMBER (1)
 )
/
COMMENT ON COLUMN dfn_ntp.h02_cash_account_summary.h02_is_history_adjusted IS
    'Adjusted by Trade Processing'
/

ALTER TABLE dfn_ntp.h02_cash_account_summary 
 ADD (
  h02_primary_institute_id_m02 NUMBER (5)
 )
/

ALTER TABLE dfn_ntp.h02_cash_account_summary
 ADD (
  h02_is_archive_ready NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/
COMMENT ON COLUMN dfn_ntp.h02_cash_account_summary.h02_is_archive_ready IS
    'flag to check before archive'
/

ALTER TABLE dfn_ntp.h02_cash_account_summary
 ADD (
  h02_margin_utilized NUMBER (25, 10)
 )
/

ALTER TABLE dfn_ntp.h02_cash_account_summary
 MODIFY (
  h02_margin_utilized DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.h02_cash_account_summary
 ADD (
  h02_gainloss NUMBER (18, 5)
 )
/

ALTER TABLE dfn_ntp.h02_cash_account_summary
 MODIFY (
  h02_gainloss DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.h02_cash_account_summary
 ADD (
  h02_loan_amount NUMBER (25, 10)
 )
/

UPDATE dfn_ntp.h02_cash_account_summary
   SET h02_loan_amount = 0;

ALTER TABLE dfn_ntp.h02_cash_account_summary
 MODIFY (
  h02_loan_amount DEFAULT 0
 )
/
