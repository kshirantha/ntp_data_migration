-- Table DFN_NTP.T28_GL_RECORD_WISE_ENTRIES

CREATE TABLE dfn_ntp.t28_gl_record_wise_entries
(
    t28_id                     NUMBER (20, 0),
    t28_batch_id_t27           NUMBER (10, 0),
    t28_cash_account_id_u06    NUMBER (10, 0),
    t28_distribution_id_m138   NUMBER (15, 0),
    t28_txn_ref                VARCHAR2 (15),
    t28_txn_date               DATE,
    t28_settle_date            DATE,
    t28_narration              VARCHAR2 (500),
    t28_narration_lang         VARCHAR2 (500),
    t28_acc_cat_id_m134        NUMBER (10, 0),
    t28_currency_code_m03      CHAR (3),
    t28_currency_id_m03        NUMBER (5, 0),
    t28_dr                     NUMBER (18, 5),
    t28_cr                     NUMBER (18, 5)
)
/

-- Constraints for  DFN_NTP.T28_GL_RECORD_WISE_ENTRIES


  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries ADD CONSTRAINT pk_t28 PRIMARY KEY (t28_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries MODIFY (t28_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries MODIFY (t28_batch_id_t27 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries MODIFY (t28_cash_account_id_u06 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries MODIFY (t28_distribution_id_m138 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries MODIFY (t28_txn_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries MODIFY (t28_settle_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries MODIFY (t28_acc_cat_id_m134 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries MODIFY (t28_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t28_gl_record_wise_entries MODIFY (t28_currency_id_m03 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.T28_GL_RECORD_WISE_ENTRIES

ALTER TABLE dfn_ntp.t28_gl_record_wise_entries
 MODIFY (
  t28_cash_account_id_u06 NULL
 )
/

CREATE INDEX dfn_ntp.idx_t28_batch_id_t27
    ON dfn_ntp.t28_gl_record_wise_entries (t28_batch_id_t27)
/

ALTER TABLE dfn_ntp.t28_gl_record_wise_entries
 ADD (
  t28_acc_ref VARCHAR2 (50),
  t28_source_ref VARCHAR2 (50),
  t28_distribution_ref VARCHAR2 (50)
 )
 MODIFY (
  t28_txn_ref VARCHAR2 (50 BYTE)
 )
/
