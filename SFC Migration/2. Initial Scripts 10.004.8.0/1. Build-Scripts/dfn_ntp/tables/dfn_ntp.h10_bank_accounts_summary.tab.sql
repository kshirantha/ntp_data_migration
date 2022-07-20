-- Table DFN_NTP.H10_BANK_ACCOUNTS_SUMMARY

CREATE TABLE dfn_ntp.h10_bank_accounts_summary
(
    h10_date               DATE,
    h10_account_id_m93     NUMBER (5, 0),
    h10_institute_id_m02   NUMBER (5, 0),
    h10_account_no         VARCHAR2 (50),
    h10_balance            NUMBER (18, 5),
    h10_currency           CHAR (3),
    h10_blocked_amount     NUMBER (18, 5),
    h10_od_limit           NUMBER (18, 5)
)
/

-- Constraints for  DFN_NTP.H10_BANK_ACCOUNTS_SUMMARY


  ALTER TABLE dfn_ntp.h10_bank_accounts_summary ADD CONSTRAINT h10_pk PRIMARY KEY (h10_date, h10_account_id_m93, h10_institute_id_m02)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.h10_bank_accounts_summary MODIFY (h10_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h10_bank_accounts_summary MODIFY (h10_account_id_m93 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h10_bank_accounts_summary MODIFY (h10_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h10_bank_accounts_summary MODIFY (h10_account_no NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h10_bank_accounts_summary MODIFY (h10_balance NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h10_bank_accounts_summary MODIFY (h10_currency NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h10_bank_accounts_summary MODIFY (h10_blocked_amount NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h10_bank_accounts_summary MODIFY (h10_od_limit NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.H10_BANK_ACCOUNTS_SUMMARY


CREATE INDEX dfn_ntp.idx_h10_date
    ON dfn_ntp.h10_bank_accounts_summary (h10_date)
/

CREATE INDEX dfn_ntp.idx_h10_account_id_m93
    ON dfn_ntp.h10_bank_accounts_summary (h10_account_id_m93)
/


-- End of DDL Script for Table DFN_NTP.H10_BANK_ACCOUNTS_SUMMARY
