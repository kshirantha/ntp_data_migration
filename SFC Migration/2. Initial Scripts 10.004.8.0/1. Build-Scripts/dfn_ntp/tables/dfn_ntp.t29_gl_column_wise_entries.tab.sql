-- Table DFN_NTP.T29_GL_COLUMN_WISE_ENTRIES

CREATE TABLE dfn_ntp.t29_gl_column_wise_entries
(
    t29_id                     NUMBER (15, 0),
    t29_batch_id_t27           NUMBER (10, 0),
    t29_cash_account_id_u06    NUMBER (10, 0),
    t29_distribution_id_m139   NUMBER (15, 0),
    t29_txn_ref                VARCHAR2 (15),
    t29_txn_date               DATE,
    t29_settle_date            DATE,
    t29_narration              VARCHAR2 (500),
    t29_narration_lang         VARCHAR2 (500),
    t29_currency_code_m03      CHAR (3),
    t29_currency_id_m03        NUMBER (5, 0),
    t29_dr1_acc_cat_id_m134    NUMBER (10, 0),
    t29_dr1                    NUMBER (18, 5),
    t29_dr2_acc_cat_id_m134    NUMBER (10, 0),
    t29_dr2                    NUMBER (18, 5),
    t29_dr3_acc_cat_id_m134    NUMBER (10, 0),
    t29_dr3                    NUMBER (18, 5),
    t29_dr4_acc_cat_id_m134    NUMBER (10, 0),
    t29_dr4                    NUMBER (18, 5),
    t29_dr5_acc_cat_id_m134    NUMBER (10, 0),
    t29_dr5                    NUMBER (18, 5),
    t29_cr1_acc_cat_id_m134    NUMBER (10, 0),
    t29_cr1                    NUMBER (18, 5),
    t29_cr2_acc_cat_id_m134    NUMBER (10, 0),
    t29_cr2                    NUMBER (18, 5),
    t29_cr3_acc_cat_id_m134    NUMBER (10, 0),
    t29_cr3                    NUMBER (18, 5),
    t29_cr4_acc_cat_id_m134    NUMBER (10, 0),
    t29_cr4                    NUMBER (18, 5),
    t29_cr5_acc_cat_id_m134    NUMBER (10, 0),
    t29_cr5                    NUMBER (18, 5)
)
/

-- Constraints for  DFN_NTP.T29_GL_COLUMN_WISE_ENTRIES


  ALTER TABLE dfn_ntp.t29_gl_column_wise_entries ADD CONSTRAINT pk_t29 PRIMARY KEY (t29_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.t29_gl_column_wise_entries MODIFY (t29_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t29_gl_column_wise_entries MODIFY (t29_batch_id_t27 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t29_gl_column_wise_entries MODIFY (t29_cash_account_id_u06 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t29_gl_column_wise_entries MODIFY (t29_distribution_id_m139 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t29_gl_column_wise_entries MODIFY (t29_txn_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t29_gl_column_wise_entries MODIFY (t29_settle_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t29_gl_column_wise_entries MODIFY (t29_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t29_gl_column_wise_entries MODIFY (t29_currency_id_m03 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.T29_GL_COLUMN_WISE_ENTRIES


ALTER TABLE dfn_ntp.t29_gl_column_wise_entries
 MODIFY (
  t29_cash_account_id_u06 NULL
 )
/

CREATE INDEX dfn_ntp.idx_t29_batch_id_t27
    ON dfn_ntp.t29_gl_column_wise_entries (t29_batch_id_t27)
/

ALTER TABLE dfn_ntp.t29_gl_column_wise_entries
 ADD (
  t29_dr_1_acc_ref VARCHAR2 (50),
  t29_dr_2_acc_ref VARCHAR2 (50),
  t29_dr_3_acc_ref VARCHAR2 (50),
  t29_dr_4_acc_ref VARCHAR2 (50),
  t29_dr_5_acc_ref VARCHAR2 (50),
  t29_cr_1_acc_ref VARCHAR2 (50),
  t29_cr_2_acc_ref VARCHAR2 (50),
  t29_cr_3_acc_ref VARCHAR2 (50),
  t29_cr_4_acc_ref VARCHAR2 (50),
  t29_cr_5_acc_ref VARCHAR2 (50)
 )
/

ALTER TABLE dfn_ntp.t29_gl_column_wise_entries
 ADD (
  t29_source_ref VARCHAR2 (50),
  t29_distribution_ref VARCHAR2 (50)
 )
 MODIFY (
  t29_txn_ref VARCHAR2 (50 BYTE)
  )
/

ALTER TABLE dfn_ntp.t29_gl_column_wise_entries
 ADD (
  t29_event_ref_1 VARCHAR2 (50),
  t29_event_ref_2 VARCHAR2 (50),
  t29_event_ref_3 VARCHAR2 (50),
  t29_event_ref_4 VARCHAR2 (50),
  t29_event_ref_5 VARCHAR2 (50)
 )
/
