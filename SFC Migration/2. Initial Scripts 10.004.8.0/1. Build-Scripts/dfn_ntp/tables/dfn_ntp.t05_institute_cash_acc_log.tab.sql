-- Table DFN_NTP.T05_INSTITUTE_CASH_ACC_LOG

CREATE TABLE dfn_ntp.t05_institute_cash_acc_log
(
    t05_id                         NUMBER (18, 0),
    t05_institute_id_m02           NUMBER (5, 0) DEFAULT 0,
    t05_exchange_id_m01            NUMBER (18, 0),
    t05_exchange_code_m01          VARCHAR2 (10),
    t05_institute_bank_id_m93      NUMBER (18, 0),
    t05_txn_id_m97                 NUMBER (5, 0),
    t05_txn_code_m97               VARCHAR2 (10),
    t05_amnt_in_stl_currency       NUMBER (18, 5) DEFAULT 0,
    t02_amnt_in_txn_currency       NUMBER (18, 5) DEFAULT 0,
    t05_txn_date                   DATE,
    t05_txn_date_time              DATE,
    t05_settle_date                DATE,
    t05_txn_currency_id_m03        NUMBER (5, 0),
    t05_txn_currency_code_m03      CHAR (3),
    t05_settle_currency_id_m03     NUMBER (5, 0),
    t05_settle_currency_code_m03   CHAR (3),
    t05_fx_rate                    NUMBER (18, 5) DEFAULT 1
)
/

-- Constraints for  DFN_NTP.T05_INSTITUTE_CASH_ACC_LOG


  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log ADD CONSTRAINT pk_t05 PRIMARY KEY (t05_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log MODIFY (t05_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log MODIFY (t05_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log MODIFY (t05_exchange_id_m01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log MODIFY (t05_exchange_code_m01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log MODIFY (t05_institute_bank_id_m93 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log MODIFY (t05_txn_id_m97 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log MODIFY (t05_txn_code_m97 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log MODIFY (t05_txn_currency_id_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t05_institute_cash_acc_log MODIFY (t05_settle_currency_id_m03 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.T05_INSTITUTE_CASH_ACC_LOG

ALTER TABLE dfn_ntp.t05_institute_cash_acc_log
 MODIFY (
  t05_exchange_id_m01 NULL,
  t05_exchange_code_m01 NULL

 )
/

ALTER TABLE dfn_ntp.t05_institute_cash_acc_log
 ADD (
  t05_reference NUMBER (18)
 )
/

ALTER TABLE dfn_ntp.t05_institute_cash_acc_log
 ADD (
  t05_cust_bank_account_id_u08 NUMBER (18),
  t05_cust_cash_acc_id_u06 NUMBER (18),
  t05_t02_id NUMBER (18),
  t05_reference_doc_narration VARCHAR2 (500)
 )
/

ALTER TABLE dfn_ntp.t05_institute_cash_acc_log
    RENAME COLUMN t02_amnt_in_txn_currency TO t05_amnt_in_txn_currency
/